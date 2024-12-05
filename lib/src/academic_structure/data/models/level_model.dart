import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/academic_structure/data/models/course_model.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/level.dart';

class LevelModel extends Level {
  const LevelModel({
    required super.id,
    required super.name,
    required super.course,
  });

  const LevelModel.empty()
      : this(
          id: 'Test String',
          name: 'Test String',
          course: const CourseModel.empty(),
        );

  LevelModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          name: map['name'] as String,
          course: map['course'] as Course,
        );

  LevelModel copyWith({
    String? id,
    String? name,
    Course? course,
  }) {
    return LevelModel(
      id: id ?? this.id,
      name: name ?? this.name,
      course: course ?? this.course,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{'id': id, 'name': name, 'courseId': course.id};
  }
}
