import 'dart:convert';
import 'package:dsc26_flt_w03/domain/models/question.dart';
import 'package:dsc26_flt_w03/utils/result.dart';
import 'package:http/http.dart' as http;
import 'api_failure.dart';

/// One call to the Masaraat questions API. Holds no state and never retries.
class QuestionApi {
  QuestionApi({
    required http.Client client,
    required Uri baseUrl,
    Duration timeout = const Duration(seconds: 10),
  })  : _client = client,
        _baseUrl = baseUrl,
        _timeout = timeout;

  final http.Client _client;
  final Uri _baseUrl;
  final Duration _timeout;

  Future<Result<List<Question>>> fetchNext({
    required String studentId,
    int limit = 10,
  }) async {
    if (limit < 1 || limit > 50) {
      throw ArgumentError.value(limit, 'limit', 'Must be between 1 and 50');
    }

    try {
      // Build path segments safely
      final baseSegments = _baseUrl.pathSegments.where((s) => s.isNotEmpty).toList();
      final targetSegments = [...baseSegments, 'v1', 'students', studentId, 'next-questions'];

      final uri = _baseUrl.replace(
        pathSegments: targetSegments,
        queryParameters: {'limit': limit.toString()},
      );

      final response = await _client.get(
        uri,
        headers: {'accept': 'application/json'},
      ).timeout(_timeout);

      final statusCode = response.statusCode;

      if (statusCode == 200) {
        try {
          // Decode bytes as UTF-8
          final decodedString = utf8.decode(response.bodyBytes);
          final jsonMap = jsonDecode(decodedString);

          if (jsonMap is! Map<String, Object?>) {
            return const Err(BadResponse('Top-level JSON is not a map'));
          }

          final questionsList = jsonMap['questions'];
          if (questionsList is! List) {
            return const Err(BadResponse('Missing questions list'));
          }

          final parsedQuestions = <Question>[];
          for (final item in questionsList) {
            if (item is! Map<String, Object?>) {
              return const Err(BadResponse('Question item is not a map'));
            }
            parsedQuestions.add(Question.fromJson(item));
          }

          return Ok(parsedQuestions);
        } catch (e) {
          return Err(BadResponse(e.toString()));
        }
      } else if (statusCode == 401) {
        return const Err(Unauthorized());
      } else if (statusCode == 404) {
        return const Err(NotFound());
      } else if (statusCode == 429) {
        Duration retryAfterDuration = const Duration(seconds: 5);
        final headerVal = response.headers['retry-after'];
        if (headerVal != null) {
          final seconds = int.tryParse(headerVal);
          if (seconds != null) {
            retryAfterDuration = Duration(seconds: seconds);
          }
        }
        return Err(RateLimited(retryAfterDuration));
      } else if (statusCode >= 500 && statusCode <= 599) {
        return Err(ServerError(statusCode));
      } else {
        return Err(UnexpectedStatus(statusCode));
      }
    } on http.ClientException {
      return const Err(Offline());
    } catch (_) {
      return const Err(TimedOut());
    }
  }
}