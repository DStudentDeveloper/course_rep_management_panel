import 'package:course_rep_management_panel/core/usecase/usecase.dart';
import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/repos/academic_structure_repo.dart';
import 'package:equatable/equatable.dart';

class UpdateCourse extends UsecaseWithParams<void, UpdateCourseParams> {
  const UpdateCourse(this._repo);

  final AcademicStructureRepo _repo;

  @override
  ResultFuture<void> call(UpdateCourseParams params) => _repo.updateCourse(
        facultyId: params.facultyId,
        courseId: params.courseId,
        updateData: params.updateData,
      );
}

class UpdateCourseParams extends Equatable {
  const UpdateCourseParams({
    required this.facultyId,
    required this.courseId,
    required this.updateData,
  });

  UpdateCourseParams.empty()
      : this(facultyId: 'Test String', courseId: 'Test String', updateData: {});

  final String facultyId;
  final String courseId;
  final DataMap updateData;

  @override
  List<dynamic> get props => [facultyId, courseId, updateData];
}
