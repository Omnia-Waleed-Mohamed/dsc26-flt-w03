import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/practice_repository.dart';
import '../logic/practice_cubit.dart';
import '../logic/practice_state.dart';
import 'practice_question_list.dart';
import 'practice_status_views.dart';

const _primary = Color(0xFF5946E8);
const _background = Color(0xFFF7F8FC);
const _textColor = Color(0xFF172554);

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({
    super.key,
    required this.repository,
    required this.studentId,
  });

  final PracticeRepository repository;
  final String studentId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PracticeCubit(
        repository: repository,
        studentId: studentId,
      )..loadQuestions(),
      child: const _PracticeView(),
    );
  }
}

class _PracticeView extends StatelessWidget {
  const _PracticeView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PracticeCubit>();

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 20,
          title: const Row(
            children: [
              CircleAvatar(
                radius: 19,
                backgroundColor: Color(0xFFECE9FF),
                child: Icon(
                  Icons.auto_stories_rounded,
                  color: _primary,
                  size: 22,
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Masaraat',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          actions: [
            BlocBuilder<PracticeCubit, PracticeState>(
              builder: (context, state) {
                final isLoading =
                    state is PracticeLoading ||
                    (state is PracticeSuccess && state.isRefreshing);

                return IconButton(
                  key: const ValueKey('practice-refresh'),
                  tooltip: 'Refresh questions',
                  onPressed: isLoading ? null : cubit.loadQuestions,
                  icon: const Icon(Icons.refresh_rounded),
                );
              },
            ),
            const SizedBox(width: 8),
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFEAECF5),
            ),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<PracticeCubit, PracticeState>(
            builder: (context, state) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: _buildContent(
                  state,
                  cubit.loadQuestions,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    PracticeState state,
    VoidCallback onRetry,
  ) {
    if (state is PracticeInitial || state is PracticeLoading) {
      return const LoadingView(
        key: ValueKey('practice-loading'),
      );
    }

    if (state is PracticeFailure) {
      return ErrorView(
        key: const ValueKey('practice-error'),
        failure: state.failure,
        onRetry: onRetry,
      );
    }

    if (state is PracticeSuccess) {
      if (state.questions.isEmpty) {
        return const EmptyView(
          key: ValueKey('practice-empty'),
        );
      }

      return Stack(
        key: const ValueKey('practice-list'),
        children: [
          QuestionList(
            questions: state.questions,
          ),
          if (state.isRefreshing)
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                key: ValueKey('practice-loading'),
                color: _primary,
                backgroundColor: Color(0xFFECE9FF),
              ),
            ),
        ],
      );
    }

    return const LoadingView(
      key: ValueKey('practice-loading'),
    );
  }
}
