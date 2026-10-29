/// One practice question chosen for a student by the Masaraat backend.
final class Question {
  const Question({
    required this.id,
    required this.skillId,
    required this.stem,
    required this.choices,
  });

  final String id;
  final String skillId;
  final String stem;
  final List<String> choices;

  /// Reads one question from the API. Unknown fields are ignored.
  factory Question.fromJson(Map<String, Object?> json) {
    final idVal = json['id'];
    if (idVal is! String || idVal.isEmpty) {
      throw const FormatException('Missing or invalid id');
    }

    final skillIdVal = json['skillId'];
    if (skillIdVal is! String || skillIdVal.isEmpty) {
      throw const FormatException('Missing or invalid skillId');
    }

    final stemVal = json['stem'];
    if (stemVal is! String || stemVal.isEmpty) {
      throw const FormatException('Missing or invalid stem');
    }

    final choicesVal = json['choices'];
    if (choicesVal is! List) {
      throw const FormatException('Missing or invalid choices list');
    }

    final choicesList = <String>[];
    for (final c in choicesVal) {
      if (c is! String || c.isEmpty) {
        throw const FormatException('Invalid choice item');
      }
      choicesList.add(c);
    }

    if (choicesList.length < 2 || choicesList.length > 6) {
      throw const FormatException('Choices count must be between 2 and 6');
    }

    return Question(
      id: idVal,
      skillId: skillIdVal,
      stem: stemVal,
      choices: choicesList,
    );
  }
}