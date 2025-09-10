import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lyell/lyell.dart';

import 'build_scope.dart';

export 'build_scope.dart';
export 'package:flutter/widgets.dart';

class ObjectDescriptor<T> extends Descriptor<T> {
  @override
  final T fallback;

  const ObjectDescriptor(this.fallback);

  @override
  T lerp(T a, T b, double t) => t < 0.5 ? a : b;

  @override
  T merge(T override, T base) => override;
}

class NumDescriptor<T extends num?> extends Descriptor<T> {
  @override
  final T fallback;

  const NumDescriptor(this.fallback);

  static final _nullableInt = TypeToken<int>().typeArgument;

  @override
  T lerp(num? a, num? b, double t) {
    var lerped = lerpDouble(a, b, t);
    final T? current;
    if (T == int || T == _nullableInt) {
      current = lerped?.round() as T?;
    } else {
      current = lerped as T?;
    }
    if (current is T) return current;
    return fallback;
  }

  @override
  T merge(T override, T base) => override ?? base;
}

class ColorDescriptor<T extends Color?> extends Descriptor<T> {
  @override
  final T fallback;

  const ColorDescriptor(this.fallback);

  @override
  T lerp(Color? a, Color? b, double t) {
    var lerped = Color.lerp(a, b, t);
    if (lerped is T) return lerped;
    return fallback;
  }

  @override
  T merge(T override, T base) => override;
}

class TextStyleDescriptor<T extends TextStyle?> extends Descriptor<T> {
  @override
  final T fallback;

  const TextStyleDescriptor(this.fallback);

  @override
  T lerp(TextStyle? a, TextStyle? b, double t) {
    var lerped = TextStyle.lerp(a, b, t);
    if (lerped is T) return lerped;
    return fallback;
  }

  @override
  T merge(T override, T base) => override ?? base;
}

class EdgeInsetsDescriptor<T extends EdgeInsets?> extends Descriptor<T> {
  @override
  final T fallback;

  const EdgeInsetsDescriptor(this.fallback);

  @override
  T lerp(EdgeInsets? a, EdgeInsets? b, double t) {
    var lerped = EdgeInsets.lerp(a, b, t);
    if (lerped is T) return lerped;
    return fallback;
  }

  @override
  T merge(T override, T base) => override ?? base;
}

class BorderRadiusDescriptor<T extends BorderRadius?> extends Descriptor<T> {
  @override
  final T fallback;

  const BorderRadiusDescriptor(this.fallback);

  @override
  T lerp(BorderRadius? a, BorderRadius? b, double t) {
    var lerped = BorderRadius.lerp(a, b, t);
    if (lerped is T) return lerped;
    return fallback;
  }

  @override
  T merge(T override, T base) => override ?? base;
}

class BorderDescriptor<T extends BoxBorder?> extends Descriptor<T> {
  @override
  final T fallback;

  const BorderDescriptor(this.fallback);

  @override
  T lerp(BoxBorder? a, BoxBorder? b, double t) {
    var lerped = BoxBorder.lerp(a, b, t);
    if (lerped is T) return lerped;
    return fallback;
  }

  @override
  T merge(T override, T base) => override ?? base;
}

class SizeDescriptor<T extends Size?> extends Descriptor<T> {
  @override
  final T fallback;

  const SizeDescriptor(this.fallback);

  @override
  T lerp(Size? a, Size? b, double t) {
    var lerped = Size.lerp(a, b, t);
    if (lerped is T) return lerped;
    return fallback;
  }

  @override
  T merge(T override, T base) => override ?? base;
}

class OffsetDescriptor<T extends Offset?> extends Descriptor<T> {
  @override
  final T fallback;

  const OffsetDescriptor(this.fallback);

  @override
  T lerp(Offset? a, Offset? b, double t) {
    var lerped = Offset.lerp(a, b, t);
    if (lerped is T) return lerped;
    return fallback;
  }

  @override
  T merge(T override, T base) => override ?? base;
}

class RectDescriptor<T extends Rect?> extends Descriptor<T> {
  @override
  final T fallback;

