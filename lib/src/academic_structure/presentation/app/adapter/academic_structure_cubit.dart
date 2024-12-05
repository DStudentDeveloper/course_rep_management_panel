import 'package:bloc/bloc.dart';
import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/level.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/usecases/add_course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/usecases/add_faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/usecases/add_level.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/usecases/delete_course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/usecases/delete_faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/usecases/delete_level.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/usecases/get_courses.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/usecases/get_faculties.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/usecases/get_levels.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/usecases/update_course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/usecases/update_faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/usecases/update_level.dart';
import 'package:equatable/equatable.dart';

part 'academic_structure_state.dart';

class AcademicStructureCubit extends Cubit<AcademicStructureState> {
  AcademicStructureCubit({
    required GetCourses getCourses,
    required GetLevels getLevels,
    required GetFaculties getFaculties,
    required AddCourse addCourse,
    required UpdateCourse updateCourse,
    required DeleteCourse deleteCourse,
    required AddLevel addLevel,
    required UpdateLevel updateLevel,
    required DeleteLevel deleteLevel,
    required AddFaculty addFaculty,
    required UpdateFaculty updateFaculty,
    required DeleteFaculty deleteFaculty,
  })  : _getCourses = getCourses,
        _getLevels = getLevels,
        _getFaculties = getFaculties,
        _addCourse = addCourse,
        _updateCourse = updateCourse,
        _deleteCourse = deleteCourse,
        _addLevel = addLevel,
        _updateLevel = updateLevel,
        _deleteLevel = deleteLevel,
        _addFaculty = addFaculty,
        _updateFaculty = updateFaculty,
        _deleteFaculty = deleteFaculty,
        super(const AcademicStructureInitial());

  final GetCourses _getCourses;
  final GetLevels _getLevels;
  final GetFaculties _getFaculties;
  final AddCourse _addCourse;
  final UpdateCourse _updateCourse;
  final DeleteCourse _deleteCourse;
  final AddLevel _addLevel;
  final UpdateLevel _updateLevel;
  final DeleteLevel _deleteLevel;
  final AddFaculty _addFaculty;
  final UpdateFaculty _updateFaculty;
  final DeleteFaculty _deleteFaculty;

  Future<void> getFaculties() async {
    emit(const AcademicStructureLoading());
    final result = await _getFaculties();
    result.fold(
      (failure) {
        emit(
          AcademicStructureError(
            title: failure.statusCode,
            message: failure.message,
          ),
        );
      },
      (faculties) => emit(FacultiesLoaded(faculties)),
    );
  }

  Future<void> getCourses(Faculty faculty) async {
    emit(const AcademicStructureLoading());
    final result = await _getCourses(faculty);
    result.fold(
      (failure) {
        emit(
          AcademicStructureError(
            title: failure.statusCode,
            message: failure.message,
          ),
        );
      },
      (courses) => emit(CoursesLoaded(courses)),
    );
  }

  Future<void> getLevels({
    required Faculty faculty,
    required Course course,
  }) async {
    emit(const AcademicStructureLoading());
    final result = await _getLevels(
      GetLevelsParams(faculty: faculty, course: course),
    );
    result.fold(
      (failure) {
        emit(
          AcademicStructureError(
            title: failure.statusCode,
            message: failure.message,
          ),
        );
      },
      (levels) => emit(LevelsLoaded(levels)),
    );
  }

  Future<void> addFaculty(Faculty faculty) async {
    emit(const AcademicStructureLoading());
    final result = await _addFaculty(faculty);
    result.fold(
      (failure) {
        emit(
          AcademicStructureError(
            title: failure.statusCode,
            message: failure.message,
          ),
        );
      },
      (_) => emit(const FacultyAdded()),
    );
  }

  Future<void> addCourse({
    required String facultyId,
    required Course course,
  }) async {
    emit(const AcademicStructureLoading());
    final result = await _addCourse(
      AddCourseParams(facultyId: facultyId, course: course),
    );
    result.fold(
      (failure) {
        emit(
          AcademicStructureError(
            title: failure.statusCode,
            message: failure.message,
          ),
        );
      },
      (_) => emit(const CourseAdded()),
    );
  }

