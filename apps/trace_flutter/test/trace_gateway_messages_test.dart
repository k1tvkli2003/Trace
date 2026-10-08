import 'package:flutter_test/flutter_test.dart';
import 'package:trace_flutter/services/trace_gateway_messages.dart';

void main() {
  const allCodes = [
    'AI_RATE_LIMITED',
    'AI_PROVIDER_UNAVAILABLE',
    'AI_PROVIDER_FAILURE',
    'AI_RUN_IN_FLIGHT',
    'AI_RETRY_NOT_READY',
    'AI_UNAUTHORIZED',
    'AI_FORBIDDEN',
    'AI_PAGE_NOT_AUTHORIZED',
    'AI_VISION_REQUEST_INVALID',
    'AI_PAGE_IMAGE_INVALID',
    'AI_PAGE_IMAGE_MISMATCH',
    'AI_REQUEST_TOO_LARGE',
    'AI_BAD_REQUEST',
    'AI_GATEWAY_NOT_CONFIGURED',
    'AI_VISION_TRANSPORT_REQUIRED',
    'AI_ROUTE_NOT_ALLOWED',
    'AI_CAPABILITY_NOT_ALLOWED',
    'AI_RUN_CONFLICT',
    'AI_BUDGET_EXCEEDED',
    'AI_DEADLINE_EXCEEDED',
    'AI_ATTEMPTS_EXHAUSTED',
    'AI_SCHEMA_REJECTED',
    'AI_INCOMPLETE_RESPONSE',
    'AI_EMPTY_RESULT',
    'AI_OUTPUT_TOO_LARGE',
    'AI_OUTCOME_UNKNOWN',
    'AI_OPERATION_LIMIT_EXCEEDED',
  ];

  test('every known code maps to a non-empty safe message', () {
    for (final code in allCodes) {
      final result = traceGatewayMessage(code);
      expect(result.message, isNotEmpty, reason: code);
    }
  });

  test('no message leaks raw codes, statuses, or provider text', () {
    const banned = ['AI_', '429', '503', '500', 'http', 'Exception', 'TraceGateway'];
    for (final code in [...allCodes, '', 'AI_SOMETHING_NEW', 'boom']) {
      final message = traceGatewayMessage(code).message;
      for (final marker in banned) {
        expect(message.contains(marker), isFalse,
            reason: '$code message contains $marker');
      }
    }
  });

  test('retryable mirrors the server transient set exactly', () {
    const retryable = {
      'AI_RATE_LIMITED',
      'AI_PROVIDER_UNAVAILABLE',
      'AI_PROVIDER_FAILURE',
      'AI_RUN_IN_FLIGHT',
      'AI_RETRY_NOT_READY',
    };
    for (final code in allCodes) {
      expect(traceGatewayMessage(code).retryable, retryable.contains(code),
          reason: code);
    }
  });

  test('unknown and empty codes fall back with no retry', () {
    for (final code in ['', 'AI_SOMETHING_NEW', 'boom']) {
      final result = traceGatewayMessage(code);
      expect(result.retryable, isFalse, reason: code);
      expect(result.message, isNotEmpty, reason: code);
    }
  });
}
