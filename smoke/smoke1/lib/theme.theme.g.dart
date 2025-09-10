// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme.dart';

// **************************************************************************
// ToplevelGenerator
// **************************************************************************

final _myThemeFallback = MyThemeData(
  strField: MyThemeDescriptor.strField.fallback,
  intField: MyThemeDescriptor.intField.fallback,
  doubleField: MyThemeDescriptor.doubleField.fallback,
);

class MyThemeData {
  const MyThemeData({
    required this.strField,
    required this.intField,
    this.doubleField,
  });

  final String strField;

  final int intField;

  final double? doubleField;

  MyThemeData$Copy get copy => MyThemeData$CopyImpl(this);

  static MyThemeData lerp(MyThemeData a, MyThemeData b, double t) {
    return MyThemeData(
      strField: MyThemeDescriptor.strField.lerp(a.strField, b.strField, t),
      intField: MyThemeDescriptor.intField.lerp(a.intField, b.intField, t),
      doubleField: MyThemeDescriptor.doubleField.lerp(
        a.doubleField,
        b.doubleField,
        t,
      ),
    );
  }

  MyThemeData merge(MyThemeData? other) {
    if (other == null) return this;
    return MyThemeData(
      strField: MyThemeDescriptor.strField.merge(other.strField, strField),
      intField: MyThemeDescriptor.intField.merge(other.intField, intField),
      doubleField: MyThemeDescriptor.doubleField.merge(
        other.doubleField,
        doubleField,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MyThemeData &&
            runtimeType == other.runtimeType &&
            other.strField == strField &&
            other.intField == intField &&
            other.doubleField == doubleField;
  }

  @override
  int get hashCode => Object.hash(strField, intField, doubleField);
}

abstract class MyThemeData$Copy {
  MyThemeData call({String? strField, int? intField, double? doubleField});
}

class MyThemeData$CopyImpl implements MyThemeData$Copy {
  const MyThemeData$CopyImpl(this._base);

  final MyThemeData _base;

  @override
  MyThemeData call({
    String? strField,
    int? intField,
    Object? doubleField = #inherit,
  }) => MyThemeData(
    strField: strField ?? _base.strField,
    intField: intField ?? _base.intField,
    doubleField: doubleField == #inherit
        ? _base.doubleField
        : doubleField as double,
  );
}

class _InheritedMyTheme extends InheritedWidget {
  const _InheritedMyTheme({
    super.key,
    required super.child,
    required this.data,
  });

  final MyThemeData? data;

  @override
  bool updateShouldNotify(_InheritedMyTheme oldWidget) =>
      data != oldWidget.data;
}

class MyTheme extends StatelessWidget {
  const MyTheme({
    super.key,
    required this.child,
    this.data,
    this.strField = const ThemeValue.inherit(),
    this.intField = const ThemeValue.inherit(),
    this.doubleField = const ThemeValue.inherit(),
  });

  factory MyTheme.modify({
    Key? key,
    required Widget child,
    String? strField,
    int? intField,
    double? doubleField,
  }) = MyTheme._modify;

  factory MyTheme._modify({
    Key? key,
    required Widget child,
    String? strField,
    int? intField,
    Object? doubleField = #inherit,
  }) => MyTheme(
    key: key,
    strField: strField == null
        ? const ThemeValue.inherit()
        : ThemeValue.merge(strField),
    intField: intField == null
        ? const ThemeValue.inherit()
        : ThemeValue.merge(intField),
    doubleField: doubleField == #inherit
        ? const ThemeValue.inherit()
        : ThemeValue.merge(doubleField as double),
    child: child,
  );

  final MyThemeData? data;

  final Widget child;

  final ThemeValue<String> strField;

  final ThemeValue<int> intField;

  final ThemeValue<double?> doubleField;

  MyThemeData apply(MyThemeData base) => MyThemeData(
    strField: strField.merge(MyThemeDescriptor.strField, base.strField),
    intField: intField.merge(MyThemeDescriptor.intField, base.intField),
    doubleField: doubleField.merge(
      MyThemeDescriptor.doubleField,
      base.doubleField,
    ),
  );

  static MyThemeData of(BuildContext context) {
    final widget = context
        .dependOnInheritedWidgetOfExactType<_InheritedMyTheme>();
    return widget?.data ?? _myThemeFallback;
  }

  @override
  Widget build(BuildContext context) {
    if (data != null) return _InheritedMyTheme(data: data, child: child);
    final previous = context
        .dependOnInheritedWidgetOfExactType<_InheritedMyTheme>();
    final current = apply(previous?.data ?? _myThemeFallback);
    return _InheritedMyTheme(data: current, child: child);
  }
}

// **************************************************************************
// CategoryGenerator
// **************************************************************************

class CompositeCategoryData
    extends CleaverThemeCategory<CompositeCategoryData> {
  const CompositeCategoryData.value({
    ThemeValue<Color?>? primary,
    ThemeValue<MyCategoryData>? category,
  }) : _primary = primary ?? const ThemeValue.inherit(),
       _category = category ?? const ThemeValue.inherit();

  factory CompositeCategoryData({Color? primary, MyCategoryData? category}) =
      CompositeCategoryData._modify;

  factory CompositeCategoryData._modify({
    Object? primary = #inherit,
    MyCategoryData? category,
  }) => CompositeCategoryData.value(
    primary: primary == #inherit
        ? const ThemeValue.inherit()
        : ThemeValue.merge(primary as Color),
    category: category == null
        ? const ThemeValue.inherit()
        : ThemeValue.merge(category),
  );

  final ThemeValue<Color?> _primary;

  final ThemeValue<MyCategoryData> _category;

  Color? get primary => _primary.finalize(CompositeCategoryDescriptor.primary);

  MyCategoryData get category =>
      _category.finalize(CompositeCategoryDescriptor.category);

  @override
  CompositeCategoryData lerp(CompositeCategoryData? b, double t) {
    if (b == null) return this;
    return CompositeCategoryData.value(
      primary: _primary.lerpValue(
        CompositeCategoryDescriptor.primary,
        b._primary,
        t,
      ),
      category: _category.lerpValue(
        CompositeCategoryDescriptor.category,
        b._category,
        t,
      ),
    );
  }

  @override
  CompositeCategoryData merge(CompositeCategoryData? other) {
    if (other == null) return this;
    return CompositeCategoryData.value(
      primary: _primary.mergeValue(
        CompositeCategoryDescriptor.primary,
        other._primary,
      ),
      category: _category.mergeValue(
        CompositeCategoryDescriptor.category,
        other._category,
      ),
    );
  }

  @override
  CompositeCategoryData copyWith({
    ThemeValue<Color?>? primary,
    ThemeValue<MyCategoryData>? category,
  }) => CompositeCategoryData.value(
    primary: primary ?? this._primary,
    category: category ?? this._category,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CompositeCategoryData &&
            runtimeType == other.runtimeType &&
            other._primary == _primary &&
            other._category == _category;
  }

  @override
  int get hashCode => Object.hash(_primary, _category);
}
