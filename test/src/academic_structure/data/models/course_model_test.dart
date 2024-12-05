import 'dart:convert';

import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/academic_structure/data/models/course_model.dart';
import 'package:course_rep_management_panel/src/academic_structure/data/models/faculty_model.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tCourseModel = CourseModel.empty();

  group('CourseModel', () {
    test('should be a subclass of [Course] entity', () async {
      expect(tCourseModel, isA<Course>());
    });

    group('fromMap', () {
      test('should return a valid [CourseModel] when the JSON is not null',
          () async {
        final map = jsonDecode(fixture('course.json')) as DataMap;
        map['faculty'] = const FacultyModel.empty();
        final result = CourseModel.fromMap(map);
        expect(result, tCourseModel);
      });
    });

    group('toMap', () {
      test('should return a Dart map containing the proper data', () async {
        final map = jsonDecode(fixture('course.json')) as DataMap;
        final result = tCourseModel.toMap();
        expect(result, map);
      });
    });

    group('copyWith', () {
      test('should return a new [CourseModel] with the same values', () async {
        final result = tCourseModel.copyWith(id: '');
        expect(result.id, equals(''));
      });
    });
  });
}
