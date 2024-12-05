import 'dart:convert';

import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/course_representative/data/models/course_representative_model.dart';
import 'package:course_rep_management_panel/src/course_representative/domain/entities/course_representative.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tCourseRepresentativeModel = CourseRepresentativeModel.empty();

  group('CourseRepresentativeModel', () {
    test('should be a subclass of [CourseRepresentative] entity', () async {
      expect(tCourseRepresentativeModel, isA<CourseRepresentative>());
    });

    group('fromMap', () {
      test(
          'should return a valid [CourseRepresentativeModel] when the JSON '
          'is not null', () async {
        final map =
            jsonDecode(fixture('course_representative.json')) as DataMap;
        final result = CourseRepresentativeModel.fromMap(map);
        expect(result, tCourseRepresentativeModel);
      });
    });

    group('toMap', () {
      test('should return a Dart map containing the proper data', () async {
        final map =
            jsonDecode(fixture('course_representative.json')) as DataMap;
        final result = tCourseRepresentativeModel.toMap();
        expect(result, map);
      });
    });

    group('copyWith', () {
      test(
          'should return a new [CourseRepresentativeModel] with the '
          'same values', () async {
        final result = tCourseRepresentativeModel.copyWith(id: '');
        expect(result.id, equals(''));
      });
    });
  });
}
