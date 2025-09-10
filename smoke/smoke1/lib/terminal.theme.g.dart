// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terminal.dart';

// **************************************************************************
// CategoryGenerator
// **************************************************************************

class MyCategoryData extends CleaverThemeCategory<MyCategoryData> {
  const MyCategoryData.value({
    ThemeValue<Color?>? foreground,
    ThemeValue<Color?>? background,
    ThemeValue<double>? padding,
  }) : _foreground = foreground ?? const ThemeValue.inherit(),
       _background = background ?? const ThemeValue.inherit(),
       _padding = padding ?? const ThemeValue.inherit();

  factory MyCategoryData({
    Color? foreground,
    Color? background,
    double? padding,
  }) = MyCategoryData._modify;

  factory MyCategoryData._modify({
    Object? foreground = #inherit,
    Object? background = #inherit,
    double? padding,
  }) => MyCategoryData.value(
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
  MyCategoryData lerp(MyCategoryData? b, double t) {
    if (b == null) return this;
    return MyCategoryData.value(
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
  MyCategoryData merge(MyCategoryData? other) {
    if (other == null) return this;
    return MyCategoryData.value(
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
  MyCategoryData copyWith({
    ThemeValue<Color?>? foreground,
    ThemeValue<Color?>? background,
    ThemeValue<double>? padding,
  }) => MyCategoryData.value(
    foreground: foreground ?? this._foreground,
    background: background ?? this._background,
    padding: padding ?? this._padding,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MyCategoryData &&
            runtimeType == other.runtimeType &&
            other._foreground == _foreground &&
            other._background == _background &&
            other._padding == _padding;
  }

  @override
  int get hashCode => Object.hash(_foreground, _background, _padding);
}
