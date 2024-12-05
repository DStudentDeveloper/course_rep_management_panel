import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/usecases/get_faculties.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../academic_structure/domain/usecases/academic_structure_repo.mock.dart';

void main() {
  late MockAcademicStructureRepo repo;
  late GetFaculties usecase;
  const tResult = <Faculty>[Faculty.empty()];

  setUp(() {
    repo = MockAcademicStructureRepo();
    usecase = GetFaculties(repo);
  });

  test(
    'should return [List<Faculty>] from the repo',
    () async {
      when(
        () => repo.getFaculties(),
      ).thenAnswer(
        (_) async => const Right(tResult),
      );

      final result = await usecase();
      expect(result, equals(const Right<dynamic, List<Faculty>>(tResult)));
      verify(
        () => repo.getFaculties(),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
