import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/features/chat/domain/entities/chat.dart';
import 'package:promoo_app/features/chat/presentation/controllers/chat_room_controller.dart';

/// The send flow: an optimistic bubble is added, then the send API response and
/// the Realtime echo both arrive (in either order). These tests pin the
/// WhatsApp-style guarantee — exactly one bubble, upgraded in place, never a
/// duplicate or a flicker.
void main() {
  ChatMessage optimistic(String tempId, String text) => ChatMessage(
    id: tempId,
    roomId: 'room-1',
    senderId: 'me',
    content: text,
    createdAt: DateTime(2026, 6, 26, 9, 0, 0),
    isMine: true,
    status: ChatMessageStatus.sending,
  );

  ChatMessage confirmed(String id, String text, {bool isMine = true}) =>
      ChatMessage(
        id: id,
        roomId: 'room-1',
        senderId: isMine ? 'me' : 'them',
        content: text,
        createdAt: DateTime(2026, 6, 26, 9, 0, 1),
        isMine: isMine,
        status: ChatMessageStatus.unknown,
      );

  test('send response upgrades the optimistic bubble in place (no duplicate)', () {
    final list = appendSortedMessage(const [], optimistic('pending-1', 'hi'));
    expect(list, hasLength(1));
    expect(list.single.status, ChatMessageStatus.sending);

    final reconciled = reconcileConfirmedMessage(
      list,
      confirmed('real-1', 'hi'),
      tempId: 'pending-1',
    );

    expect(reconciled, hasLength(1), reason: 'must not duplicate');
    expect(reconciled.single.id, 'real-1');
    expect(reconciled.single.status, ChatMessageStatus.sent);
  });

  test('realtime echo arriving BEFORE the send response — still one bubble', () {
    final list = appendSortedMessage(const [], optimistic('pending-1', 'hi'));

    // Echo (real id, my message, same text) lands first with no tempId.
    final afterEcho = reconcileConfirmedMessage(list, confirmed('real-1', 'hi'));
    expect(afterEcho, hasLength(1), reason: 'echo reconciles the pending row');
    expect(afterEcho.single.id, 'real-1');
    expect(afterEcho.single.status, ChatMessageStatus.sent);

    // Then the send response arrives for the same message.
    final afterResponse = reconcileConfirmedMessage(
      afterEcho,
      confirmed('real-1', 'hi'),
      tempId: 'pending-1',
    );
    expect(afterResponse, hasLength(1), reason: 'no second bubble');
    expect(afterResponse.single.id, 'real-1');
  });

  test('a read-receipt update never downgrades a delivered/read bubble', () {
    final sent = [confirmed('real-1', 'hi').copyWith(status: ChatMessageStatus.read)];

    // A duplicate INSERT-style event (status sent) must not undo "read".
    final merged = reconcileConfirmedMessage(sent, confirmed('real-1', 'hi'));
    expect(merged, hasLength(1));
    expect(merged.single.status, ChatMessageStatus.read);
  });

  test("the other side's new message is appended in order", () {
    final mine = appendSortedMessage(const [], optimistic('pending-1', 'hi'));
    final withReply = reconcileConfirmedMessage(
      mine,
      confirmed('real-2', 'hey', isMine: false),
    );
    expect(withReply, hasLength(2));
    expect(withReply.last.id, 'real-2');
    expect(withReply.last.isMine, isFalse);
  });

  test('a failed send marks the same bubble failed (no removal)', () {
    final list = appendSortedMessage(const [], optimistic('pending-1', 'hi'));
    final failed = markMessageFailed(list, 'pending-1');
    expect(failed, hasLength(1));
    expect(failed.single.status, ChatMessageStatus.failed);
  });
}
