import 'package:lyell/lyell.dart';

class WeaveToplevelTheme {
  const WeaveToplevelTheme();
}

class WeaveCategoryTheme {
  const WeaveCategoryTheme();
}

abstract class WeavedThemeBase {
  const WeavedThemeBase();
}

abstract class Descriptor<T> with TypeCaptureMixin<T> {
  const Descriptor();

  T get fallback;

  T lerp(T a, T b, double t);

  T merge(T override, T base);
}