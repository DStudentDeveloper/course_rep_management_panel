import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/level.dart';
import 'package:course_rep_management_panel/src/course_representative/domain/entities/course_representative.dart';
import 'package:course_rep_management_panel/src/course_representative/domain/usecases/get_course_representatives.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'course_representative_repo.mock.dart';

void main() {
  late MockCourseRepresentativeRepo repo;
  late GetCourseRepresentatives usecase;

  const tFaculty = Faculty.empty();

  const tCourse = Course.empty();

  const tLevel = Level.empty();

  const tResult = [CourseRepresentative.empty()];

  setUp(() {
    repo = MockCourseRepresentativeRepo();
    usecase = GetCourseRepresentatives(repo);
    registerFallbackValue(tFaculty);
    registerFallbackValue(tCourse);
    registerFallbackValue(tLevel);
  });

  test(
    'should return [List<CourseRepresentative>] from the repo',
    () async {
      when(
        () => repo.getCourseRepresentatives(
          faculty: any(named: 'faculty'),
          course: any(named: 'course'),
          level: any(named: 'level'),
        ),
      ).thenAnswer(
        (_) async => const Right(tResult),
      );

      final result = await usecase(
        const GetCourseRepresentativesParams(
          faculty: tFaculty,
          course: tCourse,
          level: tLevel,
        ),
      );
      expect(
        result,
        equals(const Right<dynamic, List<CourseRepresentative>>(tResult)),
      );
      verify(
        () => repo.getCourseRepresentatives(
          faculty: any(named: 'faculty'),
          course: any(named: 'course'),
          level: any(named: 'level'),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
