/// Safe user-facing copy for Trace sign-in failures. No raw server text.
///
/// Maps stable [TraceAuthFailure] codes to short English messages for UI
/// surfaces (inline error/snackbar). Never includes raw codes, status
/// numbers, or provider text. `retryable` mirrors the client contract:
/// only rate-limited and network-unavailable allow a retry action.
library;

const _invalidEmail = 'Please enter a valid email address.';
const _weakPassword = 'Password must be at least 6 characters.';
const _invalidCredentials =
    'Email or password is incorrect. Please check both and try again.';
const _accountExists =
    'This email already has an account. Please sign in with your password.';
const _invalidRequest =
    'This sign-in request could not be processed. Please check your details and try again.';
const _network =
    'No connection to the sign-in service. Please check your connection and try again.';
const _rateLimited =
    'Too many sign-in attempts. Please wait a moment and try again.';
const _unavailable =
    'Sign-in is temporarily unavailable. Please try again later.';
const _unknown =
    'Sign-in could not be completed. Please try again later.';

/// Returns the safe message plus whether a retry action is allowed.
///
/// Unknown or empty codes fall back to [_unknown] with no retry.
({String message, bool retryable}) traceAuthMessage(String code) {
  return switch (code) {
    'AUTH_INVALID_EMAIL' => (message: _invalidEmail, retryable: false),
    'AUTH_WEAK_PASSWORD' => (message: _weakPassword, retryable: false),
    'AUTH_INVALID_CREDENTIALS' =>
      (message: _invalidCredentials, retryable: false),
    'AUTH_ACCOUNT_EXISTS_SIGN_IN' =>
      (message: _accountExists, retryable: false),
    'AUTH_REQUEST_INVALID' => (message: _invalidRequest, retryable: false),
    'AUTH_NETWORK_UNAVAILABLE' => (message: _network, retryable: true),
    'AUTH_RATE_LIMITED' => (message: _rateLimited, retryable: true),
    'AUTH_SERVICE_UNAVAILABLE' => (message: _unavailable, retryable: true),
    _ => (message: _unknown, retryable: false),
  };
}
