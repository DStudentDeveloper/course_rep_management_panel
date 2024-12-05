import 'package:course_rep_management_panel/src/course_representative/domain/usecases/delete_course_representative.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'course_representative_repo.mock.dart';

void main() {
  late MockCourseRepresentativeRepo repo;
  late DeleteCourseRepresentative usecase;

  const tFacultyId = 'Test String';

  const tCourseId = 'Test String';

  const tLevelId = 'Test String';

  const tCourseRepresentativeId = 'Test String';

  setUp(() {
    repo = MockCourseRepresentativeRepo();
    usecase = DeleteCourseRepresentative(repo);
    registerFallbackValue(tFacultyId);
    registerFallbackValue(tCourseId);
    registerFallbackValue(tLevelId);
    registerFallbackValue(tCourseRepresentativeId);
  });

  test(
    'should call the [CourseRepresentativeRepo.deleteCourseRepresentative]',
    () async {
      when(
        () => repo.deleteCourseRepresentative(
          facultyId: any(named: 'facultyId'),
          courseId: any(named: 'courseId'),
          levelId: any(named: 'levelId'),
          courseRepresentativeId: any(named: 'courseRepresentativeId'),
        ),
      ).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await usecase(
        const DeleteCourseRepresentativeParams(
          facultyId: tFacultyId,
          courseId: tCourseId,
          levelId: tLevelId,
          courseRepresentativeId: tCourseRepresentativeId,
        ),
      );
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => repo.deleteCourseRepresentative(
          facultyId: any(named: 'facultyId'),
          courseId: any(named: 'courseId'),
          levelId: any(named: 'levelId'),
          courseRepresentativeId: any(named: 'courseRepresentativeId'),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
