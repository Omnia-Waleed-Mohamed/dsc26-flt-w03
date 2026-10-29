import 'package:flutter/material.dart';

import '../../domain/models/question.dart';

const _primary = Color(0xFF5946E8);
const _textColor = Color(0xFF172554);
const _mutedColor = Color(0xFF7180A3);
const _borderColor = Color(0xFFE7EAF4);

class QuestionList extends StatelessWidget {
  const QuestionList({
    super.key,
    required this.questions,
  });

  final List<Question> questions;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      children: [
        const Text(
          'Practice',
          style: TextStyle(
            color: _textColor,
            fontSize: 27,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Test your knowledge and move closer to your goal.',
          style: TextStyle(
            color: _mutedColor,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4332C7), Color(0xFF8475F5)],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: _primary.withValues(alpha: 0.16),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ready for the challenge?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Focus on each question and take your time.',
                      style: TextStyle(
                        color: Color(0xFFE9E6FF),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        Row(
          children: [
            const Text(
              'Practice Questions',
              style: TextStyle(
                color: _textColor,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFECE9FF),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                '${questions.length} questions',
                style: const TextStyle(
                  color: _primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...questions.asMap().entries.map(
          (entry) => QuestionCard(
            question: entry.value,
            number: entry.key + 1,
          ),
        ),
      ],
    );
  }
}

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.question,
    required this.number,
  });

  final Question question;
  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('question-${question.id}'),
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE9ECF5),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF18214D).withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9F7FC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Question $number',
                  style: const TextStyle(
                    color: Color(0xFF147D9A),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.menu_book_rounded,
                color: _mutedColor,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            question.stem,
            style: const TextStyle(
              color: _textColor,
              fontSize: 17,
              height: 1.8,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          ...question.choices.asMap().entries.map(
            (entry) => ChoiceTile(
              label: entry.value,
              letter: String.fromCharCode(65 + entry.key),
            ),
          ),
        ],
      ),
    );
  }
}

class ChoiceTile extends StatelessWidget {
  const ChoiceTile({
    super.key,
    required this.label,
    required this.letter,
  });

  final String label;
  final String letter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFE),
        border: Border.all(color: _borderColor),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFECE9FF),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              letter,
              style: const TextStyle(
                color: _primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: _textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(
            Icons.circle_outlined,
            color: Color(0xFFB7C0D8),
            size: 20,
          ),
        ],
      ),
    );
  }
}
