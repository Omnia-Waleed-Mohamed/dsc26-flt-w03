import 'package:dsc26_flt_w03/domain/models/question.dart';

abstract class PracticeState {
  const PracticeState();
}

class PracticeInitial extends PracticeState {
  const PracticeInitial();
}

class PracticeLoading extends PracticeState {
  const PracticeLoading();
}

class PracticeSuccess extends PracticeState {
  final List<Question> questions;
  final bool isRefreshing;

  const PracticeSuccess({
    required this.questions,
    this.isRefreshing = false,
  });

  PracticeSuccess copyWith({
    List<Question>? questions,
    bool? isRefreshing,
  }) {
    return PracticeSuccess(
      questions: questions ?? this.questions,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class PracticeFailure extends PracticeState {
  final Object failure;

  const PracticeFailure(this.failure);
}
