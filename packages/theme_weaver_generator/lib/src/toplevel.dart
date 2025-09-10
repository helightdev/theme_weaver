import 'package:analyzer/dart/element/element2.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:source_gen/source_gen.dart' hide LibraryBuilder;
import 'package:theme_weaver/build_scope.dart';
import 'package:theme_weaver_generator/src/shared.dart';

class ToplevelGenerator extends GeneratorForAnnotation<WeaveToplevelTheme> {
  @override
  Future<String> generateForAnnotatedElement(
    Element2 element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! ClassElement2) {
      throw InvalidGenerationSourceError(
        'Generator cannot target `${element.displayName}`. '
        'Annotation can only be applied to classes.',
        element: element,
      );
    }
    final (themeName, fields) = await analyzeThemeDescriptor(
      element,
      buildStep,
    );
    final descriptorName = element.displayName;
    final camelCaseThemeName =
        themeName[0].toLowerCase() + themeName.substring(1);
    final fallbackName = "_${camelCaseThemeName}Fallback";

    final emitter = DartEmitter();
    var library = Library((builder) {
      builder.body.add(
        Code(
          "final $fallbackName = ${themeName}Data(${fields.map((field) => "${field.name} : $descriptorName.${field.name}.fallback").join(", ")});",
        ),
      );

      _buildThemeData(builder, themeName, descriptorName, fields);
      _buildCopyInterface(builder, themeName, fields);
      _buildCopyImpl(builder, themeName, fields);
      _buildInheritedWidget(builder, themeName);
      _buildThemeWidget(builder, themeName, descriptorName, fallbackName, fields);
    });

