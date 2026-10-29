
import 'package:dsc26_flt_w03/data/repositories/practice_repository.dart';
import 'package:dsc26_flt_w03/domain/models/question.dart';
import 'package:dsc26_flt_w03/utils/result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'practice_state.dart';

class PracticeCubit extends Cubit<PracticeState> {
  PracticeCubit({
    required this.repository,
    required this.studentId,
  }) : super(const PracticeInitial());

  final PracticeRepository repository;
  final String studentId;

  bool _isLoading = false;

  Future<void> loadQuestions() async {
    // Do not start a request if the Cubit is closed
    // or another request is already running.
    if (isClosed || _isLoading) return;

    _isLoading = true;

    final currentState = state;

    if (currentState is PracticeSuccess) {
      emit(currentState.copyWith(isRefreshing: true));
    } else {
      emit(const PracticeLoading());
    }

    try {
      final result = await repository.nextQuestions(studentId);

      // The screen may have been disposed while waiting
      // for the repository response.
      if (isClosed) return;

      if (result is Ok<List<Question>>) {
        emit(
          PracticeSuccess(
            questions: result.value,
          ),
        );
      } else if (result is Err<List<Question>>) {
        emit(
          PracticeFailure(result.failure),
        );
      } else {
        emit(
          PracticeFailure(
            StateError('Unexpected result type'),
          ),
        );
      }
    } catch (_) {
      // Never emit a state after the Cubit is closed.
      if (isClosed) return;

      emit(
        const PracticeFailure(
          _UnexpectedFailure(),
        ),
      );
    } finally {
      _isLoading = false;
    }
  }
}

class _UnexpectedFailure {
  const _UnexpectedFailure();
}
