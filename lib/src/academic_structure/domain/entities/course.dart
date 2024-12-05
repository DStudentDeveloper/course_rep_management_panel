import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';
import 'package:equatable/equatable.dart';

class Course extends Equatable {
  const Course({required this.id, required this.name, required this.faculty});

  const Course.empty()
      : id = 'Test String',
        name = 'Test String',
        faculty = const Faculty.empty();

  final String id;
  final String name;
  final Faculty faculty;

  @override
  List<dynamic> get props => [id, name, faculty];
}
