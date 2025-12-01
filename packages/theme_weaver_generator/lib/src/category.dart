import 'package:analyzer/dart/element/element2.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:source_gen/source_gen.dart' hide LibraryBuilder;
import 'package:theme_weaver/build_scope.dart';
import 'package:theme_weaver_generator/src/shared.dart';

class CategoryGenerator extends GeneratorForAnnotation<WeaveCategoryTheme> {
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
    final (themeName, fields) = await analyzeThemeDescriptor(element, buildStep);
    final descriptorName = element.displayName;
    final camelCaseThemeName = themeName[0].toLowerCase() + themeName.substring(1);
    final fallbackName = "_${camelCaseThemeName}Fallback";

    final emitter = DartEmitter();
    var library = Library((builder) {
      _buildThemeData(builder, themeName, descriptorName, fields);
    });

    return library.accept(emitter).toString();
  }

  void _buildThemeData(
    LibraryBuilder builder,
    String themeName,
    String descriptorName,
    List<ThemeDescriptorField> fields,
  ) {
    builder.body.add(
      Class((clazz) {
        clazz.name = themeName;
        clazz.extend = Reference('WeaverThemeCategory<$themeName>');

        var constructor = ConstructorBuilder()
          ..constant = true
          ..name = "value";

        for (var field in fields) {
          clazz.fields.add(
            Field(
              (builder) => builder
                ..name = '_${field.name}'
                ..type = Reference("ThemeValue<${field.nullableTypeStr}>")
                ..modifier = FieldModifier.final$,
            ),
          );

          constructor.optionalParameters.add(
            Parameter(
              (builder) => builder
                ..name = field.name
                ..named = true
                ..type = Reference("ThemeValue<${field.nullableTypeStr}>?")
                ..required = false,
            ),
          );

          constructor.initializers.add(
            Code('_${field.name} = ${field.name} ?? const ThemeValue.inherit()'),
          );

          clazz.methods.add(
            Method(
              (builder) => builder
                ..name = field.name
                ..type = MethodType.getter
                ..returns = Reference(field.nullableTypeStr)
                ..lambda = true
                ..body = Code('_${field.name}.finalize($descriptorName.${field.name})'),
            ),
          );
        }

        clazz.methods.add(
          Method(
            (builder) => builder
              ..name = 'lerp'
              ..returns = Reference(themeName)
              ..annotations.add(CodeExpression(Code('override')))
              ..requiredParameters.addAll([
                Parameter(
                  (builder) => builder
                    ..name = 'b'
                    ..type = Reference('$themeName?'),
                ),
                Parameter(
                  (builder) => builder
                    ..name = 't'
                    ..type = Reference('double'),
                ),
              ])
              ..body = Code('''
                if (b == null) return this;
                return $themeName.value(
                  ${fields.map((field) => '''
                  ${field.name}: _${field.name}.lerpValue($descriptorName.${field.name}, b._${field.name}, t)''').join(',')}
                );
              '''),
          ),
        );

        clazz.methods.add(
          Method(
            (builder) => builder
              ..name = 'merge'
              ..returns = Reference(themeName)
              ..annotations.add(CodeExpression(Code('override')))
              ..requiredParameters.add(
                Parameter(
                  (builder) => builder
                    ..name = 'other'
                    ..type = Reference('$themeName?'),
                ),
              )
              ..body = Code('''
                if (other == null) return this;
                return $themeName.value(
                  ${fields.map((field) => '''
                  ${field.name}: _${field.name}.mergeValue($descriptorName.${field.name}, other._${field.name})''').join(',')}
                );
              '''),
          ),
        );

        // Copy with
        clazz.methods.add(
          Method(
            (builder) => builder
              ..name = 'copyWith'
              ..returns = Reference(themeName)
              ..annotations.add(CodeExpression(Code('override')))
              ..lambda = true
              ..optionalParameters.addAll(
                fields.map(
                  (field) => Parameter(
                    (builder) => builder
                      ..name = field.name
                      ..named = true
                      ..type = Reference('ThemeValue<${field.nullableTypeStr}>?'),
                  ),
                ),
              )
              ..body = Code('''$themeName.value(
                ${fields.map((field) => '''
                ${field.name}: ${field.name} ?? this._${field.name}''').join(',')}
              )'''),
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
                  other is $themeName &&
                  runtimeType == other.runtimeType &&
                  ${fields.map((field) => 'other._${field.name} == _${field.name}').join(' &&\n')};
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
              ..body = Code(switch (fields.length) {
                0 => '0',
                1 => '_${fields[0].name}.hashCode',
                > 20 => 'Object.hashAll([${fields.map((field) => '_${field.name}').join(", ")}])',
                _ => 'Object.hash(${fields.map((field) => '_${field.name}').join(", ")})',
              }),
          ),
        );

        clazz.constructors.add(constructor.build());

        clazz
          ..constructors.add(
            Constructor(
              (builder) => builder
                ..factory = true
                ..optionalParameters.addAll([
                  for (var field in fields)
                    Parameter(
                      (builder) => builder
                        ..name = field.name
                        ..named = true
                        ..type = Reference('${field.typeStr}?'),
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
                          ..type = Reference('${field.typeStr}?');
                      }
                    }),
                ])
                ..lambda = true
                ..body = Code('''
                  $themeName.value(
                    ${fields.map((field) => '''
                    ${field.name}: ${switch (field.isNullable) {
                  true => '${field.name} == #inherit ? const ThemeValue.inherit() : ThemeValue.merge(${field.name} as ${field.typeStr})',
                  false => '${field.name} == null ? const ThemeValue.inherit() : ThemeValue.merge(${field.name})',
                }}''').join(',')},
                  )'''),
            ),
          );
      }),
    );
  }
}
