import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/academic_structure/data/models/course_model.dart';
import 'package:course_rep_management_panel/src/academic_structure/data/models/faculty_model.dart';
import 'package:course_rep_management_panel/src/academic_structure/data/models/level_model.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/level.dart';
import 'package:course_rep_management_panel/src/course_representative/domain/entities/course_representative.dart';

class CourseRepresentativeModel extends CourseRepresentative {
  const CourseRepresentativeModel({
    required super.id,
    required super.name,
    required super.studentEmail,
    required super.indexNumber,
    required super.faculty,
    required super.course,
    required super.level,
  });

  const CourseRepresentativeModel.empty()
      : this(
          id: 'Test String',
          name: 'Test String',
          studentEmail: 'Test String',
          indexNumber: 'Test String',
          faculty: const FacultyModel.empty(),
          course: const CourseModel.empty(),
          level: const LevelModel.empty(),
        );

  CourseRepresentativeModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          name: map['name'] as String,
          studentEmail: map['studentEmail'] as String,
          indexNumber: map['indexNumber'] as String,
          faculty: map['faculty'] as Faculty,
          course: map['course'] as Course,
          level: map['level'] as Level,
        );

  CourseRepresentativeModel copyWith({
    String? id,
    String? name,
    String? studentEmail,
    String? indexNumber,
    Faculty? faculty,
    Course? course,
    Level? level,
  }) {
    return CourseRepresentativeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      studentEmail: studentEmail ?? this.studentEmail,
      indexNumber: indexNumber ?? this.indexNumber,
      faculty: faculty ?? this.faculty,
      course: course ?? this.course,
      level: level ?? this.level,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'studentEmail': studentEmail,
      'indexNumber': indexNumber,
      'facultyId': faculty.id,
      'courseId': course.id,
      'levelId': level.id,
    };
  }
}
