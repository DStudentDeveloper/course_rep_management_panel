import 'package:course_rep_management_panel/src/academic_structure/domain/usecases/update_level.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'academic_structure_repo.mock.dart';

void main() {
  late MockAcademicStructureRepo repo;
  late UpdateLevel usecase;

  const tFacultyId = 'Test String';

  const tCourseId = 'Test String';

  const tLevelId = 'Test String';

  const tUpdateData = <String, dynamic>{};

  setUp(() {
    repo = MockAcademicStructureRepo();
    usecase = UpdateLevel(repo);
    registerFallbackValue(tFacultyId);
    registerFallbackValue(tCourseId);
    registerFallbackValue(tLevelId);
    registerFallbackValue(tUpdateData);
  });

  test(
    'should call the [AcademicStructureRepo.updateLevel]',
    () async {
      when(
        () => repo.updateLevel(
          facultyId: any(named: 'facultyId'),
          courseId: any(named: 'courseId'),
          levelId: any(named: 'levelId'),
          updateData: any(named: 'updateData'),
        ),
      ).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await usecase(
        const UpdateLevelParams(
          facultyId: tFacultyId,
          courseId: tCourseId,
          levelId: tLevelId,
          updateData: tUpdateData,
        ),
      );
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => repo.updateLevel(
          facultyId: any(named: 'facultyId'),
          courseId: any(named: 'courseId'),
          levelId: any(named: 'levelId'),
          updateData: any(named: 'updateData'),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
