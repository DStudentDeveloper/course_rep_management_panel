part of 'academic_structure_cubit.dart';

sealed class AcademicStructureState extends Equatable {
  const AcademicStructureState();

  @override
  List<Object> get props => [];
}

final class AcademicStructureInitial extends AcademicStructureState {
  const AcademicStructureInitial();
}

final class AcademicStructureLoading extends AcademicStructureState {
  const AcademicStructureLoading();
}

final class FacultiesLoaded extends AcademicStructureState {
  const FacultiesLoaded(this.faculties);

  final List<Faculty> faculties;

  @override
  List<Object> get props => faculties;
}

final class CoursesLoaded extends AcademicStructureState {
  const CoursesLoaded(this.courses);

  final List<Course> courses;

  @override
  List<Object> get props => courses;
}

final class LevelsLoaded extends AcademicStructureState {
  const LevelsLoaded(this.levels);

  final List<Level> levels;

  @override
  List<Object> get props => levels;
}

final class FacultyUpdated extends AcademicStructureState {
  const FacultyUpdated();
}

final class CourseUpdated extends AcademicStructureState {
  const CourseUpdated();
}

final class LevelUpdated extends AcademicStructureState {
  const LevelUpdated();
}

final class FacultyDeleted extends AcademicStructureState {
  const FacultyDeleted();
}

final class CourseDeleted extends AcademicStructureState {
  const CourseDeleted();
}

final class LevelDeleted extends AcademicStructureState {
  const LevelDeleted();
}

final class LevelsAdded extends AcademicStructureState {
  const LevelsAdded();
}

final class FacultyAdded extends AcademicStructureState {
  const FacultyAdded();
}

final class CourseAdded extends AcademicStructureState {
  const CourseAdded();
}

final class LevelAdded extends AcademicStructureState {
  const LevelAdded();
}

final class AcademicStructureError extends AcademicStructureState {
  const AcademicStructureError({required this.title, required this.message});

  final String title;
  final String message;

  @override
  List<Object> get props => [title, message];
}
