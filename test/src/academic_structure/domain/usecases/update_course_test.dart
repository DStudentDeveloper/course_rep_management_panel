import 'package:course_rep_management_panel/src/academic_structure/domain/usecases/update_course.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'academic_structure_repo.mock.dart';

void main() {
  late MockAcademicStructureRepo repo;
  late UpdateCourse usecase;

  const tFacultyId = 'Test String';

  const tCourseId = 'Test String';

  const tUpdateData = <String, dynamic>{};

  setUp(() {
    repo = MockAcademicStructureRepo();
    usecase = UpdateCourse(repo);
    registerFallbackValue(tFacultyId);
    registerFallbackValue(tCourseId);
    registerFallbackValue(tUpdateData);
  });

  test(
    'should call the [AcademicStructureRepo.updateCourse]',
    () async {
      when(
        () => repo.updateCourse(
          facultyId: any(named: 'facultyId'),
          courseId: any(named: 'courseId'),
          updateData: any(named: 'updateData'),
        ),
      ).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await usecase(
        const UpdateCourseParams(
          facultyId: tFacultyId,
          courseId: tCourseId,
          updateData: tUpdateData,
        ),
      );
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => repo.updateCourse(
          facultyId: any(named: 'facultyId'),
          courseId: any(named: 'courseId'),
          updateData: any(named: 'updateData'),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
