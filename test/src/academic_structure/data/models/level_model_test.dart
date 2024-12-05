import 'dart:convert';

import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/academic_structure/data/models/course_model.dart';
import 'package:course_rep_management_panel/src/academic_structure/data/models/level_model.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/level.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tLevelModel = LevelModel.empty();

  group('LevelModel', () {
    test('should be a subclass of [Level] entity', () async {
      expect(tLevelModel, isA<Level>());
    });

    group('fromMap', () {
      test('should return a valid [LevelModel] when the JSON is not null',
          () async {
        final map = jsonDecode(fixture('level.json')) as DataMap;
        map['course'] = const CourseModel.empty();
        final result = LevelModel.fromMap(map);
        expect(result, tLevelModel);
      });
    });

    group('toMap', () {
      test('should return a Dart map containing the proper data', () async {
        final map = jsonDecode(fixture('level.json')) as DataMap;
        final result = tLevelModel.toMap();
        expect(result, map);
      });
    });

    group('copyWith', () {
      test('should return a new [LevelModel] with the same values', () async {
        final result = tLevelModel.copyWith(id: '');
        expect(result.id, equals(''));
      });
    });
  });
}
