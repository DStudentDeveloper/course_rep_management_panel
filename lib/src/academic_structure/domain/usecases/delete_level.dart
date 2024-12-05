import 'package:course_rep_management_panel/core/usecase/usecase.dart';
import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/repos/academic_structure_repo.dart';
import 'package:equatable/equatable.dart';

class DeleteLevel extends UsecaseWithParams<void, DeleteLevelParams> {
  const DeleteLevel(this._repo);

  final AcademicStructureRepo _repo;

  @override
  ResultFuture<void> call(DeleteLevelParams params) => _repo.deleteLevel(
        facultyId: params.facultyId,
        courseId: params.courseId,
        levelId: params.levelId,
      );
}

class DeleteLevelParams extends Equatable {
  const DeleteLevelParams({
    required this.facultyId,
    required this.courseId,
    required this.levelId,
  });

  const DeleteLevelParams.empty()
      : this(
          facultyId: 'Test String',
          courseId: 'Test String',
          levelId: 'Test String',
        );

  final String facultyId;
  final String courseId;
  final String levelId;

  @override
  List<dynamic> get props => [facultyId, courseId, levelId];
}
