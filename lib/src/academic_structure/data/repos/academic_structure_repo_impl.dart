import 'package:course_rep_management_panel/core/errors/exceptions.dart';
import 'package:course_rep_management_panel/core/errors/failure.dart';
import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/academic_structure/data/datasources/academic_structure_remote_data_src.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/level.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/repos/academic_structure_repo.dart';
import 'package:dartz/dartz.dart';

class AcademicStructureRepoImpl implements AcademicStructureRepo {
  const AcademicStructureRepoImpl(this._remoteDataSource);

  final AcademicStructureRemoteDataSrc _remoteDataSource;

  @override
  ResultFuture<List<Faculty>> getFaculties() async {
    try {
      final result = await _remoteDataSource.getFaculties();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Course>> getCourses(Faculty faculty) async {
    try {
      final result = await _remoteDataSource.getCourses(faculty);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Level>> getLevels({
    required Faculty faculty,
    required Course course,
  }) async {
    try {
      final result = await _remoteDataSource.getLevels(
        faculty: faculty,
        course: course,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> addFaculty(Faculty faculty) async {
    try {
      await _remoteDataSource.addFaculty(faculty);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> updateFaculty({
    required String facultyId,
    required DataMap updateData,
  }) async {
    try {
      await _remoteDataSource.updateFaculty(
        facultyId: facultyId,
        updateData: updateData,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> deleteFaculty(String facultyId) async {
    try {
      await _remoteDataSource.deleteFaculty(facultyId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> addCourse({
    required String facultyId,
    required Course course,
  }) async {
    try {
      await _remoteDataSource.addCourse(facultyId: facultyId, course: course);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> updateCourse({
    required String facultyId,
    required String courseId,
    required DataMap updateData,
  }) async {
    try {
      await _remoteDataSource.updateCourse(
        facultyId: facultyId,
        courseId: courseId,
        updateData: updateData,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> deleteCourse({
    required String facultyId,
    required String courseId,
  }) async {
    try {
      await _remoteDataSource.deleteCourse(
        facultyId: facultyId,
        courseId: courseId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> addLevel({
    required String facultyId,
    required String courseId,
    required Level level,
  }) async {
    try {
      await _remoteDataSource.addLevel(
        facultyId: facultyId,
        courseId: courseId,
        level: level,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> updateLevel({
    required String facultyId,
    required String courseId,
    required String levelId,
    required DataMap updateData,
  }) async {
    try {
      await _remoteDataSource.updateLevel(
        facultyId: facultyId,
        courseId: courseId,
        levelId: levelId,
        updateData: updateData,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> deleteLevel({
    required String facultyId,
    required String courseId,
    required String levelId,
  }) async {
    try {
      await _remoteDataSource.deleteLevel(
        facultyId: facultyId,
        courseId: courseId,
        levelId: levelId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
