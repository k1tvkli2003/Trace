/// Safe user-facing copy for Trace gateway failures. No secret handling.
///
/// Maps stable [TraceGatewayFailure]/server codes to short English messages
/// for UI surfaces (snackbar/banner/dialog). Never includes raw codes,
/// status numbers, or provider text. `retryable` mirrors the server
/// retryable set exactly: only transient codes allow a Retry action.
library;

const _busy =
    'The AI service is busy right now. Your work is kept — please try again shortly.';
const _unavailable =
    'The AI service is temporarily unavailable. Your work is kept — please try again.';
const _wait =
    'A request is already running. Please wait a moment, then try again.';
const _signIn = 'Please sign in again to use AI features.';
const _page =
    'This page could not be processed. Please try another page or re-import the source.';
const _notAvailable =
    'This AI feature is not available on this device right now.';
const _kept =
    'The AI request could not be completed. Your work is kept — please try again.';
const _unknown =
    'Something went wrong with the AI request. Your work is kept — please try again later.';

/// Returns the safe message plus whether a Retry action is allowed.
///
/// Unknown or empty codes fall back to [_unknown] with no retry.
({String message, bool retryable}) traceGatewayMessage(String code) {
  return switch (code) {
    'AI_RATE_LIMITED' => (message: _busy, retryable: true),
    'AI_PROVIDER_UNAVAILABLE' || 'AI_PROVIDER_FAILURE' =>
      (message: _unavailable, retryable: true),
    'AI_RUN_IN_FLIGHT' || 'AI_RETRY_NOT_READY' =>
      (message: _wait, retryable: true),
    'AI_UNAUTHORIZED' || 'AI_FORBIDDEN' || 'AI_PAGE_NOT_AUTHORIZED' =>
      (message: _signIn, retryable: false),
    'AI_VISION_REQUEST_INVALID' ||
    'AI_PAGE_IMAGE_INVALID' ||
    'AI_PAGE_IMAGE_MISMATCH' ||
    'AI_REQUEST_TOO_LARGE' ||
    'AI_BAD_REQUEST' =>
      (message: _page, retryable: false),
    'AI_GATEWAY_NOT_CONFIGURED' ||
    'AI_VISION_TRANSPORT_REQUIRED' ||
    'AI_ROUTE_NOT_ALLOWED' ||
    'AI_CAPABILITY_NOT_ALLOWED' =>
      (message: _notAvailable, retryable: false),
    'AI_RUN_CONFLICT' ||
    'AI_BUDGET_EXCEEDED' ||
    'AI_DEADLINE_EXCEEDED' ||
    'AI_ATTEMPTS_EXHAUSTED' ||
    'AI_SCHEMA_REJECTED' ||
    'AI_INCOMPLETE_RESPONSE' ||
    'AI_EMPTY_RESULT' ||
    'AI_OUTPUT_TOO_LARGE' ||
    'AI_OUTCOME_UNKNOWN' ||
    'AI_OPERATION_LIMIT_EXCEEDED' =>
      (message: _kept, retryable: false),
    _ => (message: _unknown, retryable: false),
  };
}
