import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/realtime/chat_realtime_service.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/chat.dart';

final chatControllerProvider = NotifierProvider<ChatController, ChatState>(
  ChatController.new,
);

enum ChatStatus { loading, success, empty, error, refreshing }

class ChatState {
  const ChatState({required this.status, this.rooms = const [], this.failure});

  const ChatState.loading() : this(status: ChatStatus.loading);

  const ChatState.success({required List<ChatRoom> rooms})
    : this(status: ChatStatus.success, rooms: rooms);

  const ChatState.empty() : this(status: ChatStatus.empty);

  const ChatState.error({
    required AppFailure failure,
    List<ChatRoom> rooms = const [],
  }) : this(status: ChatStatus.error, failure: failure, rooms: rooms);

  const ChatState.refreshing({required List<ChatRoom> rooms})
    : this(status: ChatStatus.refreshing, rooms: rooms);

  final ChatStatus status;
  final List<ChatRoom> rooms;
  final AppFailure? failure;

  bool get isRefreshing => status == ChatStatus.refreshing;

  bool get hasContent => rooms.isNotEmpty;

  bool get isAuthRequired => failure?.type == AppFailureType.unauthorized;

  /// Total unread messages across all rooms — drives the header chat badge.
  int get totalUnread {
    var total = 0;
    for (final room in rooms) {
      total += room.unreadCount;
    }
    return total;
  }
}

class ChatController extends Notifier<ChatState> {
  var _disposed = false;
  StreamSubscription<ChatMessage>? _realtimeSub;

  @override
  ChatState build() {
    ref.onDispose(() {
      _disposed = true;
      _realtimeSub?.cancel();
    });

    // The list is fetched once at first build, which for most sessions
    // happens while still a guest (the header mounts before login) — without
    // this, the room list (and the header's unread badge, which derives from
    // it) would stay empty/stale forever after signing in.
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      final wasAuthed = previous?.isAuthenticated ?? false;
      if (next.isAuthenticated != wasAuthed) {
        unawaited(load());
      }
    });

    // Any new message anywhere (mine or theirs) can change unread counts,
    // ordering, or the last-message preview — a silent refresh keeps the
    // list and header badge live instead of only updating on manual pull.
    _realtimeSub = ref
        .read(chatRealtimeServiceProvider)
        .messages
        .listen((_) => unawaited(refresh()));

    unawaited(Future<void>.microtask(load));
    return const ChatState.loading();
  }

  Future<void> load() {
    return _load(showLoading: true);
  }

  Future<void> retry() {
    return _load(showLoading: true);
  }

  Future<void> refresh() {
    return _load(refreshing: true);
  }

  Future<void> _load({
    bool showLoading = false,
    bool refreshing = false,
  }) async {
    final previousRooms = state.rooms;
    if (refreshing) {
      state = ChatState.refreshing(rooms: previousRooms);
    } else if (showLoading) {
      state = const ChatState.loading();
    }

    final result = await ref.read(chatRepositoryProvider).getRooms();
    if (_disposed) {
      return;
    }

    state = result.when(
      success: (rooms) {
        if (rooms.isEmpty) {
          return const ChatState.empty();
        }
        return ChatState.success(rooms: rooms);
      },
      failure: (failure) => ChatState.error(
        failure: failure,
        rooms: refreshing ? previousRooms : const [],
      ),
    );
  }
}
