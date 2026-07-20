import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../auth/data/session/auth_session_store.dart';
import '../../data/realtime/chat_realtime_service.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/chat.dart';

/// Either an existing room (`roomId` set) or a fresh chat with a participant
/// that has no room yet (`participantId` set) — see [ChatRoomController].
/// A record gives value-based `==`/`hashCode` for free, which is what the
/// `.family` provider needs to key each open conversation correctly.
typedef ChatRoomArg = ({String? roomId, String? participantId});

/// Keyed by [ChatRoomArg] so each open conversation gets its own controller
/// and the id reaches [ChatRoomController] directly (a plain global provider
/// would read the root default and never see a nested ProviderScope override
/// — see [serviceDetailControllerProvider] for the same idiom).
final chatRoomControllerProvider =
    NotifierProvider.family<ChatRoomController, ChatRoomState, ChatRoomArg>(
      ChatRoomController.new,
    );

enum ChatRoomStatus { loading, success, empty, error, refreshing }

class ChatRoomState {
  const ChatRoomState({
    required this.status,
    this.roomId = '',
    this.messages = const [],
    this.failure,
  });

  const ChatRoomState.loading({required String roomId})
    : this(status: ChatRoomStatus.loading, roomId: roomId);

  const ChatRoomState.success({
    required String roomId,
    required List<ChatMessage> messages,
  }) : this(status: ChatRoomStatus.success, roomId: roomId, messages: messages);

  const ChatRoomState.empty({required String roomId})
    : this(status: ChatRoomStatus.empty, roomId: roomId);

  const ChatRoomState.error({
    required String roomId,
    required AppFailure failure,
    List<ChatMessage> messages = const [],
  }) : this(
         status: ChatRoomStatus.error,
         roomId: roomId,
         failure: failure,
         messages: messages,
       );

  const ChatRoomState.refreshing({
    required String roomId,
    required List<ChatMessage> messages,
  }) : this(
         status: ChatRoomStatus.refreshing,
         roomId: roomId,
         messages: messages,
       );

  final ChatRoomStatus status;
  final String roomId;
  final List<ChatMessage> messages;
  final AppFailure? failure;

  bool get isRefreshing => status == ChatRoomStatus.refreshing;

  bool get hasContent => messages.isNotEmpty;

  bool get isAuthRequired => failure?.type == AppFailureType.unauthorized;
}

class ChatRoomController extends Notifier<ChatRoomState> {
  ChatRoomController(this.arg);

  final ChatRoomArg arg;
  var _disposed = false;
  StreamSubscription<ChatMessage>? _realtimeSub;
  String? _currentUserId;

  /// Resolves once the real room id is known. For an existing room this
  /// completes immediately with `arg.roomId`; for a fresh chat it completes
  /// once the background `startChat` call returns.
  Completer<String>? _roomReady;

  @override
  ChatRoomState build() {
    ref.onDispose(() {
      _disposed = true;
      _realtimeSub?.cancel();
    });
    _realtimeSub = ref
        .read(chatRealtimeServiceProvider)
        .messages
        .listen(_onRealtimeMessage);

    final existingRoomId = arg.roomId;
    if (existingRoomId != null && existingRoomId.isNotEmpty) {
      _roomReady = Completer<String>()..complete(existingRoomId);
      unawaited(Future<void>.microtask(load));
      return ChatRoomState.loading(roomId: existingRoomId);
    }

    // Fresh chat: no room yet. Show an immediately-usable empty conversation
    // — matching a real messaging app — and resolve the real room (existing
    // or newly created) in the background instead of blocking navigation on
    // the network round-trip.
    _roomReady = Completer<String>();
    unawaited(Future<void>.microtask(_startThenLoad));
    return const ChatRoomState.empty(roomId: '');
  }

  Future<void> load() => _load(showLoading: true);

  Future<void> retry() => _load(showLoading: true);

  Future<void> refresh() => _load(refreshing: true);

  Future<void> sendText(String text) async {
    final content = text.trim();
    if (content.isEmpty) {
      return;
    }

    final roomId = await _resolvedRoomId();
    if (roomId == null || _disposed) {
      return;
    }

    final tempId = 'pending-${DateTime.now().microsecondsSinceEpoch}';
    final optimistic = ChatMessage(
      id: tempId,
      roomId: roomId,
      senderId: await _userId() ?? '',
      content: content,
      createdAt: DateTime.now(),
      isMine: true,
      status: ChatMessageStatus.sending,
    );
    if (_disposed) {
      return;
    }

    state = ChatRoomState.success(
      roomId: roomId,
      messages: appendSortedMessage(state.messages, optimistic),
    );

    final result = await ref
        .read(chatRepositoryProvider)
        .sendMessage(roomId: roomId, content: content);
    if (_disposed) {
      return;
    }

    state = result.when(
      // Upgrade the *same* optimistic bubble in place (sending → sent) rather
      // than removing it and inserting a fresh one — that swap is what made a
      // sent message flicker/duplicate. If the Realtime echo (below) already
      // reconciled this send, `reconcileConfirmedMessage` finds it by id and
      // no-ops.
      success: (message) => ChatRoomState.success(
        roomId: roomId,
        messages: reconcileConfirmedMessage(
          state.messages,
          message,
          tempId: tempId,
        ),
      ),
      failure: (_) => ChatRoomState.success(
        roomId: roomId,
        messages: markMessageFailed(state.messages, tempId),
      ),
    );
  }

  Future<void> markRead() async {
    if (state.roomId.trim().isEmpty) {
      return;
    }
    await ref.read(chatRepositoryProvider).markRoomRead(state.roomId);
  }

