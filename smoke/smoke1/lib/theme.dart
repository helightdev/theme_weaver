import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:theme_weaver/theme_weaver.dart';

import 'terminal.dart';

part 'theme.theme.g.dart';
@WeaveToplevelTheme()
class MyThemeDescriptor extends WeavedThemeBase {
  MyThemeDescriptor._();

  static const Descriptor<String> strField = ObjectDescriptor("fallback");
  static const Descriptor<int> intField = NumDescriptor(0);
  static const Descriptor<double?> doubleField = NumDescriptor(0.5);

}

@WaveCategoryTheme()
class CompositeCategoryDescriptor extends WeavedThemeBase {

  static const Descriptor<Color?> primary = ColorDescriptor(null);
  static const Descriptor<MyCategory> category = ThemeCategoryDescriptor(MyCategory.value());
}

