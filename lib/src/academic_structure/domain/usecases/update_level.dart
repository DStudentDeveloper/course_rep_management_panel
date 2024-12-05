import 'package:course_rep_management_panel/core/usecase/usecase.dart';
import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/repos/academic_structure_repo.dart';
import 'package:equatable/equatable.dart';

class UpdateLevel extends UsecaseWithParams<void, UpdateLevelParams> {
  const UpdateLevel(this._repo);

  final AcademicStructureRepo _repo;

  @override
  ResultFuture<void> call(UpdateLevelParams params) => _repo.updateLevel(
        facultyId: params.facultyId,
        courseId: params.courseId,
        levelId: params.levelId,
        updateData: params.updateData,
      );
}

class UpdateLevelParams extends Equatable {
  const UpdateLevelParams({
    required this.facultyId,
    required this.courseId,
    required this.levelId,
    required this.updateData,
  });

  UpdateLevelParams.empty()
      : this(
          facultyId: 'Test String',
          courseId: 'Test String',
          levelId: 'Test String',
          updateData: {},
        );

  final String facultyId;
  final String courseId;
  final String levelId;
  final DataMap updateData;

  @override
  List<dynamic> get props => [facultyId, courseId, levelId, updateData];
}
