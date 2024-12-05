import 'package:course_rep_management_panel/core/errors/exceptions.dart';
import 'package:course_rep_management_panel/core/errors/failure.dart';
import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/level.dart';
import 'package:course_rep_management_panel/src/course_representative/data/datasources/course_representative_remote_data_src.dart';
import 'package:course_rep_management_panel/src/course_representative/domain/entities/course_representative.dart';
import 'package:course_rep_management_panel/src/course_representative/domain/repos/course_representative_repo.dart';
import 'package:dartz/dartz.dart';

class CourseRepresentativeRepoImpl implements CourseRepresentativeRepo {
  const CourseRepresentativeRepoImpl(this._remoteDataSource);

  final CourseRepresentativeRemoteDataSrc _remoteDataSource;

  @override
  ResultFuture<List<CourseRepresentative>> getCourseRepresentatives({
    required Faculty faculty,
    required Course course,
    required Level level,
  }) async {
    try {
      final result = await _remoteDataSource.getCourseRepresentatives(
        faculty: faculty,
        course: course,
        level: level,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> addCourseRepresentative({
    required String facultyId,
    required String courseId,
    required String levelId,
    required CourseRepresentative courseRepresentative,
  }) async {
    try {
      await _remoteDataSource.addCourseRepresentative(
        facultyId: facultyId,
        courseId: courseId,
        levelId: levelId,
        courseRepresentative: courseRepresentative,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> updateCourseRepresentative({
    required String facultyId,
    required String courseId,
    required String levelId,
    required String courseRepresentativeId,
    required DataMap updateData,
  }) async {
    try {
      await _remoteDataSource.updateCourseRepresentative(
        facultyId: facultyId,
        courseId: courseId,
        levelId: levelId,
        courseRepresentativeId: courseRepresentativeId,
        updateData: updateData,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> deleteCourseRepresentative({
    required String facultyId,
    required String courseId,
    required String levelId,
    required String courseRepresentativeId,
  }) async {
    try {
      await _remoteDataSource.deleteCourseRepresentative(
        facultyId: facultyId,
        courseId: courseId,
        levelId: levelId,
        courseRepresentativeId: courseRepresentativeId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
