import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/level.dart';
import 'package:equatable/equatable.dart';

class CourseRepresentative extends Equatable {
  const CourseRepresentative({
    required this.id,
    required this.name,
    required this.studentEmail,
    required this.indexNumber,
    required this.faculty,
    required this.course,
    required this.level,
  });

  const CourseRepresentative.empty()
      : id = 'Test String',
        name = 'Test String',
        studentEmail = 'Test String',
        indexNumber = 'Test String',
        faculty = const Faculty.empty(),
        course = const Course.empty(),
        level = const Level.empty();

  final String id;
  final String name;
  final String studentEmail;
  final String indexNumber;
  final Faculty faculty;
  final Course course;
  final Level level;

  @override
  List<dynamic> get props => [
        id,
        name,
        studentEmail,
        indexNumber,
        faculty,
        course,
        level,
      ];
}
