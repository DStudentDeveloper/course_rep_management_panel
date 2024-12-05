import 'package:course_rep_management_panel/core/usecase/usecase.dart';
import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/repos/academic_structure_repo.dart';
import 'package:equatable/equatable.dart';

class AddCourse extends UsecaseWithParams<void, AddCourseParams> {
  const AddCourse(this._repo);

  final AcademicStructureRepo _repo;

  @override
  ResultFuture<void> call(AddCourseParams params) => _repo.addCourse(
        facultyId: params.facultyId,
        course: params.course,
      );
}

class AddCourseParams extends Equatable {
  const AddCourseParams({
    required this.facultyId,
    required this.course,
  });

  const AddCourseParams.empty()
      : this(facultyId: 'Test String', course: const Course.empty());

  final String facultyId;
  final Course course;

  @override
  List<dynamic> get props => [facultyId, course];
}
