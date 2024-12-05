import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/level.dart';
import 'package:flutter/foundation.dart';

class CourseRepresentativeInformationBuilder extends ChangeNotifier {
  Level? _courseRepresentativeLevel;
  Course? _courseRepresentativeCourse;
  Faculty? _courseRepresentativeFaculty;

  Level? get courseRepresentativeLevel => _courseRepresentativeLevel;

  Course? get courseRepresentativeCourse => _courseRepresentativeCourse;

  Faculty? get courseRepresentativeFaculty => _courseRepresentativeFaculty;

  void setCourseRepresentativeLevel(Level? courseRepresentativeLevel) {
    if (_courseRepresentativeLevel != courseRepresentativeLevel) {
      _courseRepresentativeLevel = courseRepresentativeLevel;
      Future.delayed(Duration.zero, notifyListeners);
    }
  }

  void setCourseRepresentativeCourse(Course? courseRepresentativeCourse) {
    if (_courseRepresentativeCourse != courseRepresentativeCourse) {
      _courseRepresentativeCourse = courseRepresentativeCourse;
      Future.delayed(Duration.zero, notifyListeners);
    }
  }

  void setCourseRepresentativeFaculty(Faculty? courseRepresentativeFaculty) {
    if (_courseRepresentativeFaculty != courseRepresentativeFaculty) {
      _courseRepresentativeFaculty = courseRepresentativeFaculty;
      Future.delayed(Duration.zero, notifyListeners);
    }
  }

  void clearCourseRepresentativeInformation() {
    _courseRepresentativeLevel = null;
    _courseRepresentativeCourse = null;
    _courseRepresentativeFaculty = null;
    Future.delayed(Duration.zero, notifyListeners);
  }
}
