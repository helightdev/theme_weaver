import 'package:theme_weaver/theme_weaver.dart';

part 'terminal.theme.g.dart';

@WeaveCategoryTheme()
class MyCategoryDescriptor extends WeavedThemeBase {

  static const Descriptor<Color?> foreground = ColorDescriptor(null);
  static const Descriptor<Color?> background = ColorDescriptor(null);
  static const Descriptor<double> padding = NumDescriptor(0.0);
}