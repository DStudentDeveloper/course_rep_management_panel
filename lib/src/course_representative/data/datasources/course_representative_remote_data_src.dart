import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:course_rep_management_panel/core/errors/exceptions.dart';
import 'package:course_rep_management_panel/core/utils/network_utils.dart';
import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/level.dart';
import 'package:course_rep_management_panel/src/course_representative/data/models/course_representative_model.dart';
import 'package:course_rep_management_panel/src/course_representative/domain/entities/course_representative.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class CourseRepresentativeRemoteDataSrc {
  Future<List<CourseRepresentativeModel>> getCourseRepresentatives({
    required Faculty faculty,
    required Course course,
    required Level level,
  });

  Future<void> addCourseRepresentative({
    required String facultyId,
    required String courseId,
    required String levelId,
    required CourseRepresentative courseRepresentative,
  });

  Future<void> updateCourseRepresentative({
    required String facultyId,
    required String courseId,
    required String levelId,
    required String courseRepresentativeId,
    required DataMap updateData,
  });

  Future<void> deleteCourseRepresentative({
    required String facultyId,
    required String courseId,
    required String levelId,
    required String courseRepresentativeId,
  });
}

class CourseRepresentativeRemoteDataSrcImpl
    implements CourseRepresentativeRemoteDataSrc {
  const CourseRepresentativeRemoteDataSrcImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required FirebaseFunctions functions,
  })  : _firestore = firestore,
        _auth = auth,
        _functions = functions;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseFunctions _functions;

  @override
  Future<List<CourseRepresentativeModel>> getCourseRepresentatives({
    required Faculty faculty,
    required Course course,
    required Level level,
  }) async {
    try {
      await NetworkUtils.authorizeUser(_auth);

      final courseRepresentatives = await _firestore
          .collection('faculties')
          .doc(faculty.id)
          .collection('courses')
          .doc(course.id)
          .collection('levels')
          .doc(level.id)
          .collection('course_representatives')
          .get();

      return courseRepresentatives.docs.map((doc) {
        final map = doc.data();
        map['course'] = course;
        map['faculty'] = faculty;
        map['level'] = level;
        return CourseRepresentativeModel.fromMap(map);
      }).toList();
    } on FirebaseException catch (e) {
      return NetworkUtils.handleRemoteSourceException<
          List<CourseRepresentativeModel>>(
        e,
        repositoryName: 'CourseRepresentativeRemoteDataSrcImpl',
        methodName: 'getCourseRepresentatives',
        stackTrace: e.stackTrace,
        statusCode: e.code,
        errorMessage: e.message,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      return NetworkUtils.handleRemoteSourceException<
          List<CourseRepresentativeModel>>(
        e,
        repositoryName: 'CourseRepresentativeRemoteDataSrcImpl',
        methodName: 'getCourseRepresentatives',
        stackTrace: s,
      );
    }
  }

  @override
  Future<void> addCourseRepresentative({
    required String facultyId,
    required String courseId,
    required String levelId,
    required CourseRepresentative courseRepresentative,
  }) async {
    try {
      await NetworkUtils.authorizeUser(_auth);

      final response = await _functions
          .httpsCallable('authenticateCourseRepresentative')<DataMap>({
        'email': courseRepresentative.studentEmail,
        'displayName': courseRepresentative.name,
      });

      final uid = response.data['uid'] as String;
      final courseRepresentativeDoc = _firestore
          .collection('faculties')
          .doc(facultyId)
          .collection('courses')
          .doc(courseId)
          .collection('levels')
          .doc(levelId)
          .collection('course_representatives')
          .doc(uid);

      final courseRepresentativeConsumerDoc =
          _firestore.collection('course_representatives').doc(uid);

      final batch = _firestore.batch();
      final courseRepresentativeToUpload =
          (courseRepresentative as CourseRepresentativeModel)
              .copyWith(id: courseRepresentativeDoc.id);

      final consumerData = courseRepresentativeToUpload.toMap();
      consumerData['facultyName'] = courseRepresentative.faculty.name;
      consumerData['courseName'] = courseRepresentative.course.name;
      consumerData['levelName'] = courseRepresentative.level.name;

      batch
        ..set(courseRepresentativeDoc, courseRepresentativeToUpload.toMap())
        ..set(
          courseRepresentativeConsumerDoc,
          consumerData,
        );
      await batch.commit();
    } on FirebaseException catch (e) {
      return NetworkUtils.handleRemoteSourceException<void>(
        e,
        repositoryName: 'CourseRepresentativeRemoteDataSrcImpl',
        methodName: 'addCourseRepresentative',
        stackTrace: e.stackTrace,
        statusCode: e.code,
        errorMessage: e.message,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      return NetworkUtils.handleRemoteSourceException<void>(
        e,
        repositoryName: 'CourseRepresentativeRemoteDataSrcImpl',
        methodName: 'addCourseRepresentative',
        stackTrace: s,
      );
    }
  }

  @override
  Future<void> updateCourseRepresentative({
    required String facultyId,
    required String courseId,
    required String levelId,
    required String courseRepresentativeId,
    required DataMap updateData,
  }) async {
    try {
      await NetworkUtils.authorizeUser(_auth);

      final updateToBeUploaded = <String, dynamic>{};
      if (updateData case {'name': final String name}) {
        updateToBeUploaded['name'] = name;
      }
      if (updateData case {'studentEmail': final String studentEmail}) {
        updateToBeUploaded['studentEmail'] = studentEmail;
      }
      if (updateData case {'indexNumber': final String indexNumber}) {
        updateToBeUploaded['indexNumber'] = indexNumber;
      }

      if (updateToBeUploaded.isNotEmpty) {
        await _functions
            .httpsCallable('updateCourseRepresentativeAuth')<DataMap>({
          'uid': courseRepresentativeId,
          if (updateToBeUploaded case {'name': final name}) 'displayName': name,
          if (updateToBeUploaded case {'studentEmail': final email})
            'email': email,
        });
        final batch = _firestore.batch();

        final courseRepresentativeDoc = _firestore
            .collection('faculties')
            .doc(facultyId)
            .collection('courses')
            .doc(courseId)
            .collection('levels')
            .doc(levelId)
            .collection('course_representatives')
            .doc(courseRepresentativeId);

        final courseRepresentativeConsumerDoc = _firestore
            .collection('course_representatives')
            .doc(courseRepresentativeId);

        batch
          ..update(courseRepresentativeDoc, updateToBeUploaded)
          ..update(courseRepresentativeConsumerDoc, updateToBeUploaded);
        await batch.commit();
      }
    } on FirebaseException catch (e) {
      return NetworkUtils.handleRemoteSourceException<void>(
        e,
        repositoryName: 'CourseRepresentativeRemoteDataSrcImpl',
        methodName: 'updateCourseRepresentative',
        stackTrace: e.stackTrace,
        statusCode: e.code,
        errorMessage: e.message,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      return NetworkUtils.handleRemoteSourceException<void>(
        e,
        repositoryName: 'CourseRepresentativeRemoteDataSrcImpl',
        methodName: 'updateCourseRepresentative',
        stackTrace: s,
      );
    }
  }

  @override
  Future<void> deleteCourseRepresentative({
    required String facultyId,
    required String courseId,
    required String levelId,
    required String courseRepresentativeId,
  }) async {
    try {
      await NetworkUtils.authorizeUser(_auth);

      await _functions
          .httpsCallable('deleteCourseRepresentativeAuth')<DataMap>({
        'uid': courseRepresentativeId,
      });

      final batch = _firestore.batch();
      final courseRepresentativeDoc = _firestore
          .collection('faculties')
          .doc(facultyId)
          .collection('courses')
          .doc(courseId)
          .collection('levels')
          .doc(levelId)
          .collection('course_representatives')
          .doc(courseRepresentativeId);

      final courseRepresentativeConsumerDoc = _firestore
          .collection('course_representatives')
          .doc(courseRepresentativeId);

      batch
        ..delete(courseRepresentativeDoc)
        ..delete(courseRepresentativeConsumerDoc);
      await batch.commit();
    } on FirebaseException catch (e) {
      return NetworkUtils.handleRemoteSourceException<void>(
        e,
        repositoryName: 'CourseRepresentativeRemoteDataSrcImpl',
        methodName: 'deleteCourseRepresentative',
        stackTrace: e.stackTrace,
        statusCode: e.code,
        errorMessage: e.message,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      return NetworkUtils.handleRemoteSourceException<void>(
        e,
        repositoryName: 'CourseRepresentativeRemoteDataSrcImpl',
        methodName: 'deleteCourseRepresentative',
        stackTrace: s,
      );
    }
  }
}
