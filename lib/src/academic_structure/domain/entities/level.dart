import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:equatable/equatable.dart';

class Level extends Equatable {
  const Level({required this.id, required this.name, required this.course});

  const Level.empty()
      : id = 'Test String',
        name = 'Test String',
        course = const Course.empty();

  final String id;
  final String name;
  final Course course;

  @override
  List<dynamic> get props => [id, name, course];
}
