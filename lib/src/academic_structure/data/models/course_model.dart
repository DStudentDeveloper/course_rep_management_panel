import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/academic_structure/data/models/faculty_model.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';

class CourseModel extends Course {
  const CourseModel({
    required super.id,
    required super.name,
    required super.faculty,
  });

  const CourseModel.empty()
      : this(
          id: 'Test String',
          name: 'Test String',
          faculty: const FacultyModel.empty(),
        );

  CourseModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          name: map['name'] as String,
          faculty: map['faculty'] as Faculty,
        );

  CourseModel copyWith({
    String? id,
    String? name,
    Faculty? faculty,
  }) {
    return CourseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      faculty: faculty ?? this.faculty,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{'id': id, 'name': name, 'facultyId': faculty.id};
  }
}
