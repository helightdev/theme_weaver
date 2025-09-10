library;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:theme_weaver_generator/src/category.dart';

import 'builders.dart';

export 'src/toplevel.dart';

Builder themeWeaverBuilder(BuilderOptions options) => PartBuilder([ToplevelGenerator(), CategoryGenerator()], '.theme.g.dart');