  Future<void> _startThenLoad() async {
    final participantId = arg.participantId;
    if (participantId == null || participantId.isEmpty) {
      return;
    }

    final result = await ref
        .read(chatRepositoryProvider)
        .startChat(participantId);
    if (_disposed) {
      return;
    }

    result.when(
      success: (room) {
        _roomReady?.complete(room.id);
        unawaited(_loadResolved(room.id));
      },
      failure: (failure) {
        _roomReady?.completeError(failure);
        state = ChatRoomState.error(roomId: '', failure: failure);
      },
    );
  }

  Future<String?> _resolvedRoomId() async {
    final ready = _roomReady;
    if (ready == null) {
      return null;
    }
    try {
      return await ready.future;
    } catch (_) {
      return null;
    }
  }

  Future<String?> _userId() async {
    if (_currentUserId != null) {
      return _currentUserId;
    }
    final session = await ref.read(authSessionStoreProvider).read();
    _currentUserId = session?.user.id;
    return _currentUserId;
  }

  Future<void> _load({bool showLoading = false, bool refreshing = false}) async {
    final roomId = await _resolvedRoomId();
    if (roomId == null || _disposed) {
      return;
    }
    await _loadResolved(
      roomId,
      showLoading: showLoading,
      refreshing: refreshing,
    );
  }

  Future<void> _loadResolved(
    String roomId, {
    bool showLoading = false,
    bool refreshing = false,
  }) async {
    final previousMessages = state.messages;
    if (refreshing) {
      state = ChatRoomState.refreshing(
        roomId: roomId,
        messages: previousMessages,
      );
    } else if (showLoading || state.roomId.isEmpty) {
      state = ChatRoomState.loading(roomId: roomId);
    }

    final result = await ref.read(chatRepositoryProvider).getMessages(roomId);
    if (_disposed) {
      return;
    }

    state = result.when(
      success: (messages) {
        unawaited(markRead());
        if (messages.isEmpty) {
          return ChatRoomState.empty(roomId: roomId);
        }
        return ChatRoomState.success(roomId: roomId, messages: messages);
      },
      failure: (failure) => ChatRoomState.error(
        roomId: roomId,
        failure: failure,
        messages: refreshing ? previousMessages : const [],
      ),
    );
  }

  void _onRealtimeMessage(ChatMessage message) {
    if (_disposed || state.roomId.isEmpty || message.roomId != state.roomId) {
      return;
    }
    state = ChatRoomState.success(
      roomId: state.roomId,
      messages: reconcileConfirmedMessage(state.messages, message),
    );
    // Only auto-mark read for messages the other side sent — echoes of my own
    // send shouldn't ping the read endpoint.
    if (!message.isMine) {
      unawaited(markRead());
    }
  }
}

/// Folds a server-confirmed [confirmed] message into [messages] without ever
/// producing a duplicate or a remove-then-insert flicker (WhatsApp-style).
/// Pure and top-level so the delivery logic — the trickiest part of the send
/// flow — can be unit-tested directly:
///
/// 1. Same real id already present → update in place (e.g. a read-receipt
///    that never downgrades a stronger local status).
/// 2. The exact optimistic row a send created ([tempId]) → upgrade it in place
///    (sending → sent).
/// 3. A Realtime echo of one of my own still-pending sends → match the oldest
///    pending row with the same text and upgrade it in place, so the echo and
///    the send-response converge on one bubble regardless of arrival order.
/// 4. Otherwise it's genuinely new → insert in chronological order.
List<ChatMessage> reconcileConfirmedMessage(
  List<ChatMessage> messages,
  ChatMessage confirmed, {
  String? tempId,
}) {
  // A just-sent message has no server "status"; surface it as "sent".
  final incoming =
      confirmed.isMine && confirmed.status == ChatMessageStatus.unknown
      ? confirmed.copyWith(status: ChatMessageStatus.sent)
      : confirmed;

  final next = [...messages];

  final byId = next.indexWhere((m) => m.id == incoming.id);
  if (byId != -1) {
    next[byId] = _mergeStatus(next[byId], incoming);
    return next;
  }

  if (tempId != null) {
    final ti = next.indexWhere((m) => m.id == tempId);
    if (ti != -1) {
      next[ti] = incoming;
      return next;
    }
  }

  if (incoming.isMine) {
    final pending = next.indexWhere(
      (m) =>
          m.isMine &&
          m.status == ChatMessageStatus.sending &&
          m.id.startsWith('pending-') &&
          m.content == incoming.content,
    );
    if (pending != -1) {
      next[pending] = incoming;
      return next;
    }
  }

  next.add(incoming);
  next.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  return next;
}

/// Keeps the more-advanced delivery status so a later duplicate INSERT can't
/// downgrade a message that's already shown as read.
ChatMessage _mergeStatus(ChatMessage existing, ChatMessage incoming) {
  return _statusRank(incoming.status) >= _statusRank(existing.status)
      ? incoming
      : incoming.copyWith(status: existing.status);
}

int _statusRank(ChatMessageStatus status) {
  return switch (status) {
    ChatMessageStatus.read => 3,
    ChatMessageStatus.delivered => 2,
    ChatMessageStatus.sent => 1,
    ChatMessageStatus.sending ||
    ChatMessageStatus.failed ||
    ChatMessageStatus.unknown => 0,
  };
}

List<ChatMessage> appendSortedMessage(
  List<ChatMessage> messages,
  ChatMessage message,
) {
  final next = [...messages, message];
  next.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  return next;
}

List<ChatMessage> markMessageFailed(
  List<ChatMessage> messages,
  String tempId,
) {
  return [
    for (final message in messages)
      if (message.id == tempId)
        message.copyWith(status: ChatMessageStatus.failed)
      else
        message,
  ];
}
