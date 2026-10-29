import 'package:dsc26_flt_w03/data/services/api_failure.dart';
import 'package:dsc26_flt_w03/data/services/question_api.dart';
import 'package:dsc26_flt_w03/domain/models/question.dart';
import 'package:dsc26_flt_w03/utils/result.dart';

class PracticeRepository {
  PracticeRepository({
    required QuestionApi api,
    required Future<void> Function(Duration) sleep,
    int maxRetries = 2,
  })  : _api = api,
        _sleep = sleep,
        _maxRetries = maxRetries;

  final QuestionApi _api;
  final Future<void> Function(Duration) _sleep;
  final int _maxRetries;

  Future<Result<List<Question>>> nextQuestions(String studentId) async {
    int attempt = 0;
    while (true) {
      final result = await _api.fetchNext(studentId: studentId);

      if (result is Ok<List<Question>>) {
        return result;
      }

      final errResult = result as Err<List<Question>>;
      final failure = errResult.failure;

      
      if (!failure.isTransient || attempt >= _maxRetries) {
        return result;
      }

      
      Duration waitDuration;
      if (failure is RateLimited) {
    
        final secs = failure.retryAfter.inSeconds > 30 ? 30 : failure.retryAfter.inSeconds;
        waitDuration = Duration(seconds: secs);
      } else {
        
        final seconds = 1 << attempt; 
        waitDuration = Duration(seconds: seconds);
      }

      await _sleep(waitDuration);
      attempt++;
    }
  }
}