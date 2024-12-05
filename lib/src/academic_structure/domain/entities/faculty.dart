import 'package:equatable/equatable.dart';

class Faculty extends Equatable {
  const Faculty({required this.id, required this.name});

  const Faculty.empty()
      : id = 'Test String',
        name = 'Test String';

  final String id;
  final String name;

  @override
  List<dynamic> get props => [id, name];
}
