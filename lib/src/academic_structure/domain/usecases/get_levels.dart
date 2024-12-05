import 'package:course_rep_management_panel/core/usecase/usecase.dart';
import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/level.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/repos/academic_structure_repo.dart';
import 'package:equatable/equatable.dart';

class GetLevels extends UsecaseWithParams<List<Level>, GetLevelsParams> {
  const GetLevels(this._repo);

  final AcademicStructureRepo _repo;

  @override
  ResultFuture<List<Level>> call(GetLevelsParams params) => _repo.getLevels(
        faculty: params.faculty,
        course: params.course,
      );
}

class GetLevelsParams extends Equatable {
  const GetLevelsParams({required this.faculty, required this.course});

  const GetLevelsParams.empty()
      : this(faculty: const Faculty.empty(), course: const Course.empty());

  final Faculty faculty;
  final Course course;

  @override
  List<dynamic> get props => [faculty, course];
}
