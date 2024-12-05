import 'package:course_rep_management_panel/core/usecase/usecase.dart';
import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/repos/academic_structure_repo.dart';
import 'package:equatable/equatable.dart';

class DeleteCourse extends UsecaseWithParams<void, DeleteCourseParams> {
  const DeleteCourse(this._repo);

  final AcademicStructureRepo _repo;

  @override
  ResultFuture<void> call(DeleteCourseParams params) => _repo.deleteCourse(
        facultyId: params.facultyId,
        courseId: params.courseId,
      );
}

class DeleteCourseParams extends Equatable {
  const DeleteCourseParams({
    required this.facultyId,
    required this.courseId,
  });

  const DeleteCourseParams.empty()
      : this(facultyId: 'Test String', courseId: 'Test String');

  final String facultyId;
  final String courseId;

  @override
  List<dynamic> get props => [facultyId, courseId];
}
