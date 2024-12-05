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

class FacultiesDropdown extends StatelessWidget {
  const FacultiesDropdown({
    required this.facultyNotifier,
    this.courseNotifier,
    this.levelNotifier,
    this.border = InputBorderType.underline,
    super.key,
  });

  final ValueNotifier<Faculty?> facultyNotifier;
  final ValueNotifier<Course?>? courseNotifier;
  final ValueNotifier<Level?>? levelNotifier;
  final InputBorderType border;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AcademicStructureCubit>(),
      child: FacultiesDropdownWidget(
        facultyNotifier: facultyNotifier,
        courseNotifier: courseNotifier,
        levelNotifier: levelNotifier,
        border: border,
      ),
    );
  }
}

class FacultiesDropdownWidget extends StatefulWidget {
  const FacultiesDropdownWidget({
    required this.facultyNotifier,
    required this.border,
    this.courseNotifier,
    this.levelNotifier,
    super.key,
  });

  final ValueNotifier<Faculty?> facultyNotifier;
  final ValueNotifier<Course?>? courseNotifier;
  final ValueNotifier<Level?>? levelNotifier;
  final InputBorderType border;

  @override
  State<FacultiesDropdownWidget> createState() =>
      _FacultiesDropdownWidgetState();
}

class _FacultiesDropdownWidgetState extends State<FacultiesDropdownWidget> {
  @override
  void initState() {
    super.initState();
    context.read<AcademicStructureCubit>().getFaculties();
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

            var remoteFaculties = <Faculty>[
              if (widget.facultyNotifier.value != null)
                widget.facultyNotifier.value!,
            ];

            if (state case FacultiesLoaded(:final faculties)) {
              remoteFaculties = faculties;
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LabelText('Faculty', required: true),
                const Gap(10),
                DropdownMenuFormField<Faculty>(
                  width: constraints.maxWidth,
                  hintText: 'Select Faculty',
                  initialSelection: widget.facultyNotifier.value,
                  inputDecorationTheme: InputDecorationTheme(
                    labelStyle: const TextStyle(color: Colors.black),
                    border: switch (widget.border) {
                      InputBorderType.none => InputBorder.none,
                      InputBorderType.underline => const UnderlineInputBorder(),
                      InputBorderType.outline => const OutlineInputBorder(),
                    },
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'This field is required';
                    }
                    return null;
                  },
                  onSelected: (faculty) {
                    final infoBuilder =
                        context.courseRepresentativeInformationBuilder;
                    widget.facultyNotifier.value = faculty;
                    widget.courseNotifier?.value =
                        infoBuilder.courseRepresentativeCourse;
                    widget.levelNotifier?.value =
                        infoBuilder.courseRepresentativeLevel;
                  },
                  dropdownMenuEntries: remoteFaculties
                      .map(
                        (faculty) => DropdownMenuEntry(
                          label: faculty.name,
                          value: faculty,
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
