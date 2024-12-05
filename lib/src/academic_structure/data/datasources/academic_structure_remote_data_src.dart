import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_rep_management_panel/core/errors/exceptions.dart';
import 'package:course_rep_management_panel/core/utils/network_utils.dart';
import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/academic_structure/data/models/course_model.dart';
import 'package:course_rep_management_panel/src/academic_structure/data/models/faculty_model.dart';
import 'package:course_rep_management_panel/src/academic_structure/data/models/level_model.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/level.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AcademicStructureRemoteDataSrc {
  Future<List<FacultyModel>> getFaculties();

  Future<List<CourseModel>> getCourses(Faculty faculty);

  Future<List<LevelModel>> getLevels({
    required Faculty faculty,
    required Course course,
  });

  Future<void> addFaculty(Faculty faculty);

  Future<void> updateFaculty({
    required String facultyId,
    required DataMap updateData,
  });

  Future<void> deleteFaculty(String facultyId);

  Future<void> addCourse({
    required String facultyId,
    required Course course,
  });

  Future<void> updateCourse({
    required String facultyId,
    required String courseId,
    required DataMap updateData,
  });

  Future<void> deleteCourse({
    required String facultyId,
    required String courseId,
  });

  Future<void> addLevel({
    required String facultyId,
    required String courseId,
    required Level level,
  });

  Future<void> updateLevel({
    required String facultyId,
    required String courseId,
    required String levelId,
    required DataMap updateData,
  });

  Future<void> deleteLevel({
    required String facultyId,
    required String courseId,
    required String levelId,
  });
}

