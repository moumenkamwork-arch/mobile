import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../dto/chat_dto.dart';
import 'chat_data_source.dart';

final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  return ChatRemoteDataSource(ref.watch(apiClientProvider));
});

/// Real chat over REST. The Bearer token is injected by the API client's
/// interceptor (from `AuthSessionStore`), so the `accessToken` the repository
/// passes is unused here — kept in the interface for the fake/offline path.
/// Live message push (Supabase Realtime) is a separate, deferred enhancement
/// (see docs/v2_deferred_scope.md / Realtime-Chat-Flutter-Guide.md); v1 loads
/// messages on open + after send.
class ChatRemoteDataSource implements ChatDataSource {
  const ChatRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<ChatRoomsDto> fetchRooms({
    required String? accessToken,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _apiClient.get<ChatRoomsDto>(
      ApiEndpoints.chats,
      queryParameters: {'page': page, 'limit': limit},
      decode: ChatRoomsDto.fromJsonFlexible,
    );
    return response.data ?? ChatRoomsDto.empty();
  }

  @override
  Future<ChatRoomDto> startChat({
    required String? accessToken,
    required String participantId,
  }) async {
    final response = await _apiClient.post<ChatRoomDto>(
      ApiEndpoints.chats,
      data: {'participant_id': participantId},
      decode: (data) => ChatRoomDto.fromJson(_asMap(data)),
    );
    return response.data ?? const ChatRoomDto();
  }

  @override
  Future<ChatMessagesDto> fetchMessages({
    required String? accessToken,
    required String roomId,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _apiClient.get<ChatMessagesDto>(
      ApiEndpoints.chatMessages(roomId),
      queryParameters: {'page': page, 'limit': limit},
      decode: ChatMessagesDto.fromJsonFlexible,
    );
    return response.data ?? ChatMessagesDto.empty();
  }

  @override
  Future<ChatMessageDto> sendMessage({
    required String? accessToken,
    required String roomId,
    required String content,
  }) async {
    final response = await _apiClient.post<ChatMessageDto>(
      ApiEndpoints.chatMessages(roomId),
      data: {'content': content},
      decode: (data) => ChatMessageDto.fromJson(_asMap(data), fallbackRoomId: roomId),
    );
    return response.data ?? const ChatMessageDto();
  }

  @override
  Future<void> markRoomRead({
    required String? accessToken,
    required String roomId,
  }) async {
    await _apiClient.patch<void>(
      ApiEndpoints.markChatRead(roomId),
      decode: (_) {},
    );
  }

  static Map<String, Object?> _asMap(Object? data) {
    if (data is Map<String, Object?>) return data;
    if (data is Map) return Map<String, Object?>.from(data);
    return const {};
  }
}
