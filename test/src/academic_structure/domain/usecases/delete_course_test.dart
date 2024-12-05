import 'package:course_rep_management_panel/src/academic_structure/domain/usecases/delete_course.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'academic_structure_repo.mock.dart';

void main() {
  late MockAcademicStructureRepo repo;
  late DeleteCourse usecase;

  const tFacultyId = 'Test String';

  const tCourseId = 'Test String';

  setUp(() {
    repo = MockAcademicStructureRepo();
    usecase = DeleteCourse(repo);
    registerFallbackValue(tFacultyId);
    registerFallbackValue(tCourseId);
  });

  test(
    'should call the [AcademicStructureRepo.deleteCourse]',
    () async {
      when(
        () => repo.deleteCourse(
          facultyId: any(named: 'facultyId'),
          courseId: any(named: 'courseId'),
        ),
      ).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await usecase(
        const DeleteCourseParams(
          facultyId: tFacultyId,
          courseId: tCourseId,
        ),
      );
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => repo.deleteCourse(
          facultyId: any(named: 'facultyId'),
          courseId: any(named: 'courseId'),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