    return library.accept(emitter).toString();
  }

  void _buildThemeWidget(
    LibraryBuilder builder,
    String themeName,
    String descriptorName,
    String fallbackName,
    List<ThemeDescriptorField> fields,
  ) {
    builder.body.add(
      Class((builder) {
        builder
          ..name = themeName
          ..extend = Reference('StatelessWidget')
          ..constructors.add(
            Constructor(
              (constructor) => constructor
                ..constant = true
                ..optionalParameters.add(
                  Parameter(
                    (builder) => builder
                      ..name = 'key'
                      ..toSuper = true
                      ..named = true,
                  ),
                )
                ..optionalParameters.add(
                  Parameter(
                    (builder) => builder
                      ..name = 'child'
                      ..named = true
                      ..required = true
                      ..toThis = true,
                  ),
                )
                ..optionalParameters.add(
                  Parameter(
                    (builder) => builder
                      ..name = 'data'
                      ..named = true
                      ..toThis = true,
                  ),
                )
                ..optionalParameters.addAll([
                  for (var field in fields)
                    Parameter(
                      (builder) => builder
                        ..name = field.name
                        ..named = true
                        ..toThis = true
                        ..defaultTo = Code('const ThemeValue.inherit()'),
                    ),
                ]),
            ),
          )
          ..constructors.add(
            Constructor(
              (builder) => builder
                ..name = "modify"
                ..factory = true
                ..optionalParameters.addAll([
                  Parameter(
                    (builder) => builder
                      ..name = 'key'
                      ..type = Reference('Key?')
                      ..named = true,
                  ),
                  Parameter(
                    (builder) => builder
                      ..name = 'child'
                      ..type = Reference('Widget')
                      ..named = true
                      ..required = true,
                  ),

                  for (var field in fields)
                    Parameter(
                      (builder) => builder
                        ..name = field.name
                        ..named = true
                        ..type = Reference(
                          '${field.typeStr}?',
                        ),
                    ),
                ])
                ..redirect = Reference('$themeName._modify'),
            ),
          )
          ..constructors.add(
            Constructor(
              (builder) => builder
                ..name = "_modify"
                ..factory = true
                ..optionalParameters.addAll([
                  Parameter(
                    (builder) => builder
                      ..name = 'key'
                      ..type = Reference('Key?')
                      ..named = true,
                  ),
                  Parameter(
                    (builder) => builder
                      ..name = 'child'
                      ..type = Reference('Widget')
                      ..named = true
                      ..required = true,
                  ),

                  for (var field in fields)
                    Parameter((builder) {
                      if (field.isNullable) {
                        builder
                          ..name = field.name
                          ..named = true
                          ..type = Reference("Object?")
                          ..defaultTo = Code('#inherit');
                      } else {
                        builder
                          ..name = field.name
                          ..named = true
                          ..type = Reference(
                            '${field.typeStr}?',
                          );
                      }
                    }),
                ])
                ..lambda = true
                ..body = Code('''
                  $themeName(
                    key: key,
                    ${fields.map((field) => '''
                    ${field.name}: ${switch (field.isNullable) {
                  true => '${field.name} == #inherit ? const ThemeValue.inherit() : ThemeValue.merge(${field.name} as ${field.typeStr})',
                  false => '${field.name} == null ? const ThemeValue.inherit() : ThemeValue.merge(${field.name})',
                }}''').join(',')},
                    child: child,
                  )'''),
            ),
          )
          ..methods.add(
            Method(
              (builder) => builder
                ..name = 'apply'
                ..returns = Reference('${themeName}Data')
                ..requiredParameters.add(
                  Parameter(
                    (builder) => builder
                      ..name = 'base'
                      ..type = Reference('${themeName}Data'),
                  ),
                )
                ..lambda = true
                ..body = Code('''
                  ${themeName}Data(
                    ${fields.map((field) => '''
                    ${field.name}: ${field.name}.merge($descriptorName.${field.name}, base.${field.name})''').join(',')}
                  )
                  '''),
            ),
          )
          ..methods.add(
            Method(
              (builder) => builder
                ..name = "of"
                ..static = true
                ..returns = Reference('${themeName}Data')
                ..requiredParameters.add(
                  Parameter(
                    (builder) => builder
                      ..name = 'context'
                      ..type = Reference('BuildContext'),
                  ),
                )
                ..body = Code('''
                  final widget = context.dependOnInheritedWidgetOfExactType<_Inherited$themeName>();
                  return widget?.data ?? $fallbackName;
              '''),
            ),
          )
          ..methods.add(
            Method(
              (builder) => builder
                ..name = 'build'
                ..annotations.add(CodeExpression(Code('override')))
                ..returns = Reference('Widget')
                ..requiredParameters.add(
                  Parameter(
                    (builder) => builder
                      ..name = 'context'
                      ..type = Reference('BuildContext'),
                  ),
                )
                ..body = Code('''
                if (data != null) return _Inherited$themeName(
                  data: data,
                  child: child,
                );
                final previous = context.dependOnInheritedWidgetOfExactType<_Inherited$themeName>();
                final current = apply(previous?.data ?? $fallbackName);
                return _Inherited$themeName(
                  data: current,
                  child: child,
                );
              '''),
            ),
          );

        builder.fields.add(
          Field(
            (builder) => builder
              ..name = 'data'
              ..type = Reference('${themeName}Data?')
              ..modifier = FieldModifier.final$,
          ),
        );
        builder.fields.add(
          Field(
            (builder) => builder
              ..name = 'child'
              ..type = Reference('Widget')
              ..modifier = FieldModifier.final$,
          ),
        );

        for (var field in fields) {
          builder.fields.add(
            Field(
              (builder) => builder
                ..name = field.name
                ..type = Reference(
                  "ThemeValue<${field.nullableTypeStr}>",
                )
                ..modifier = FieldModifier.final$,
            ),
          );
        }
      }),
    );
  }

  void _buildInheritedWidget(LibraryBuilder builder, String themeName) {
    builder.body.add(
      Class((builder) {
        builder
          ..name = "_Inherited$themeName"
          ..extend = Reference('InheritedWidget')
          ..constructors.add(
            Constructor(
              (constructor) => constructor
                ..constant = true
                ..optionalParameters.add(
                  Parameter(
                    (builder) => builder
                      ..name = 'key'
                      ..toSuper = true
                      ..named = true,
                  ),
                )
                ..optionalParameters.add(
                  Parameter(
                    (builder) => builder
                      ..name = 'child'
                      ..named = true
                      ..required = true
                      ..toSuper = true,
                  ),
                )
                ..optionalParameters.add(
                  Parameter(
                    (builder) => builder
                      ..name = 'data'
                      ..named = true
                      ..toThis = true
                      ..required = true,
                  ),
                ),
            ),
          )
          ..methods.add(
            Method(
              (builder) => builder
                ..name = 'updateShouldNotify'
                ..annotations.add(CodeExpression(Code('override')))
                ..returns = Reference('bool')
                ..lambda = true
                ..body = Code('''
                  data != oldWidget.data
                  ''')
                ..requiredParameters.add(
                  Parameter(
                    (builder) => builder
                      ..name = 'oldWidget'
                      ..type = Reference("_Inherited$themeName"),
                  ),
                ),
            ),
          );

        builder.fields.add(
          Field(
            (builder) => builder
              ..name = 'data'
              ..type = Reference('${themeName}Data?')
              ..modifier = FieldModifier.final$,
          ),
        );
      }),
    );
  }

  void _buildCopyImpl(
    LibraryBuilder builder,
    String themeName,
    List<ThemeDescriptorField> fields,
  ) {
    builder.body.add(
      Class((clazz) {
        clazz.name = "${themeName}Data\$CopyImpl";
        clazz.implements.add(Reference('${themeName}Data\$Copy'));

        clazz.fields.add(
          Field(
            (builder) => builder
              ..name = '_base'
              ..type = Reference('${themeName}Data')
              ..modifier = FieldModifier.final$,
          ),
        );

        clazz.constructors.add(
          Constructor(
            (builder) => builder
              ..constant = true
              ..requiredParameters.add(
                Parameter(
                  (builder) => builder
                    ..name = '_base'
                    ..toThis = true,
                ),
              ),
          ),
        );

        clazz.methods.add(
          Method(
            (builder) => builder
              ..name = 'call'
              ..returns = Reference('${themeName}Data')
              ..annotations.add(CodeExpression(Code('override')))
              ..optionalParameters.addAll(
                fields.map(
                  (field) => Parameter((builder) {
                    if (field.isNullable) {
                      builder
                        ..name = field.name
                        ..named = true
                        ..type = Reference('Object?')
                        ..defaultTo = Code('#inherit');
                    } else {
                      builder
                        ..name = field.name
                        ..named = true
                        ..type = Reference(
                          '${field.typeStr}?',
                        );
                    }
                  }),
                ),
              )
              ..lambda = true
              ..body = Code('''
                ${themeName}Data(${fields.map((field) {
                if (field.isNullable) {
                  return "${field.name}: ${field.name} == #inherit ? _base.${field.name} : ${field.name} as ${field.typeStr}";
                } else {
                  return "${field.name}: ${field.name} ?? _base.${field.name}";
                }
              }).join(",")})'''),
          ),
        );
      }),
    );
  }

  void _buildCopyInterface(
    LibraryBuilder builder,
    String themeName,
    List<ThemeDescriptorField> fields,
  ) {
    builder.body.add(
      Class((clazz) {
        clazz.name = "${themeName}Data\$Copy";
        clazz.abstract = true;
        clazz.methods.add(
          Method(
            (builder) => builder
              ..name = 'call'
              ..returns = Reference('${themeName}Data')
              ..optionalParameters.addAll(
                fields.map(
                  (field) => Parameter(
                    (builder) => builder
                      ..name = field.name
                      ..named = true
                      ..type = Reference(
                        '${field.typeStr}?',
                      ),
                  ),
                ),
              ),
          ),
        );
      }),
    );
  }

  void _buildThemeData(
    LibraryBuilder builder,
    String themeName,
    String descriptorName,
    List<ThemeDescriptorField> fields,
  ) {
    builder.body.add(
      Class((clazz) {
        clazz.name = "${themeName}Data";

        var constructor = ConstructorBuilder()..constant = true;

        for (var field in fields) {
          clazz.fields.add(
            Field(
              (builder) => builder
                ..name = field.name
                ..type = Reference(field.nullableTypeStr)
                ..modifier = FieldModifier.final$,
            ),
          );

          constructor.optionalParameters.add(
            Parameter(
              (builder) => builder
                ..name = field.name
                ..named = true
                ..toThis = true
                ..required = !field.isNullable,
            ),
          );
        }

        clazz.methods.add(
          Method(
            (builder) => builder
              ..type = MethodType.getter
              ..name = 'copy'
              ..returns = Reference('${themeName}Data\$Copy')
              ..lambda = true
              ..body = Code('${themeName}Data\$CopyImpl(this)'),
          ),
        );

        clazz.methods.add(
          Method(
            (builder) => builder
              ..name = 'lerp'
              ..static = true
              ..returns = Reference('${themeName}Data')
              ..requiredParameters.addAll([
                Parameter(
                  (builder) => builder
                    ..name = 'a'
                    ..type = Reference('${themeName}Data'),
                ),
                Parameter(
                  (builder) => builder
                    ..name = 'b'
                    ..type = Reference('${themeName}Data'),
                ),
                Parameter(
                  (builder) => builder
                    ..name = 't'
                    ..type = Reference('double'),
                ),
              ])
              ..body = Code('''
                return ${themeName}Data(
                  ${fields.map((field) => '''
                  ${field.name}: $descriptorName.${field.name}.lerp(a.${field.name}, b.${field.name}, t)''').join(',')}
                );
              '''),
          ),
        );

        clazz.methods.add(
          Method(
            (builder) => builder
              ..name = 'merge'
              ..returns = Reference('${themeName}Data')
              ..requiredParameters.add(
                Parameter(
                  (builder) => builder
                    ..name = 'other'
                    ..type = Reference('${themeName}Data?'),
                ),
              )
              ..body = Code('''
                if (other == null) return this;
                return ${themeName}Data(
                  ${fields.map((field) => '''
                  ${field.name}: $descriptorName.${field.name}.merge(other.${field.name}, ${field.name})''').join(',')}
                );
              '''),
          ),
        );

        // Equals and hashCode
        clazz.methods.add(
          Method(
            (builder) => builder
              ..name = 'operator =='
              ..returns = Reference('bool')
              ..annotations.add(CodeExpression(Code('override')))
              ..requiredParameters.add(
                Parameter(
                  (builder) => builder
                    ..name = 'other'
                    ..type = Reference('Object'),
                ),
              )
              ..body = Code('''
                return identical(this, other) ||
                  other is ${themeName}Data &&
                  runtimeType == other.runtimeType &&
                  ${fields.map((field) => 'other.${field.name} == ${field.name}').join(' &&\n')};
                '''),
          ),
        );

        clazz.methods.add(
          Method(
            (builder) => builder
              ..annotations.add(CodeExpression(Code('override')))
              ..name = 'hashCode'
              ..type = MethodType.getter
              ..returns = Reference('int')
              ..lambda = true
              ..body = Code(
                'Object.hash(${fields.map((field) => field.name).join(", ")})',
              ),
          ),
        );

        clazz.constructors.add(constructor.build());
      }),
    );
  }
}
