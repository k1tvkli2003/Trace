import 'package:test/test.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  final threadJson = <String, Object?>{
    'id': 'thread-1',
    'version': 1,
    'contentHash': 'a' * 64,
    'libraryId': 'library-1',
    'targetNodeId': 'node-1',
    'targetSliceId': 'slice-1',
    'title': 'گفتگو درباره فصل اول',
    'status': 'active',
    'createdAt': '2026-09-23T10:30:00Z',
    'updatedAt': '2026-09-23T10:35:00Z',
  };

  final messageJson = <String, Object?>{
    'id': 'message-1',
    'version': 1,
    'contentHash': 'b' * 64,
    'threadId': 'thread-1',
    'role': 'assistant',
    'body': 'توضیح منبع محور.',
    'sourceCitationIds': ['citation-1'],
    'toolInvocationId': null,
    'createdAt': '2026-09-23T10:35:00Z',
  };

  test('ChatThread round-trips target context and UTC lifecycle', () {
    final thread = ChatThread.fromJson(threadJson);
    expect(thread.status, ChatThreadStatus.active);
    expect(thread.toJson(), threadJson);
  });

  test('ChatMessage round-trips role, citations, and tool link', () {
    final message = ChatMessage.fromJson(messageJson);
    expect(message.role, ChatMessageRole.assistant);
    expect(message.toJson(), messageJson);
  });

  test('unknown chat role and status remain unsupported', () {
    expect(
      ChatThread.fromJson({...threadJson, 'status': 'future'}).status,
      ChatThreadStatus.unsupported,
    );
    expect(
      ChatMessage.fromJson({...messageJson, 'role': 'future'}).role,
      ChatMessageRole.unsupported,
    );
  });

  test('chat models reject duplicate citations and invalid lifecycle order', () {
    expect(
      () => ChatMessage.fromJson({...messageJson, 'sourceCitationIds': ['citation-1', 'citation-1']}),
      throwsFormatException,
    );
    expect(
      () => ChatThread.fromJson({...threadJson, 'updatedAt': '2026-09-23T10:29:00Z'}),
      throwsFormatException,
    );
  });
}