  Future<void> addLevel({
    required String facultyId,
    required String courseId,
    required Level level,
  }) async {
    emit(const AcademicStructureLoading());
    final result = await _addLevel(
      AddLevelParams(facultyId: facultyId, courseId: courseId, level: level),
    );
    result.fold(
      (failure) {
        emit(
          AcademicStructureError(
            title: failure.statusCode,
            message: failure.message,
          ),
        );
      },
      (_) => emit(const LevelAdded()),
    );
  }

  Future<void> updateFaculty({
    required String facultyId,
    required DataMap updateData,
  }) async {
    emit(const AcademicStructureLoading());
    final result = await _updateFaculty(
      UpdateFacultyParams(facultyId: facultyId, updateData: updateData),
    );
    result.fold(
      (failure) {
        emit(
          AcademicStructureError(
            title: failure.statusCode,
            message: failure.message,
          ),
        );
      },
      (_) => emit(const FacultyUpdated()),
    );
  }

  Future<void> updateCourse({
    required String facultyId,
    required String courseId,
    required DataMap updateData,
  }) async {
    emit(const AcademicStructureLoading());
    final result = await _updateCourse(
      UpdateCourseParams(
        facultyId: facultyId,
        courseId: courseId,
        updateData: updateData,
      ),
    );
    result.fold(
      (failure) {
        emit(
          AcademicStructureError(
            title: failure.statusCode,
            message: failure.message,
          ),
        );
      },
      (_) => emit(const CourseUpdated()),
    );
  }

  Future<void> updateLevel({
    required String facultyId,
    required String courseId,
    required String levelId,
    required DataMap updateData,
  }) async {
    emit(const AcademicStructureLoading());
    final result = await _updateLevel(
      UpdateLevelParams(
        facultyId: facultyId,
        courseId: courseId,
        levelId: levelId,
        updateData: updateData,
      ),
    );
    result.fold(
      (failure) {
        emit(
          AcademicStructureError(
            title: failure.statusCode,
            message: failure.message,
          ),
        );
      },
      (_) => emit(const LevelUpdated()),
    );
  }

  Future<void> deleteFaculty(String facultyId) async {
    emit(const AcademicStructureLoading());
    final result = await _deleteFaculty(facultyId);
    result.fold(
      (failure) {
        emit(
          AcademicStructureError(
            title: failure.statusCode,
            message: failure.message,
          ),
        );
      },
      (_) => emit(const FacultyDeleted()),
    );
  }

  Future<void> deleteCourse({
    required String facultyId,
    required String courseId,
  }) async {
    emit(const AcademicStructureLoading());
    final result = await _deleteCourse(
      DeleteCourseParams(facultyId: facultyId, courseId: courseId),
    );
    result.fold(
      (failure) {
        emit(
          AcademicStructureError(
            title: failure.statusCode,
            message: failure.message,
          ),
        );
      },
      (_) => emit(const CourseDeleted()),
    );
  }

  Future<void> deleteLevel({
    required String facultyId,
    required String courseId,
    required String levelId,
  }) async {
    emit(const AcademicStructureLoading());
    final result = await _deleteLevel(
      DeleteLevelParams(
        facultyId: facultyId,
        courseId: courseId,
        levelId: levelId,
      ),
    );
    result.fold(
      (failure) {
        emit(
          AcademicStructureError(
            title: failure.statusCode,
            message: failure.message,
          ),
        );
      },
      (_) => emit(const LevelDeleted()),
    );
  }

  Future<void> addLevels({
    required String facultyId,
    required String courseId,
    required List<Level> levels,
  }) async {
    emit(const AcademicStructureLoading());

    var currentIndex = 0;

    while (currentIndex < levels.length) {
      final result = await _addLevel(
        AddLevelParams(
          facultyId: facultyId,
          courseId: courseId,
          level: levels[currentIndex],
        ),
      );

      result.fold(
        (failure) {
          emit(
            AcademicStructureError(
              title: failure.statusCode,
              message: failure.message,
            ),
          );

          currentIndex = levels.length;
        },
        (_) {
          if (currentIndex == levels.length - 1) {
            emit(const LevelsAdded());
          }
          currentIndex++;
        },
      );
    }
  }
}
