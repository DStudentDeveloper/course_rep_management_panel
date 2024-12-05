import 'package:course_rep_management_panel/core/usecase/usecase.dart';
import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/course_representative/domain/repos/course_representative_repo.dart';
import 'package:equatable/equatable.dart';

class UpdateCourseRepresentative
    extends UsecaseWithParams<void, UpdateCourseRepresentativeParams> {
  const UpdateCourseRepresentative(this._repo);

  final CourseRepresentativeRepo _repo;

  @override
  ResultFuture<void> call(UpdateCourseRepresentativeParams params) =>
      _repo.updateCourseRepresentative(
        facultyId: params.facultyId,
        courseId: params.courseId,
        levelId: params.levelId,
        courseRepresentativeId: params.courseRepresentativeId,
        updateData: params.updateData,
      );
}

class UpdateCourseRepresentativeParams extends Equatable {
  const UpdateCourseRepresentativeParams({
    required this.facultyId,
    required this.courseId,
    required this.levelId,
    required this.courseRepresentativeId,
    required this.updateData,
  });

  const UpdateCourseRepresentativeParams.empty()
      : facultyId = 'Test String',
        courseId = 'Test String',
        levelId = 'Test String',
        courseRepresentativeId = 'Test String',
        updateData = const {};

  final String facultyId;
  final String courseId;
  final String levelId;
  final String courseRepresentativeId;
  final DataMap updateData;

  @override
  List<dynamic> get props => [
        facultyId,
        courseId,
        levelId,
        courseRepresentativeId,
        updateData,
      ];
}
