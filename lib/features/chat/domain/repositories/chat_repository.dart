import '../../../../core/utils/result.dart';
import '../entities/chat.dart';

abstract interface class ChatRepository {
  Future<Result<List<ChatRoom>>> getRooms({int page = 1, int limit = 20});

  Future<Result<ChatRoom>> startChat(String participantId);

  Future<Result<List<ChatMessage>>> getMessages(
    String roomId, {
    int page = 1,
    int limit = 20,
  });

  Future<Result<ChatMessage>> sendMessage({
    required String roomId,
    required String content,
  });

  Future<Result<void>> markRoomRead(String roomId);
}
