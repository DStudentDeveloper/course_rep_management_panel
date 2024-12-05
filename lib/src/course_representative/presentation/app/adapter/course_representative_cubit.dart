import 'package:bloc/bloc.dart';
import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/level.dart';
import 'package:course_rep_management_panel/src/course_representative/domain/entities/course_representative.dart';
import 'package:course_rep_management_panel/src/course_representative/domain/usecases/add_course_representative.dart';
import 'package:course_rep_management_panel/src/course_representative/domain/usecases/delete_course_representative.dart';
import 'package:course_rep_management_panel/src/course_representative/domain/usecases/get_course_representatives.dart';
import 'package:course_rep_management_panel/src/course_representative/domain/usecases/update_course_representative.dart';
import 'package:equatable/equatable.dart';

part 'course_representative_state.dart';

class CourseRepresentativeCubit extends Cubit<CourseRepresentativeState> {
  CourseRepresentativeCubit({
    required GetCourseRepresentatives getCourseRepresentatives,
    required DeleteCourseRepresentative deleteCourseRepresentative,
    required AddCourseRepresentative addCourseRepresentative,
    required UpdateCourseRepresentative updateCourseRepresentative,
  })  : _getCourseRepresentatives = getCourseRepresentatives,
        _deleteCourseRepresentative = deleteCourseRepresentative,
        _addCourseRepresentative = addCourseRepresentative,
        _updateCourseRepresentative = updateCourseRepresentative,
        super(const CourseRepresentativeInitial());

  final GetCourseRepresentatives _getCourseRepresentatives;
  final DeleteCourseRepresentative _deleteCourseRepresentative;
  final AddCourseRepresentative _addCourseRepresentative;
  final UpdateCourseRepresentative _updateCourseRepresentative;

  Future<void> getCourseRepresentatives({
    required Faculty faculty,
    required Course course,
    required Level level,
  }) async {
    emit(const CourseRepresentativeLoading());
    final result = await _getCourseRepresentatives(
      GetCourseRepresentativesParams(
        faculty: faculty,
        course: course,
        level: level,
      ),
    );
    result.fold(
      (failure) {
        emit(
          CourseRepresentativeError(
            title: failure.statusCode,
            message: failure.message,
          ),
        );
      },
      (faculties) => emit(CourseRepresentativesLoaded(faculties)),
    );
  }

  Future<void> deleteCourseRepresentative({
    required String facultyId,
    required String courseId,
    required String levelId,
    required String courseRepresentativeId,
  }) async {
    emit(const CourseRepresentativeLoading());
    final result = await _deleteCourseRepresentative(
      DeleteCourseRepresentativeParams(
        facultyId: facultyId,
        courseId: courseId,
        levelId: levelId,
        courseRepresentativeId: courseRepresentativeId,
      ),
    );
    result.fold(
      (failure) {
        emit(
          CourseRepresentativeError(
            title: failure.statusCode,
            message: failure.message,
          ),
        );
      },
      (_) => emit(const CourseRepresentativeDeleted()),
    );
  }

  Future<void> addCourseRepresentative({
    required String facultyId,
    required String courseId,
    required String levelId,
    required CourseRepresentative courseRepresentative,
  }) async {
    emit(const CourseRepresentativeLoading());
    final result = await _addCourseRepresentative(
      AddCourseRepresentativeParams(
        facultyId: facultyId,
        courseId: courseId,
        levelId: levelId,
        courseRepresentative: courseRepresentative,
      ),
    );
    result.fold(
      (failure) {
        emit(
          CourseRepresentativeError(
            title: failure.statusCode,
            message: failure.message,
          ),
        );
      },
      (_) => emit(const CourseRepresentativeAdded()),
    );
  }

  Future<void> updateCourseRepresentative({
    required String facultyId,
    required String courseId,
    required String levelId,
    required String courseRepresentativeId,
    required DataMap updateData,
  }) async {
    emit(const CourseRepresentativeLoading());
    final result = await _updateCourseRepresentative(
      UpdateCourseRepresentativeParams(
        facultyId: facultyId,
        courseId: courseId,
        levelId: levelId,
        courseRepresentativeId: courseRepresentativeId,
        updateData: updateData,
      ),
    );
    result.fold(
      (failure) {
        emit(
          CourseRepresentativeError(
            title: failure.statusCode,
            message: failure.message,
          ),
        );
      },
      (_) => emit(const CourseRepresentativeUpdated()),
    );
  }
}
