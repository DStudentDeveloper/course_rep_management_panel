import 'package:course_rep_management_panel/src/course_representative/domain/entities/course_representative.dart';
import 'package:course_rep_management_panel/src/course_representative/domain/usecases/add_course_representative.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'course_representative_repo.mock.dart';

void main() {
  late MockCourseRepresentativeRepo repo;
  late AddCourseRepresentative usecase;

  const tFacultyId = 'Test String';

  const tCourseId = 'Test String';

  const tLevelId = 'Test String';

  const tCourseRepresentative = CourseRepresentative.empty();

  setUp(() {
    repo = MockCourseRepresentativeRepo();
    usecase = AddCourseRepresentative(repo);
    registerFallbackValue(tFacultyId);
    registerFallbackValue(tCourseId);
    registerFallbackValue(tLevelId);
    registerFallbackValue(tCourseRepresentative);
  });

  test(
    'should call the [CourseRepresentativeRepo.addCourseRepresentative]',
    () async {
      when(
        () => repo.addCourseRepresentative(
          facultyId: any(named: 'facultyId'),
          courseId: any(named: 'courseId'),
          levelId: any(named: 'levelId'),
          courseRepresentative: any(named: 'courseRepresentative'),
        ),
      ).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await usecase(
        const AddCourseRepresentativeParams(
          facultyId: tFacultyId,
          courseId: tCourseId,
          levelId: tLevelId,
          courseRepresentative: tCourseRepresentative,
        ),
      );
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => repo.addCourseRepresentative(
          facultyId: any(named: 'facultyId'),
          courseId: any(named: 'courseId'),
          levelId: any(named: 'levelId'),
          courseRepresentative: any(named: 'courseRepresentative'),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
