import 'dart:convert';

import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/academic_structure/data/models/faculty_model.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tFacultyModel = FacultyModel.empty();

  group('FacultyModel', () {
    test('should be a subclass of [Faculty] entity', () async {
      expect(tFacultyModel, isA<Faculty>());
    });

    group('fromMap', () {
      test('should return a valid [FacultyModel] when the JSON is not null',
          () async {
        final map = jsonDecode(fixture('faculty.json')) as DataMap;
        final result = FacultyModel.fromMap(map);
        expect(result, tFacultyModel);
      });
    });
    group('toMap', () {
      test('should return a Dart map containing the proper data', () async {
        final map = jsonDecode(fixture('faculty.json')) as DataMap;
        final result = tFacultyModel.toMap();
        expect(result, map);
      });
    });

    group('copyWith', () {
      test('should return a new [FacultyModel] with the same values', () async {
        final result = tFacultyModel.copyWith(id: '');
        expect(result.id, equals(''));
      });
    });
  });
}
