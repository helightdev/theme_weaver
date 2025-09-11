// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smoke1/terminal.dart';
import 'package:smoke1/theme.dart';
import 'package:theme_weaver/theme_weaver.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {});

  group("Category Merging", () {
    test("Simple Modifications", () {
      expect(MyCategory().background, MyCategoryDescriptor.background.fallback);
      expect(MyCategory(background: Colors.red).background, Colors.red);
      expect(
        MyCategory(
          background: Colors.red,
        ).merge(MyCategory(background: Colors.green)).background,
        Colors.red,
      );
      expect(
        MyCategory().merge(MyCategory(background: Colors.green)).background,
        Colors.green,
      );
      expect(
        MyCategory.value(
          background: ThemeValue.reset(),
        ).merge(MyCategory(background: Colors.green)).background,
        MyCategoryDescriptor.background.fallback,
      );
    });

    test("Composite Modifications", () {
      final first = CompositeCategory(
        category: MyCategory(background: Colors.red, foreground: Colors.green),
        primary: Colors.blue,
      );
      final last = CompositeCategory(
        category: MyCategory(background: Colors.green),
      ).merge(first);

      expect(first.category.background, Colors.red);
      expect(last.category.background, Colors.green);
      expect(last.category.foreground, Colors.green);
      expect(last.primary, Colors.blue);
    });
  });
}
