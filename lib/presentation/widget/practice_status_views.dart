import 'package:flutter/material.dart';

import '../../data/services/api_failure.dart';

const _primary = Color(0xFF5946E8);
const _textColor = Color(0xFF172554);
const _mutedColor = Color(0xFF7180A3);

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LoadingIllustration(),
            SizedBox(height: 28),
            SizedBox(
              width: 34,
              height: 34,
              child: CircularProgressIndicator(strokeWidth: 3, color: _primary),
            ),
            SizedBox(height: 22),
            Text(
              'Loading questions...',
              style: TextStyle(
                color: _textColor,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Just a moment while we prepare your practice session.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _mutedColor, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingIllustration extends StatelessWidget {
  const LoadingIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: const BoxDecoration(
        color: Color(0xFFECE9FF),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.auto_stories_rounded, size: 76, color: _primary),
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.failure, required this.onRetry});

  final Object failure;
  final VoidCallback onRetry;

  bool get _isUnauthorized => failure is Unauthorized;

  IconData get _icon {
    if (failure is Offline) return Icons.wifi_off_rounded;
    if (failure is TimedOut) {
      return Icons.hourglass_bottom_rounded;
    }
    if (failure is RateLimited) {
      return Icons.timer_outlined;
    }
    if (failure is Unauthorized) {
      return Icons.lock_outline_rounded;
    }
    if (failure is NotFound) {
      return Icons.search_off_rounded;
    }
    if (failure is ServerError) return Icons.dns_rounded;

    return Icons.sentiment_dissatisfied_rounded;
  }

  String get _title {
    if (failure is Offline) return 'No internet connection';
    if (failure is TimedOut) return 'Connection timed out';
    if (failure is RateLimited) return 'Too many requests';
    if (failure is Unauthorized) return 'Session expired';
    if (failure is NotFound) return 'Questions not found';
    if (failure is ServerError) {
      return 'Server is temporarily unavailable';
    }

    return 'Something went wrong';
  }

  String get _message {
    if (failure is Offline) {
      return 'Check your internet connection and try again.';
    }

    if (failure is TimedOut) {
      return 'The connection took longer than expected. Please try again.';
    }

    if (failure is RateLimited) {
      final retryAfter = (failure as RateLimited).retryAfter;

      if (retryAfter.inSeconds > 0) {
        return 'Please wait ${retryAfter.inSeconds} seconds before trying again.';
      }

      return 'You have made too many attempts. Wait a moment before trying again.';
    }

    if (failure is Unauthorized) {
      return 'Please sign in again to continue your practice session.';
    }

    if (failure is NotFound) {
      return 'Questions may not be available right now. Please try again later.';
    }

    if (failure is ServerError) {
      return 'We are experiencing temporary issues. Please try again shortly.';
    }

    return 'An unexpected error occurred while loading questions. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 144,
                height: 144,
                decoration: const BoxDecoration(
                  color: Color(0xFFECE9FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(_icon, size: 68, color: _primary),
              ),
              const SizedBox(height: 26),
              Text(
                _title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _textColor,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _mutedColor,
                  fontSize: 14,
                  height: 1.9,
                ),
              ),
              const SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  key: ValueKey(
                    _isUnauthorized ? 'practice-signin' : 'practice-retry',
                  ),
                  onPressed: _isUnauthorized
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please sign in through the main application.',
                              ),
                            ),
                          );
                        }
                      : onRetry,
                  icon: Icon(
                    _isUnauthorized
                        ? Icons.login_rounded
                        : Icons.refresh_rounded,
                  ),
                  label: Text(_isUnauthorized ? 'Sign in' : 'Try again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 144,
              height: 144,
              decoration: const BoxDecoration(
                color: Color(0xFFECE9FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.task_alt_rounded,
                size: 72,
                color: _primary,
              ),
            ),
            const SizedBox(height: 26),
            const Text(
              'You have completed your practice!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _textColor,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'There are no more questions available right now.\n'
              'Come back later for more practice.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _mutedColor, fontSize: 14, height: 1.9),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'You can close this screen and return later.',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.home_rounded),
                label: const Text('Back'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _primary,
                  side: const BorderSide(color: Color(0xFFD9D3FF)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
