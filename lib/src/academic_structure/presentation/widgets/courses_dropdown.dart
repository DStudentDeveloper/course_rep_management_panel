import 'package:course_rep_management_panel/core/common/widgets/dropdown_menu_form_field.dart';
import 'package:course_rep_management_panel/core/common/widgets/label_text.dart';
import 'package:course_rep_management_panel/core/extensions/context_extensions.dart';
import 'package:course_rep_management_panel/core/services/injection_container.dart';
import 'package:course_rep_management_panel/core/utils/core_utils.dart';
import 'package:course_rep_management_panel/core/utils/enums/input_border.dart';
import 'package:course_rep_management_panel/core/utils/enums/log_level.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/level.dart';
import 'package:course_rep_management_panel/src/academic_structure/presentation/app/adapter/academic_structure_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class CoursesDropdown extends StatelessWidget {
  const CoursesDropdown({
    required this.courseNotifier,
    required this.facultyNotifier,
    this.levelNotifier,
    this.border = InputBorderType.underline,
    super.key,
  });

  final ValueNotifier<Course?> courseNotifier;
  final ValueNotifier<Faculty?> facultyNotifier;
  final ValueNotifier<Level?>? levelNotifier;
  final InputBorderType border;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AcademicStructureCubit>(),
      child: CoursesDropdownWidget(
        courseNotifier: courseNotifier,
        facultyNotifier: facultyNotifier,
        levelNotifier: levelNotifier,
        border: border,
      ),
    );
  }
}

class CoursesDropdownWidget extends StatefulWidget {
  const CoursesDropdownWidget({
    required this.courseNotifier,
    required this.facultyNotifier,
    required this.border,
    this.levelNotifier,
    super.key,
  });

  final ValueNotifier<Course?> courseNotifier;
  final ValueNotifier<Faculty?> facultyNotifier;
  final ValueNotifier<Level?>? levelNotifier;
  final InputBorderType border;

  @override
  State<CoursesDropdownWidget> createState() => _CoursesDropdownWidgetState();
}

class _CoursesDropdownWidgetState extends State<CoursesDropdownWidget> {
  void getCourses() {
    if (widget.facultyNotifier.value != null) {
      context
          .read<AcademicStructureCubit>()
          .getCourses(widget.facultyNotifier.value!);
    }
  }

  @override
  void initState() {
    super.initState();
    getCourses();
    widget.facultyNotifier.addListener(getCourses);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return BlocConsumer<AcademicStructureCubit, AcademicStructureState>(
          listener: (_, state) {
            if (state
                case AcademicStructureError(
                  :final title,
                  :final message,
                )) {
              CoreUtils.showSnackBar(
                message: message,
                title: title,
                logLevel: LogLevel.error,
              );
            }
          },
          builder: (context, state) {
            if (state is AcademicStructureLoading) {
              return const LinearProgressIndicator();
            }

            var remoteCourses = <Course>[
              if (widget.courseNotifier.value != null)
                widget.courseNotifier.value!,
            ];

            if (state case CoursesLoaded(:final courses)) {
              remoteCourses = courses;
            }
            final initialSelection =
                remoteCourses.contains(widget.courseNotifier.value)
                    ? widget.courseNotifier.value
                    : remoteCourses.isEmpty
                        ? null
                        : remoteCourses.first;

            widget.courseNotifier.value = initialSelection;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LabelText('Course', required: true),
                const Gap(10),
                DropdownMenuFormField<Course>(
                  enabled: remoteCourses.isNotEmpty,
                  width: constraints.maxWidth,
                  initialSelection: initialSelection,
                  validator: (value) {
                    if (value == null) {
                      return 'This field is required';
                    }
                    return null;
                  },

                  inputDecorationTheme: InputDecorationTheme(
                    labelStyle: const TextStyle(color: Colors.black),
                    errorBorder: switch (widget.border) {
                      InputBorderType.none => InputBorder.none,
                      InputBorderType.underline => UnderlineInputBorder(
                        borderSide: BorderSide(
                          color:  Colors.red.shade800.withOpacity(.5),
                        ),
                      ),
                      InputBorderType.outline => OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red.shade800.withOpacity(.5),
                        ),
                      ),
                    },
                    disabledBorder: switch (widget.border) {
                      InputBorderType.none => InputBorder.none,
                      InputBorderType.underline => UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade800.withOpacity(.5),
                        ),
                      ),
                      InputBorderType.outline => OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade800.withOpacity(.5),
                        ),
                      ),
                    },
                    border: switch (widget.border) {
                      InputBorderType.none => InputBorder.none,
                      InputBorderType.underline => const UnderlineInputBorder(),
                      InputBorderType.outline => const OutlineInputBorder(),
                    },
                  ),
                  onSelected: (course) {
                    widget.courseNotifier.value = course;
                    widget.levelNotifier?.value = context
                        .courseRepresentativeInformationBuilder
                        .courseRepresentativeLevel;
                  },
                  dropdownMenuEntries: remoteCourses
                      .map(
                        (course) => DropdownMenuEntry(
                          label: course.name,
                          value: course,
                        ),
                      )
                      .toList(),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
