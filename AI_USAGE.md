# AI usage: dsc26-flt-w03

AI tools are allowed in this task. Fill in every section in your own words. This file is read by your Track Mentor, not by the grader.

## 1. Tools I used

Gemini as a collaborative AI assistant to structure the asynchronous state logic, design clean UI states matching the practice requirements, and ensure robust error handling.

## 2. The prompts that helped most

1. "How to safely decode HTTP response bytes as UTF-8 in Dart when handling Arabic text payloads regardless of missing or incorrect Content-Type headers."
2. "How to properly implement `_isDisposed` flags and checks before calling `setState` after asynchronous operations in a Flutter `StatefulWidget` to prevent memory leaks and widget tree exceptions."

## 3. Where the assistant's code would have failed a hidden-test area, and how I noticed

In row **H13** (leaving mid-request), a naive AI-generated implementation would call `setState()` after an `await` without checking if the widget is still mounted or disposed (e.g., when the test widget calls `tester.pumpWidget(const SizedBox())`). I noticed this requirement in the task instructions and explicitly added the `_isDisposed` flag check after every asynchronous delay/request before updating the UI.

## 4. My state-management choice

I chose Flutter Bloc's Cubit for state management because it separates business logic from the UI and makes asynchronous operations easier to manage and test. I implemented dedicated states for loading, success, and failure, while keeping the UI reactive through BlocBuilder. This approach keeps the screen clean, improves maintainability, and provides a clear structure for handling API responses and errors without using setState.