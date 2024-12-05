import 'package:course_rep_management_panel/core/usecase/usecase.dart';
import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/course_representative/domain/repos/course_representative_repo.dart';
import 'package:equatable/equatable.dart';

class DeleteCourseRepresentative
    extends UsecaseWithParams<void, DeleteCourseRepresentativeParams> {
  const DeleteCourseRepresentative(this._repo);

  final CourseRepresentativeRepo _repo;

  @override
  ResultFuture<void> call(DeleteCourseRepresentativeParams params) =>
      _repo.deleteCourseRepresentative(
        facultyId: params.facultyId,
        courseId: params.courseId,
        levelId: params.levelId,
        courseRepresentativeId: params.courseRepresentativeId,
      );
}

class DeleteCourseRepresentativeParams extends Equatable {
  const DeleteCourseRepresentativeParams({
    required this.facultyId,
    required this.courseId,
    required this.levelId,
    required this.courseRepresentativeId,
  });

  const DeleteCourseRepresentativeParams.empty()
      : facultyId = 'Test String',
        courseId = 'Test String',
        levelId = 'Test String',
        courseRepresentativeId = 'Test String';

  final String facultyId;
  final String courseId;
  final String levelId;
  final String courseRepresentativeId;

  @override
  List<dynamic> get props => [
        facultyId,
        courseId,
        levelId,
        courseRepresentativeId,
      ];
}
