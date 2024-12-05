import 'package:course_rep_management_panel/src/academic_structure/domain/usecases/delete_faculty.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'academic_structure_repo.mock.dart';

void main() {
  late MockAcademicStructureRepo repo;
  late DeleteFaculty usecase;

  const tFacultyId = 'Test String';

  setUp(() {
    repo = MockAcademicStructureRepo();
    usecase = DeleteFaculty(repo);
    registerFallbackValue(tFacultyId);
  });

  test(
    'should call the [AcademicStructureRepo.deleteFaculty]',
    () async {
      when(
        () => repo.deleteFaculty(
          any(),
        ),
      ).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await usecase(tFacultyId);
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => repo.deleteFaculty(
          any(),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
