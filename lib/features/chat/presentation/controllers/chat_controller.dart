import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
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
}

class ChatController extends Notifier<ChatState> {
  var _disposed = false;

  @override
  ChatState build() {
    ref.onDispose(() => _disposed = true);
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
