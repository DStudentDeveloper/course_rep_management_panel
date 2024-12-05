import 'package:course_rep_management_panel/core/usecase/usecase.dart';
import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/repos/academic_structure_repo.dart';

class GetCourses extends UsecaseWithParams<List<Course>, Faculty> {
  const GetCourses(this._repo);

  final AcademicStructureRepo _repo;

  @override
  ResultFuture<List<Course>> call(Faculty params) => _repo.getCourses(params);
}
