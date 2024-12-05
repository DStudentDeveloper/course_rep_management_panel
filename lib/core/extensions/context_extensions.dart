import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/level.dart';
import 'package:course_rep_management_panel/src/dashboard/presentation/app/course_represenatative_information_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Extension on `BuildContext` to provide additional utility methods.
extension ContextExtensions on BuildContext {
  /// Gets the current `ThemeData` from the context.
  ThemeData get theme => Theme.of(this);

  /// Gets the current `MediaQueryData` from the context.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Gets the current `Size` of the media query from the context.
  Size get size => MediaQuery.sizeOf(this);

  /// Gets the width of the current `Size`.
  double get width => size.width;

  /// Gets the height of the current `Size`.
  double get height => size.height;

  /// Navigates to a specified location.
  ///
  /// Uses `go` when the app is running on web or WASM, otherwise uses `push`.
  ///
  /// - Parameters:
  ///   - location: The location to navigate to.
  ///   - extra: Optional extra data to pass along with the navigation.
  ///
  /// - Returns: A `Future` that completes with the result of the navigation,
  /// or `null` if using `go`.
  Future<T?> navigateTo<T extends Object?>(
    String location, {
    Object? extra,
  }) async {
    if (kIsWeb || kIsWasm) {
      go(location, extra: extra);
      return null;
    } else {
      return push<T>(location, extra: extra);
    }
  }

  /// Gets the `CourseRepresentativeInformationBuilder` from the context.
  CourseRepresentativeInformationBuilder
      get courseRepresentativeInformationBuilder {
    return read<CourseRepresentativeInformationBuilder>();
  }

  void changeFaculty(Faculty? faculty) {
    courseRepresentativeInformationBuilder
        .setCourseRepresentativeFaculty(faculty);
  }

  void changeCourse(Course? course) {
    courseRepresentativeInformationBuilder
        .setCourseRepresentativeCourse(course);
  }

  void changeLevel(Level? level) {
    courseRepresentativeInformationBuilder.setCourseRepresentativeLevel(level);
  }

  void clearCourseRepresentativeInformation() {
    courseRepresentativeInformationBuilder
        .clearCourseRepresentativeInformation();
  }
}
