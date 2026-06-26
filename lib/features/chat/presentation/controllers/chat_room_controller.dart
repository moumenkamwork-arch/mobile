import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/chat.dart';

final chatRoomIdProvider = Provider<String>((ref) => '');

final chatRoomControllerProvider =
    NotifierProvider<ChatRoomController, ChatRoomState>(ChatRoomController.new);

enum ChatRoomStatus { loading, success, empty, error, refreshing, sending }

class ChatRoomState {
  const ChatRoomState({
    required this.status,
    this.roomId = '',
    this.messages = const [],
    this.failure,
    this.sendFailure,
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

  const ChatRoomState.sending({
    required String roomId,
    required List<ChatMessage> messages,
  }) : this(status: ChatRoomStatus.sending, roomId: roomId, messages: messages);

  const ChatRoomState.sendError({
    required String roomId,
    required List<ChatMessage> messages,
    required AppFailure sendFailure,
  }) : this(
         status: ChatRoomStatus.success,
         roomId: roomId,
         messages: messages,
         sendFailure: sendFailure,
       );

  final ChatRoomStatus status;
  final String roomId;
  final List<ChatMessage> messages;
  final AppFailure? failure;
  final AppFailure? sendFailure;

  bool get isRefreshing => status == ChatRoomStatus.refreshing;

  bool get isSending => status == ChatRoomStatus.sending;

  bool get hasContent => messages.isNotEmpty;

  bool get isAuthRequired => failure?.type == AppFailureType.unauthorized;
}

class ChatRoomController extends Notifier<ChatRoomState> {
  var _disposed = false;

  @override
  ChatRoomState build() {
    ref.onDispose(() => _disposed = true);
    final roomId = ref.watch(chatRoomIdProvider);
    unawaited(Future<void>.microtask(load));
    return ChatRoomState.loading(roomId: roomId);
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

  Future<void> sendText(String text) async {
    final content = text.trim();
    if (content.isEmpty || state.roomId.trim().isEmpty) {
      return;
    }

    final previousMessages = state.messages;
    state = ChatRoomState.sending(
      roomId: state.roomId,
      messages: previousMessages,
    );

    final result = await ref
        .read(chatRepositoryProvider)
        .sendMessage(roomId: state.roomId, content: content);
    if (_disposed) {
      return;
    }

    state = result.when(
      success: (message) {
        return ChatRoomState.success(
          roomId: state.roomId,
          messages: _mergeMessages(previousMessages, message),
        );
      },
      failure: (failure) => ChatRoomState.sendError(
        roomId: state.roomId,
        messages: previousMessages,
        sendFailure: failure,
      ),
    );
  }

  Future<void> markRead() async {
    if (state.roomId.trim().isEmpty) {
      return;
    }
    await ref.read(chatRepositoryProvider).markRoomRead(state.roomId);
  }

  Future<void> _load({
    bool showLoading = false,
    bool refreshing = false,
  }) async {
    final roomId = ref.read(chatRoomIdProvider);
    final previousMessages = state.messages;
    if (refreshing) {
      state = ChatRoomState.refreshing(
        roomId: roomId,
        messages: previousMessages,
      );
    } else if (showLoading) {
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

  List<ChatMessage> _mergeMessages(
    List<ChatMessage> previousMessages,
    ChatMessage message,
  ) {
    final merged = [
      for (final previous in previousMessages)
        if (previous.id != message.id) previous,
      message,
    ];
    merged.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return merged;
  }
}
