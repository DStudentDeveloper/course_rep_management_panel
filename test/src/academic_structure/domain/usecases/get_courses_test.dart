import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/usecases/get_courses.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../academic_structure/domain/usecases/academic_structure_repo.mock.dart';

void main() {
  late MockAcademicStructureRepo repo;
  late GetCourses usecase;

  const tFaculty = Faculty.empty();
  const tResult = <Course>[Course.empty()];

  setUp(() {
    repo = MockAcademicStructureRepo();
    usecase = GetCourses(repo);
    registerFallbackValue(tFaculty);
  });

  test(
    'should return [List<Course>] from the repo',
    () async {
      when(
        () => repo.getCourses(
          any(),
        ),
      ).thenAnswer(
        (_) async => const Right(tResult),
      );

      final result = await usecase(tFaculty);
      expect(result, equals(const Right<dynamic, List<Course>>(tResult)));
      verify(
        () => repo.getCourses(
          any(),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
