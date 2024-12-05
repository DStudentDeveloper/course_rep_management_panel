import 'package:course_rep_management_panel/src/course_representative/domain/usecases/update_course_representative.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'course_representative_repo.mock.dart';

void main() {
  late MockCourseRepresentativeRepo repo;
  late UpdateCourseRepresentative usecase;

  const tFacultyId = 'Test String';

  const tCourseId = 'Test String';

  const tLevelId = 'Test String';

  const tCourseRepresentativeId = 'Test String';

  const tUpdateData = <String, dynamic>{};

  setUp(() {
    repo = MockCourseRepresentativeRepo();
    usecase = UpdateCourseRepresentative(repo);
    registerFallbackValue(tFacultyId);
    registerFallbackValue(tCourseId);
    registerFallbackValue(tLevelId);
    registerFallbackValue(tCourseRepresentativeId);
    registerFallbackValue(tUpdateData);
  });

  test(
    'should call the [CourseRepresentativeRepo.updateCourseRepresentative]',
    () async {
      when(
        () => repo.updateCourseRepresentative(
          facultyId: any(named: 'facultyId'),
          courseId: any(named: 'courseId'),
          levelId: any(named: 'levelId'),
          courseRepresentativeId: any(named: 'courseRepresentativeId'),
          updateData: any(named: 'updateData'),
        ),
      ).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await usecase(
        const UpdateCourseRepresentativeParams(
          facultyId: tFacultyId,
          courseId: tCourseId,
          levelId: tLevelId,
          courseRepresentativeId: tCourseRepresentativeId,
          updateData: tUpdateData,
        ),
      );
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => repo.updateCourseRepresentative(
          facultyId: any(named: 'facultyId'),
          courseId: any(named: 'courseId'),
          levelId: any(named: 'levelId'),
          courseRepresentativeId: any(named: 'courseRepresentativeId'),
          updateData: any(named: 'updateData'),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
