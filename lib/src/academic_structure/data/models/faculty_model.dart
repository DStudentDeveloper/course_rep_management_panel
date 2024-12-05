import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';

class FacultyModel extends Faculty {
  const FacultyModel({
    required super.id,
    required super.name,
  });

  const FacultyModel.empty() : this(id: 'Test String', name: 'Test String');

  FacultyModel.fromMap(DataMap map)
      : this(id: map['id'] as String, name: map['name'] as String);

  FacultyModel copyWith({String? id, String? name}) {
    return FacultyModel(id: id ?? this.id, name: name ?? this.name);
  }

  DataMap toMap() {
    return <String, dynamic>{'id': id, 'name': name};
  }
}
