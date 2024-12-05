import 'package:course_rep_management_panel/core/usecase/usecase.dart';
import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/level.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/repos/academic_structure_repo.dart';
import 'package:equatable/equatable.dart';

class AddLevel extends UsecaseWithParams<void, AddLevelParams> {
  const AddLevel(this._repo);

  final AcademicStructureRepo _repo;

  @override
  ResultFuture<void> call(AddLevelParams params) => _repo.addLevel(
        facultyId: params.facultyId,
        courseId: params.courseId,
        level: params.level,
      );
}

class AddLevelParams extends Equatable {
  const AddLevelParams({
    required this.facultyId,
    required this.courseId,
    required this.level,
  });

  const AddLevelParams.empty()
      : this(
          facultyId: 'Test String',
          courseId: 'Test String',
          level: const Level.empty(),
        );

  final String facultyId;
  final String courseId;
  final Level level;

  @override
  List<dynamic> get props => [facultyId, courseId, level];
}
