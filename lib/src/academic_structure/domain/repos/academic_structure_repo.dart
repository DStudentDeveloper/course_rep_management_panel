import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/level.dart';

abstract class AcademicStructureRepo {
  ResultFuture<List<Faculty>> getFaculties();

  ResultFuture<void> addFaculty(Faculty faculty);

  ResultFuture<void> updateFaculty({
    required String facultyId,
    required DataMap updateData,
  });

  ResultFuture<void> deleteFaculty(String facultyId);

  ResultFuture<void> addCourse({
    required String facultyId,
    required Course course,
  });

  ResultFuture<List<Course>> getCourses(Faculty faculty);

  ResultFuture<void> updateCourse({
    required String facultyId,
    required String courseId,
    required DataMap updateData,
  });

  ResultFuture<void> deleteCourse({
    required String facultyId,
    required String courseId,
  });

  ResultFuture<List<Level>> getLevels({
    required Faculty faculty,
    required Course course,
  });

  ResultFuture<void> addLevel({
    required String facultyId,
    required String courseId,
    required Level level,
  });

  ResultFuture<void> updateLevel({
    required String facultyId,
    required String courseId,
    required String levelId,
    required DataMap updateData,
  });

  ResultFuture<void> deleteLevel({
    required String facultyId,
    required String courseId,
    required String levelId,
  });
}
