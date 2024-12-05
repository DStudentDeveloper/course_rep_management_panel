import 'package:course_rep_management_panel/core/usecase/usecase.dart';
import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/repos/academic_structure_repo.dart';

class DeleteFaculty extends UsecaseWithParams<void, String> {
  const DeleteFaculty(this._repo);

  final AcademicStructureRepo _repo;

  @override
  ResultFuture<void> call(String params) => _repo.deleteFaculty(params);
}
