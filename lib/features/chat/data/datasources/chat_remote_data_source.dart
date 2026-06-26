import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../dto/chat_dto.dart';
import 'chat_data_source.dart';

final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  return ChatRemoteDataSource(ref.watch(apiClientProvider));
});

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
      headers: _authHeaders(accessToken),
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
      headers: _authHeaders(accessToken),
      data: {'participant_id': participantId},
      decode: (data) {
        final rooms = ChatRoomsDto.fromJsonFlexible(data).rooms;
        if (rooms.isEmpty) {
          throw const FormatException('Expected chat room object.');
        }
        return rooms.first;
      },
    );

    final room = response.data;
    if (room == null) {
      throw const FormatException('Expected chat room object.');
    }
    return room;
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
      headers: _authHeaders(accessToken),
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
      headers: _authHeaders(accessToken),
      data: {'content': content, 'type': 'text'},
      decode: (data) {
        final messages = ChatMessagesDto.fromJsonFlexible(data).messages;
        if (messages.isEmpty) {
          throw const FormatException('Expected chat message object.');
        }
        return messages.first;
      },
    );

    final message = response.data;
    if (message == null) {
      throw const FormatException('Expected chat message object.');
    }
    return message;
  }

  @override
  Future<void> markRoomRead({
    required String? accessToken,
    required String roomId,
  }) async {
    await _apiClient.patch<void>(
      ApiEndpoints.markChatRead(roomId),
      headers: _authHeaders(accessToken),
    );
  }
}

Map<String, Object?>? _authHeaders(String? accessToken) {
  if (accessToken == null || accessToken.trim().isEmpty) {
    return null;
  }
  return {'Authorization': 'Bearer $accessToken'};
}
