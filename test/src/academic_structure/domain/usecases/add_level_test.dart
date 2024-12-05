import 'package:course_rep_management_panel/src/academic_structure/domain/entities/level.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/usecases/add_level.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'academic_structure_repo.mock.dart';

void main() {
  late MockAcademicStructureRepo repo;
  late AddLevel usecase;

  const tFacultyId = 'Test String';

  const tCourseId = 'Test String';

  const tLevel = Level.empty();

  setUp(() {
    repo = MockAcademicStructureRepo();
    usecase = AddLevel(repo);
    registerFallbackValue(tFacultyId);
    registerFallbackValue(tCourseId);
    registerFallbackValue(tLevel);
  });

  test(
    'should call the [AcademicStructureRepo.addLevel]',
    () async {
      when(
        () => repo.addLevel(
          facultyId: any(named: 'facultyId'),
          courseId: any(named: 'courseId'),
          level: any(named: 'level'),
        ),
      ).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await usecase(
        const AddLevelParams(
          facultyId: tFacultyId,
          courseId: tCourseId,
          level: tLevel,
        ),
      );
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => repo.addLevel(
          facultyId: any(named: 'facultyId'),
          courseId: any(named: 'courseId'),
          level: any(named: 'level'),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
