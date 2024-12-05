import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/level.dart';
import 'package:course_rep_management_panel/src/course_representative/domain/entities/course_representative.dart';

abstract class CourseRepresentativeRepo {
  ResultFuture<List<CourseRepresentative>> getCourseRepresentatives({
    required Faculty faculty,
    required Course course,
    required Level level,
  });

  ResultFuture<void> addCourseRepresentative({
    required String facultyId,
    required String courseId,
    required String levelId,
    required CourseRepresentative courseRepresentative,
  });

  ResultFuture<void> updateCourseRepresentative({
    required String facultyId,
    required String courseId,
    required String levelId,
    required String courseRepresentativeId,
    required DataMap updateData,
  });

  ResultFuture<void> deleteCourseRepresentative({
    required String facultyId,
    required String courseId,
    required String levelId,
    required String courseRepresentativeId,
  });
}
