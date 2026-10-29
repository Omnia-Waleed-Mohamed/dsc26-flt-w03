import 'package:flutter/material.dart';

import '../data/repositories/practice_repository.dart';
import 'widget/practice_screen.dart';

const _primary = Color(0xFF5946E8);

Widget buildPracticeApp({
  required PracticeRepository repository,
  String studentId = 'demo',
}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Masaraat Practice',
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF7F8FC),
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primary,
        primary: _primary,
        surface: Colors.white,
      ),
      fontFamily: 'Cairo',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF172554),
        elevation: 0,
        centerTitle: false,
      ),
    ),
    home: PracticeScreen(
      repository: repository,
      studentId: studentId,
    ),
  );
}
