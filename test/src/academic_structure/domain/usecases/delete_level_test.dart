import 'package:course_rep_management_panel/src/academic_structure/domain/usecases/delete_level.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'academic_structure_repo.mock.dart';

void main() {
  late MockAcademicStructureRepo repo;
  late DeleteLevel usecase;

  const tFacultyId = 'Test String';

  const tCourseId = 'Test String';

  const tLevelId = 'Test String';

  setUp(() {
    repo = MockAcademicStructureRepo();
    usecase = DeleteLevel(repo);
    registerFallbackValue(tFacultyId);
    registerFallbackValue(tCourseId);
    registerFallbackValue(tLevelId);
  });

  test(
    'should call the [AcademicStructureRepo.deleteLevel]',
    () async {
      when(
        () => repo.deleteLevel(
          facultyId: any(named: 'facultyId'),
          courseId: any(named: 'courseId'),
          levelId: any(named: 'levelId'),
        ),
      ).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await usecase(
        const DeleteLevelParams(
          facultyId: tFacultyId,
          courseId: tCourseId,
          levelId: tLevelId,
        ),
      );
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => repo.deleteLevel(
          facultyId: any(named: 'facultyId'),
          courseId: any(named: 'courseId'),
          levelId: any(named: 'levelId'),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
