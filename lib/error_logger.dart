import 'package:sentry/sentry.dart';

class ErrorLogger {
  static final SentryClient sentry = new SentryClient(
      dsn: 'https://35baeca1c4c84344aa9b2e04723a570d@sentry.io/1862927'
  );

  static void logError(dynamic error, [dynamic stackTrace = '']) async {
    try {
      var response = await ErrorLogger.sentry.captureException(
        exception: error,
        stackTrace: stackTrace
      );
      if (response.isSuccessful) {
        print('Success! Event ID: ${response.eventId}');
      } else {
        print('Failed to report to Sentry.io: ${response.error}');
      }
    } catch (error) {
      print('Failed to report to Sentry.io: $error');
      throw (error);
    }
  }
}