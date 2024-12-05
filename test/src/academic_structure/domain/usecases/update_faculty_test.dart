import 'package:course_rep_management_panel/src/academic_structure/domain/usecases/update_faculty.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'academic_structure_repo.mock.dart';

void main() {
  late MockAcademicStructureRepo repo;
  late UpdateFaculty usecase;

  const tFacultyId = 'Test String';

  const tUpdateData = <String, dynamic>{};

  setUp(() {
    repo = MockAcademicStructureRepo();
    usecase = UpdateFaculty(repo);
    registerFallbackValue(tFacultyId);
    registerFallbackValue(tUpdateData);
  });

  test(
    'should call the [AcademicStructureRepo.updateFaculty]',
    () async {
      when(
        () => repo.updateFaculty(
          facultyId: any(named: 'facultyId'),
          updateData: any(named: 'updateData'),
        ),
      ).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await usecase(
        const UpdateFacultyParams(
          facultyId: tFacultyId,
          updateData: tUpdateData,
        ),
      );
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => repo.updateFaculty(
          facultyId: any(named: 'facultyId'),
          updateData: any(named: 'updateData'),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
