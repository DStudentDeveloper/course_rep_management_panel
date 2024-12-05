import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/level.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/usecases/get_levels.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../academic_structure/domain/usecases/academic_structure_repo.mock.dart';

void main() {
  late MockAcademicStructureRepo repo;
  late GetLevels usecase;

  const tFaculty = Faculty.empty();

  const tCourse = Course.empty();
  const tResult = <Level>[Level.empty()];

  setUp(() {
    repo = MockAcademicStructureRepo();
    usecase = GetLevels(repo);
    registerFallbackValue(tFaculty);
    registerFallbackValue(tCourse);
  });

  test(
    'should return [List<Level>] from the repo',
    () async {
      when(
        () => repo.getLevels(
          faculty: any(named: 'faculty'),
          course: any(named: 'course'),
        ),
      ).thenAnswer(
        (_) async => const Right(tResult),
      );

      final result = await usecase(
        const GetLevelsParams(
          faculty: tFaculty,
          course: tCourse,
        ),
      );
      expect(result, equals(const Right<dynamic, List<Level>>(tResult)));
      verify(
        () => repo.getLevels(
          faculty: any(named: 'faculty'),
          course: any(named: 'course'),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
