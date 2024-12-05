import 'package:course_rep_management_panel/core/usecase/usecase.dart';
import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/repos/academic_structure_repo.dart';
import 'package:equatable/equatable.dart';

class UpdateFaculty extends UsecaseWithParams<void, UpdateFacultyParams> {
  const UpdateFaculty(this._repo);

  final AcademicStructureRepo _repo;

  @override
  ResultFuture<void> call(UpdateFacultyParams params) => _repo.updateFaculty(
        facultyId: params.facultyId,
        updateData: params.updateData,
      );
}

class UpdateFacultyParams extends Equatable {
  const UpdateFacultyParams({
    required this.facultyId,
    required this.updateData,
  });

  UpdateFacultyParams.empty() : this(facultyId: 'Test String', updateData: {});

  final String facultyId;
  final DataMap updateData;

  @override
  List<dynamic> get props => [facultyId, updateData];
}
