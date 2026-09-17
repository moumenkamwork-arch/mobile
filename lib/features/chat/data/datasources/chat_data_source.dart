import '../dto/chat_dto.dart';

abstract interface class ChatDataSource {
  Future<ChatRoomsDto> fetchRooms({
    required String? accessToken,
    int page = 1,
    int limit = 20,
  });

  Future<ChatRoomDto> startChat({
    required String? accessToken,
    required String participantId,
  });

  Future<ChatMessagesDto> fetchMessages({
    required String? accessToken,
    required String roomId,
    int page = 1,
    int limit = 20,
  });

  Future<ChatMessageDto> sendMessage({
    required String? accessToken,
    required String roomId,
    required String content,
  });

  Future<void> markRoomRead({
    required String? accessToken,
    required String roomId,
  });
}
