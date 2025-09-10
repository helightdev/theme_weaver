import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:theme_weaver/build_scope.dart';

final descriptorChecker = TypeChecker.typeNamed(
  Descriptor,
  inPackage: "theme_weaver",
);


Future<(String themeName,List<ThemeDescriptorField> fields)> analyzeThemeDescriptor(
  ClassElement2 clazz,
  BuildStep step,
) async {
  final themeName = clazz.displayName.replaceAll("Descriptor", "");
  final themeWeaverLibraryId = AssetId.resolve(
    Uri.parse("package:theme_weaver/build_scope.dart"),
  );
  final themeWeaverLibrary = await step.resolver.libraryFor(
    themeWeaverLibraryId,
  );
  final descriptorInterface =
  themeWeaverLibrary.getClass2("Descriptor") as InterfaceElement2;

  final fields = <ThemeDescriptorField>[];
  for (var field in clazz.fields2) {
    if (descriptorChecker.isExactlyType(field.type)) {
      var typeInstance = field.type.asInstanceOf2(descriptorInterface)!;
      final valueType = typeInstance.typeArguments.first;

      if (valueType is InvalidType) {
        final result = field.session!.getParsedLibraryByElement2(field.library2) as ParsedLibraryResult;
        final declaration = result.getFragmentDeclaration(field.firstFragment)?.node as VariableDeclaration;
        final list = declaration.parent as VariableDeclarationList;
        var typeString = list.type!.toSource().replaceFirst("Descriptor<", "");
        typeString = typeString.substring(0, typeString.length - 1);
        var isNullable = typeString.endsWith("?");
        if (isNullable) {
          typeString = typeString.substring(0, typeString.length - 1);
        }
        fields.add(ThemeDescriptorField(name: field.displayName, typeStr: typeString, isNullable: isNullable));
      } else {
        final isNullable = valueType.nullabilitySuffix != NullabilitySuffix.none;
        fields.add(ThemeDescriptorField(name: field.displayName, typeStr: valueType.nonNullableDisplayString, isNullable: isNullable));
      }
    }
  }

  return (themeName, fields);
}

class ThemeDescriptorField {
  final String name;
  final String typeStr;
  final bool isNullable;

  const ThemeDescriptorField({
    required this.name,
    required this.typeStr,
    required this.isNullable,
  });

  String get nullableTypeStr => isNullable ? "$typeStr?" : typeStr;
}

extension DartTypeExtension on DartType {
  String get nonNullableDisplayString {
    var str = getDisplayString();
    if (str.endsWith("?")) {
      str = str.substring(0, str.length - 1);
    }
    return str;
  }

}
