import 'package:course_rep_management_panel/core/usecase/usecase.dart';
import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/level.dart';
import 'package:course_rep_management_panel/src/course_representative/domain/entities/course_representative.dart';
import 'package:course_rep_management_panel/src/course_representative/domain/repos/course_representative_repo.dart';
import 'package:equatable/equatable.dart';

class GetCourseRepresentatives extends UsecaseWithParams<
    List<CourseRepresentative>, GetCourseRepresentativesParams> {
  const GetCourseRepresentatives(this._repo);

  final CourseRepresentativeRepo _repo;

  @override
  ResultFuture<List<CourseRepresentative>> call(
    GetCourseRepresentativesParams params,
  ) =>
      _repo.getCourseRepresentatives(
        faculty: params.faculty,
        course: params.course,
        level: params.level,
      );
}

class GetCourseRepresentativesParams extends Equatable {
  const GetCourseRepresentativesParams({
    required this.faculty,
    required this.course,
    required this.level,
  });

  const GetCourseRepresentativesParams.empty()
      : faculty = const Faculty.empty(),
        course = const Course.empty(),
        level = const Level.empty();

  final Faculty faculty;
  final Course course;
  final Level level;

  @override
  List<dynamic> get props => [faculty, course, level];
}