class AcademicStructureRemoteDataSrcImpl
    implements AcademicStructureRemoteDataSrc {
  const AcademicStructureRemoteDataSrcImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  @override
  Future<List<FacultyModel>> getFaculties() async {
    try {
      await NetworkUtils.authorizeUser(_auth);

      final faculties =
          await _firestore.collection('faculties').orderBy('name').get();

      return faculties.docs
          .map((faculty) => FacultyModel.fromMap(faculty.data()))
          .toList();
    } on FirebaseException catch (e) {
      return NetworkUtils.handleRemoteSourceException<List<FacultyModel>>(
        e,
        repositoryName: 'AcademicStructureRemoteDataSrcImpl',
        methodName: 'getFaculties',
        stackTrace: e.stackTrace,
        statusCode: e.code,
        errorMessage: e.message,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      return NetworkUtils.handleRemoteSourceException<List<FacultyModel>>(
        e,
        repositoryName: 'AcademicStructureRemoteDataSrcImpl',
        methodName: 'getFaculties',
        stackTrace: s,
      );
    }
  }

  @override
  Future<List<CourseModel>> getCourses(Faculty faculty) async {
    try {
      await NetworkUtils.authorizeUser(_auth);

      final courses = await _firestore
          .collection('faculties')
          .doc(faculty.id)
          .collection('courses')
          .orderBy('name')
          .get();

      return courses.docs.map((course) {
        final map = course.data();
        map['faculty'] = faculty;
        return CourseModel.fromMap(map);
      }).toList();
    } on FirebaseException catch (e) {
      return NetworkUtils.handleRemoteSourceException<List<CourseModel>>(
        e,
        repositoryName: 'AcademicStructureRemoteDataSrcImpl',
        methodName: 'getCourses',
        stackTrace: e.stackTrace,
        statusCode: e.code,
        errorMessage: e.message,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      return NetworkUtils.handleRemoteSourceException<List<CourseModel>>(
        e,
        repositoryName: 'AcademicStructureRemoteDataSrcImpl',
        methodName: 'getCourses',
        stackTrace: s,
      );
    }
  }

  @override
  Future<List<LevelModel>> getLevels({
    required Faculty faculty,
    required Course course,
  }) async {
    try {
      await NetworkUtils.authorizeUser(_auth);

      final levels = await _firestore
          .collection('faculties')
          .doc(faculty.id)
          .collection('courses')
          .doc(course.id)
          .collection('levels')
          .orderBy('name')
          .get();

      return levels.docs.map((level) {
        final map = level.data();
        map['course'] = course;
        map['faculty'] = faculty;
        return LevelModel.fromMap(map);
      }).toList();
    } on FirebaseException catch (e) {
      return NetworkUtils.handleRemoteSourceException<List<LevelModel>>(
        e,
        repositoryName: 'AcademicStructureRemoteDataSrcImpl',
        methodName: 'getLevels',
        stackTrace: e.stackTrace,
        statusCode: e.code,
        errorMessage: e.message,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      return NetworkUtils.handleRemoteSourceException<List<LevelModel>>(
        e,
        repositoryName: 'AcademicStructureRemoteDataSrcImpl',
        methodName: 'getLevels',
        stackTrace: s,
      );
    }
  }

  @override
  Future<void> addCourse({
    required String facultyId,
    required Course course,
  }) async {
    try {
      await NetworkUtils.authorizeUser(_auth);

      final courseDoc = _firestore
          .collection('faculties')
          .doc(facultyId)
          .collection('courses')
          .doc();

      final courseToUpload = (course as CourseModel).copyWith(id: courseDoc.id);
      await courseDoc.set(courseToUpload.toMap());
    } on FirebaseException catch (e) {
      return NetworkUtils.handleRemoteSourceException<void>(
        e,
        repositoryName: 'AcademicStructureRemoteDataSrcImpl',
        methodName: 'addCourse',
        stackTrace: e.stackTrace,
        statusCode: e.code,
        errorMessage: e.message,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      return NetworkUtils.handleRemoteSourceException<void>(
        e,
        repositoryName: 'AcademicStructureRemoteDataSrcImpl',
        methodName: 'addCourse',
        stackTrace: s,
      );
    }
  }

  @override
  Future<void> addFaculty(Faculty faculty) async {
    try {
      await NetworkUtils.authorizeUser(_auth);

      final facultyDoc = _firestore.collection('faculties').doc();
      final facultyToUpload = (faculty as FacultyModel).copyWith(
        id: facultyDoc.id,
      );
      await facultyDoc.set(facultyToUpload.toMap());
    } on FirebaseException catch (e) {
      return NetworkUtils.handleRemoteSourceException<void>(
        e,
        repositoryName: 'AcademicStructureRemoteDataSrcImpl',
        methodName: 'addFaculty',
        stackTrace: e.stackTrace,
        statusCode: e.code,
        errorMessage: e.message,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      return NetworkUtils.handleRemoteSourceException<void>(
        e,
        repositoryName: 'AcademicStructureRemoteDataSrcImpl',
        methodName: 'addFaculty',
        stackTrace: s,
      );
    }
  }

  @override
  Future<void> addLevel({
    required String facultyId,
    required String courseId,
    required Level level,
  }) async {
    try {
      await NetworkUtils.authorizeUser(_auth);

      final levelDoc = _firestore
          .collection('faculties')
          .doc(facultyId)
          .collection('courses')
          .doc(courseId)
          .collection('levels')
          .doc();

      final levelToUpload = (level as LevelModel).copyWith(id: levelDoc.id);
      await levelDoc.set(levelToUpload.toMap());
    } on FirebaseException catch (e) {
      return NetworkUtils.handleRemoteSourceException<void>(
        e,
        repositoryName: 'AcademicStructureRemoteDataSrcImpl',
        methodName: 'addLevel',
        stackTrace: e.stackTrace,
        statusCode: e.code,
        errorMessage: e.message,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      return NetworkUtils.handleRemoteSourceException<void>(
        e,
        repositoryName: 'AcademicStructureRemoteDataSrcImpl',
        methodName: 'addLevel',
        stackTrace: s,
      );
    }
  }

  @override
  Future<void> deleteCourse({
    required String facultyId,
    required String courseId,
  }) async {
    try {
      await NetworkUtils.authorizeUser(_auth);

      final batch = _firestore.batch();

      await _atomicallyDeleteCourse(
        facultyId: facultyId,
        courseId: courseId,
        batch: batch,
      );
      await batch.commit();
    } on FirebaseException catch (e) {
      return NetworkUtils.handleRemoteSourceException<void>(
        e,
        repositoryName: 'AcademicStructureRemoteDataSrcImpl',
        methodName: 'deleteCourse',
        stackTrace: e.stackTrace,
        statusCode: e.code,
        errorMessage: e.message,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      return NetworkUtils.handleRemoteSourceException<void>(
        e,
        repositoryName: 'AcademicStructureRemoteDataSrcImpl',
        methodName: 'deleteCourse',
        stackTrace: s,
      );
    }
  }

  @override
  Future<void> deleteFaculty(String facultyId) async {
    try {
      await NetworkUtils.authorizeUser(_auth);

      final batch = _firestore.batch();
      await _atomicallyDeleteFaculty(facultyId: facultyId, batch: batch);
      await batch.commit();
    } on FirebaseException catch (e) {
      return NetworkUtils.handleRemoteSourceException<void>(
        e,
        repositoryName: 'AcademicStructureRemoteDataSrcImpl',
        methodName: 'deleteFaculty',
        stackTrace: e.stackTrace,
        statusCode: e.code,
        errorMessage: e.message,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      return NetworkUtils.handleRemoteSourceException<void>(
        e,
        repositoryName: 'AcademicStructureRemoteDataSrcImpl',
        methodName: 'deleteFaculty',
        stackTrace: s,
      );
    }
  }

  @override
  Future<void> deleteLevel({
    required String facultyId,
    required String courseId,
    required String levelId,
  }) async {
    try {
      await NetworkUtils.authorizeUser(_auth);
      final batch = _firestore.batch();
      await _atomicallyDeleteLevel(
        facultyId: facultyId,
        courseId: courseId,
        levelId: levelId,
        batch: batch,
      );

      await batch.commit();
    } on FirebaseException catch (e) {
      return NetworkUtils.handleRemoteSourceException<void>(
        e,
        repositoryName: 'AcademicStructureRemoteDataSrcImpl',
        methodName: 'deleteLevel',
        stackTrace: e.stackTrace,
        statusCode: e.code,
        errorMessage: e.message,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      return NetworkUtils.handleRemoteSourceException<void>(
        e,
        repositoryName: 'AcademicStructureRemoteDataSrcImpl',
        methodName: 'deleteLevel',
        stackTrace: s,
      );
    }
  }

  @override
  Future<void> updateCourse({
    required String facultyId,
    required String courseId,
    required DataMap updateData,
  }) async {
    try {
      await NetworkUtils.authorizeUser(_auth);

      final updateToBeUploaded = <String, dynamic>{};

      if (updateData case {'name': final String name}) {
        updateToBeUploaded['name'] = name;
      }

      if (updateToBeUploaded.isNotEmpty) {
        await _firestore
            .collection('faculties')
            .doc(facultyId)
            .collection('courses')
            .doc(courseId)
            .update(updateToBeUploaded);
      }
    } on FirebaseException catch (e) {
      return NetworkUtils.handleRemoteSourceException<void>(
        e,
        repositoryName: 'AcademicStructureRemoteDataSrcImpl',
        methodName: 'updateCourse',
        stackTrace: e.stackTrace,
        statusCode: e.code,
        errorMessage: e.message,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      return NetworkUtils.handleRemoteSourceException<void>(
        e,
        repositoryName: 'AcademicStructureRemoteDataSrcImpl',
        methodName: 'updateCourse',
        stackTrace: s,
      );
    }
  }

  @override
  Future<void> updateFaculty({
    required String facultyId,
    required DataMap updateData,
  }) async {
    try {
      await NetworkUtils.authorizeUser(_auth);

      final updateToBeUploaded = <String, dynamic>{};

      if (updateData case {'name': final String name}) {
        updateToBeUploaded['name'] = name;
      }

      if (updateToBeUploaded.isNotEmpty) {
        await _firestore.collection('faculties').doc(facultyId).update(
              updateToBeUploaded,
            );
      }
    } on FirebaseException catch (e) {
      return NetworkUtils.handleRemoteSourceException<void>(
        e,
        repositoryName: 'AcademicStructureRemoteDataSrcImpl',
        methodName: 'updateFaculty',
        stackTrace: e.stackTrace,
        statusCode: e.code,
        errorMessage: e.message,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      return NetworkUtils.handleRemoteSourceException<void>(
        e,
        repositoryName: 'AcademicStructureRemoteDataSrcImpl',
        methodName: 'updateFaculty',
        stackTrace: s,
      );
    }
  }

  @override
  Future<void> updateLevel({
    required String facultyId,
    required String courseId,
    required String levelId,
    required DataMap updateData,
  }) async {
    try {
      await NetworkUtils.authorizeUser(_auth);

      final updateToBeUploaded = <String, dynamic>{};

      if (updateData case {'name': final String name}) {
        updateToBeUploaded['name'] = name;
      }

      if (updateToBeUploaded.isNotEmpty) {
        await _firestore
            .collection('faculties')
            .doc(facultyId)
            .collection('courses')
            .doc(courseId)
            .collection('levels')
            .doc(levelId)
            .update(updateToBeUploaded);
      }
    } on FirebaseException catch (e) {
      return NetworkUtils.handleRemoteSourceException<void>(
        e,
        repositoryName: 'AcademicStructureRemoteDataSrcImpl',
        methodName: 'updateLevel',
        stackTrace: e.stackTrace,
        statusCode: e.code,
        errorMessage: e.message,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      return NetworkUtils.handleRemoteSourceException<void>(
        e,
        repositoryName: 'AcademicStructureRemoteDataSrcImpl',
        methodName: 'updateLevel',
        stackTrace: s,
      );
    }
  }

  Future<void> _atomicallyDeleteLevel({
    required String facultyId,
    required String courseId,
    required String levelId,
    required WriteBatch batch,
  }) async {
    final levelRef = _firestore
        .collection('faculties')
        .doc(facultyId)
        .collection('courses')
        .doc(courseId)
        .collection('levels')
        .doc(levelId);

    final courseReps = await _firestore
        .collection('faculties')
        .doc(facultyId)
        .collection('courses')
        .doc(courseId)
        .collection('levels')
        .doc(levelId)
        .collection('course_representatives')
        .get();

    for (final courseRep in courseReps.docs) {
      final courseRepRef = _firestore
          .collection('faculties')
          .doc(facultyId)
          .collection('courses')
          .doc(courseId)
          .collection('levels')
          .doc(levelId)
          .collection('course_representatives')
          .doc(courseRep.id);
      batch.delete(courseRepRef);
    }

    batch.delete(levelRef);
  }

  Future<void> _atomicallyDeleteCourse({
    required String facultyId,
    required String courseId,
    required WriteBatch batch,
  }) async {
    final courseRef = _firestore
        .collection('faculties')
        .doc(facultyId)
        .collection('courses')
        .doc(courseId);

    final levels = await _firestore
        .collection('faculties')
        .doc(facultyId)
        .collection('courses')
        .doc(courseId)
        .collection('levels')
        .get();

    for (final level in levels.docs) {
      await _atomicallyDeleteLevel(
        facultyId: facultyId,
        courseId: courseId,
        levelId: level.id,
        batch: batch,
      );
    }

    batch.delete(courseRef);
  }

  Future<void> _atomicallyDeleteFaculty({
    required String facultyId,
    required WriteBatch batch,
  }) async {
    final facultyRef = _firestore.collection('faculties').doc(facultyId);

    final courses = await _firestore
        .collection('faculties')
        .doc(facultyId)
        .collection('courses')
        .get();

    for (final course in courses.docs) {
      await _atomicallyDeleteCourse(
        facultyId: facultyId,
        courseId: course.id,
        batch: batch,
      );
    }

    batch.delete(facultyRef);
  }
}
