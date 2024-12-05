import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/usecases/add_course.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'academic_structure_repo.mock.dart';

void main() {
  late MockAcademicStructureRepo repo;
  late AddCourse usecase;

  const tFacultyId = 'Test String';

  const tCourse = Course.empty();

  setUp(() {
    repo = MockAcademicStructureRepo();
    usecase = AddCourse(repo);
    registerFallbackValue(tFacultyId);
    registerFallbackValue(tCourse);
  });

  test(
    'should call the [AcademicStructureRepo.addCourse]',
    () async {
      when(
        () => repo.addCourse(
          facultyId: any(named: 'facultyId'),
          course: any(named: 'course'),
        ),
      ).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await usecase(
        const AddCourseParams(
          facultyId: tFacultyId,
          course: tCourse,
        ),
      );
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => repo.addCourse(
          facultyId: any(named: 'facultyId'),
          course: any(named: 'course'),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