  const RectDescriptor(this.fallback);

  @override
  T lerp(Rect? a, Rect? b, double t) {
    var lerped = Rect.lerp(a, b, t);
    if (lerped is T) return lerped;
    return fallback;
  }

  @override
  T merge(T override, T base) => override ?? base;
}

class BoxConstraintsDescriptor<T extends BoxConstraints?> extends Descriptor<T> {
  @override
  final T fallback;

  const BoxConstraintsDescriptor(this.fallback);

  @override
  T lerp(BoxConstraints? a, BoxConstraints? b, double t) {
    var lerped = BoxConstraints.lerp(a, b, t);
    if (lerped is T) return lerped;
    return fallback;
  }

  @override
  T merge(T override, T base) => override ?? base;
}

class AlignmentDescriptor<T extends Alignment?> extends Descriptor<T> {
  @override
  final T fallback;

  const AlignmentDescriptor(this.fallback);

  @override
  T lerp(Alignment? a, Alignment? b, double t) {
    var lerped = Alignment.lerp(a, b, t);
    if (lerped is T) return lerped;
    return fallback;
  }

  @override
  T merge(T override, T base) => override ?? base;
}

class ThemeCategoryDescriptor<T extends CleaverThemeCategory<T>> extends Descriptor<T> {
  @override
  final T fallback;

  const ThemeCategoryDescriptor(this.fallback);

  @override
  T lerp(CleaverThemeCategory? a, CleaverThemeCategory? b, double t) {
    var lerped = a?.lerp(b, t) ?? b;
    if (lerped is T) return lerped;
    return fallback;
  }

  @override
  T merge(T override, T base) => override.merge(base);
}

mixin MaterialInteropMixin<TData> on WeavedThemeBase {
  ThemeData toMaterial(TData data);

  TData fromMaterial(ThemeData theme);
}

enum ThemeValueMode { set, merge, reset, inherit }

class ThemeValue<T> {
  final T? value;
  final ThemeValueMode mode;

  const ThemeValue(this.value) : mode = ThemeValueMode.set;

  const ThemeValue.set(this.value) : mode = ThemeValueMode.set;

  const ThemeValue.merge(this.value) : mode = ThemeValueMode.merge;

  const ThemeValue.reset() : value = null, mode = ThemeValueMode.reset;

  const ThemeValue.inherit() : value = null, mode = ThemeValueMode.inherit;

  T merge(Descriptor<T> descriptor, T base) {
    return switch (mode) {
      ThemeValueMode.set => value as T,
      ThemeValueMode.merge => descriptor.merge(value as T, base),
      ThemeValueMode.reset => descriptor.fallback,
      ThemeValueMode.inherit => base,
    };
  }

  ThemeValue<T> mergeValue(Descriptor<T> descriptor, ThemeValue<T> base) {
    return switch (mode) {
      ThemeValueMode.set => this,
      ThemeValueMode.merge => ThemeValue.set(descriptor.merge(value as T, base.finalize(descriptor))),
      ThemeValueMode.reset => ThemeValue.set(descriptor.fallback),
      ThemeValueMode.inherit => base,
    };
  }

  ThemeValue<T> lerpValue(Descriptor<T> descriptor, ThemeValue<T> b, double t) {
    return ThemeValue.set(
      descriptor.lerp(
        finalize(descriptor),
        b.finalize(descriptor),
        t,
      ),
    );
  }

  T finalize(Descriptor<T> descriptor) {
    return switch (mode) {
      ThemeValueMode.set => value as T,
      ThemeValueMode.merge => descriptor.merge(value as T, descriptor.fallback),
      ThemeValueMode.reset => descriptor.fallback,
      ThemeValueMode.inherit => descriptor.fallback,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeValue &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          mode == other.mode;

  @override
  int get hashCode => Object.hash(value, mode);
}

abstract class CleaverThemeCategory<TSelf extends CleaverThemeCategory<TSelf>> extends ThemeExtension<TSelf> {

  const CleaverThemeCategory();

  TSelf merge(TSelf? other);

}