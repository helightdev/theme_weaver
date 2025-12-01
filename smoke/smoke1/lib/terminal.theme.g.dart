// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terminal.dart';

// **************************************************************************
// CategoryGenerator
// **************************************************************************

class MyCategory extends WeaverThemeCategory<MyCategory> {
  const MyCategory.value({
    ThemeValue<Color?>? foreground,
    ThemeValue<Color?>? background,
    ThemeValue<double>? padding,
  }) : _foreground = foreground ?? const ThemeValue.inherit(),
       _background = background ?? const ThemeValue.inherit(),
       _padding = padding ?? const ThemeValue.inherit();

  factory MyCategory({Color? foreground, Color? background, double? padding}) =
      MyCategory._modify;

  factory MyCategory._modify({
    Object? foreground = #inherit,
    Object? background = #inherit,
    double? padding,
  }) => MyCategory.value(
    foreground: foreground == #inherit
        ? const ThemeValue.inherit()
        : ThemeValue.merge(foreground as Color),
    background: background == #inherit
        ? const ThemeValue.inherit()
        : ThemeValue.merge(background as Color),
    padding: padding == null
        ? const ThemeValue.inherit()
        : ThemeValue.merge(padding),
  );

  final ThemeValue<Color?> _foreground;

  final ThemeValue<Color?> _background;

  final ThemeValue<double> _padding;

  Color? get foreground =>
      _foreground.finalize(MyCategoryDescriptor.foreground);

  Color? get background =>
      _background.finalize(MyCategoryDescriptor.background);

  double get padding => _padding.finalize(MyCategoryDescriptor.padding);

  @override
  MyCategory lerp(MyCategory? b, double t) {
    if (b == null) return this;
    return MyCategory.value(
      foreground: _foreground.lerpValue(
        MyCategoryDescriptor.foreground,
        b._foreground,
        t,
      ),
      background: _background.lerpValue(
        MyCategoryDescriptor.background,
        b._background,
        t,
      ),
      padding: _padding.lerpValue(MyCategoryDescriptor.padding, b._padding, t),
    );
  }

  @override
  MyCategory merge(MyCategory? other) {
    if (other == null) return this;
    return MyCategory.value(
      foreground: _foreground.mergeValue(
        MyCategoryDescriptor.foreground,
        other._foreground,
      ),
      background: _background.mergeValue(
        MyCategoryDescriptor.background,
        other._background,
      ),
      padding: _padding.mergeValue(
        MyCategoryDescriptor.padding,
        other._padding,
      ),
    );
  }

  @override
  MyCategory copyWith({
    ThemeValue<Color?>? foreground,
    ThemeValue<Color?>? background,
    ThemeValue<double>? padding,
  }) => MyCategory.value(
    foreground: foreground ?? this._foreground,
    background: background ?? this._background,
    padding: padding ?? this._padding,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MyCategory &&
            runtimeType == other.runtimeType &&
            other._foreground == _foreground &&
            other._background == _background &&
            other._padding == _padding;
  }

  @override
  int get hashCode => Object.hash(_foreground, _background, _padding);
}
