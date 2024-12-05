import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/usecases/add_faculty.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'academic_structure_repo.mock.dart';

void main() {
  late MockAcademicStructureRepo repo;
  late AddFaculty usecase;

  const tFaculty = Faculty.empty();

  setUp(() {
    repo = MockAcademicStructureRepo();
    usecase = AddFaculty(repo);
    registerFallbackValue(tFaculty);
  });

  test(
    'should call the [AcademicStructureRepo.addFaculty]',
    () async {
      when(
        () => repo.addFaculty(any(named: 'faculty')),
      ).thenAnswer((_) async => const Right(null));

      final result = await usecase(tFaculty);
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(() => repo.addFaculty(any(named: 'faculty'))).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
