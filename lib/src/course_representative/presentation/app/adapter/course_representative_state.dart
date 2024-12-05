part of 'course_representative_cubit.dart';

sealed class CourseRepresentativeState extends Equatable {
  const CourseRepresentativeState();

  @override
  List<Object> get props => [];
}

final class CourseRepresentativeInitial extends CourseRepresentativeState {
  const CourseRepresentativeInitial();
}

final class CourseRepresentativeLoading extends CourseRepresentativeState {
  const CourseRepresentativeLoading();
}

final class CourseRepresentativesLoaded extends CourseRepresentativeState {
  const CourseRepresentativesLoaded(this.courseRepresentatives);

  final List<CourseRepresentative> courseRepresentatives;

  @override
  List<Object> get props => courseRepresentatives;
}

final class CourseRepresentativeUpdated extends CourseRepresentativeState {
  const CourseRepresentativeUpdated();
}

final class CourseRepresentativeDeleted extends CourseRepresentativeState {
  const CourseRepresentativeDeleted();
}

final class CourseRepresentativeAdded extends CourseRepresentativeState {
  const CourseRepresentativeAdded();
}

final class CourseRepresentativeError extends CourseRepresentativeState {
  const CourseRepresentativeError({required this.title, required this.message});

  final String title;
  final String message;

  @override
  List<Object> get props => [title, message];
}
