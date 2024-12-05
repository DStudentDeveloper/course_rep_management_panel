import 'package:course_rep_management_panel/core/usecase/usecase.dart';
import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/course_representative/domain/entities/course_representative.dart';
import 'package:course_rep_management_panel/src/course_representative/domain/repos/course_representative_repo.dart';
import 'package:equatable/equatable.dart';

class AddCourseRepresentative
    extends UsecaseWithParams<void, AddCourseRepresentativeParams> {
  const AddCourseRepresentative(this._repo);

  final CourseRepresentativeRepo _repo;

  @override
  ResultFuture<void> call(AddCourseRepresentativeParams params) =>
      _repo.addCourseRepresentative(
        facultyId: params.facultyId,
        courseId: params.courseId,
        levelId: params.levelId,
        courseRepresentative: params.courseRepresentative,
      );
}

class AddCourseRepresentativeParams extends Equatable {
  const AddCourseRepresentativeParams({
    required this.facultyId,
    required this.courseId,
    required this.levelId,
    required this.courseRepresentative,
  });

  const AddCourseRepresentativeParams.empty()
      : facultyId = 'Test String',
        courseId = 'Test String',
        levelId = 'Test String',
        courseRepresentative = const CourseRepresentative.empty();

  final String facultyId;
  final String courseId;
  final String levelId;
  final CourseRepresentative courseRepresentative;

  @override
  List<dynamic> get props => [
        facultyId,
        courseId,
        levelId,
        courseRepresentative,
      ];
}
