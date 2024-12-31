import 'package:course_rep_management_panel/core/common/widgets/dropdown_menu_form_field.dart';
import 'package:course_rep_management_panel/core/common/widgets/label_text.dart';
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

class LevelsDropdown extends StatelessWidget {
  const LevelsDropdown({
    required this.courseNotifier,
    required this.facultyNotifier,
    required this.levelNotifier,
    this.border = InputBorderType.underline,
    super.key,
  });

  final ValueNotifier<Course?> courseNotifier;
  final ValueNotifier<Faculty?> facultyNotifier;
  final ValueNotifier<Level?> levelNotifier;
  final InputBorderType border;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AcademicStructureCubit>(),
      child: LevelsDropdownWidget(
        courseNotifier: courseNotifier,
        facultyNotifier: facultyNotifier,
        levelNotifier: levelNotifier,
        border: border,
      ),
    );
  }
}

class LevelsDropdownWidget extends StatefulWidget {
  const LevelsDropdownWidget({
    required this.courseNotifier,
    required this.facultyNotifier,
    required this.border,
    required this.levelNotifier,
    super.key,
  });

  final ValueNotifier<Course?> courseNotifier;
  final ValueNotifier<Faculty?> facultyNotifier;
  final ValueNotifier<Level?> levelNotifier;
  final InputBorderType border;

  @override
  State<LevelsDropdownWidget> createState() => _LevelsDropdownWidgetState();
}

class _LevelsDropdownWidgetState extends State<LevelsDropdownWidget> {
  void getLevels() {
    if (widget.facultyNotifier.value != null &&
        widget.courseNotifier.value != null) {
      context.read<AcademicStructureCubit>().getLevels(
            faculty: widget.facultyNotifier.value!,
            course: widget.courseNotifier.value!,
          );
    }
  }

  @override
  void initState() {
    super.initState();
    getLevels();
    widget.courseNotifier.addListener(getLevels);
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

            var remoteLevels = <Level>[
              if (widget.levelNotifier.value != null)
                widget.levelNotifier.value!,
            ];

            if (state case LevelsLoaded(:final levels)) {
              remoteLevels = levels;
            }

            final initialSelection =
                remoteLevels.contains(widget.levelNotifier.value)
                    ? widget.levelNotifier.value
                    : remoteLevels.isEmpty
                        ? null
                        : remoteLevels.first;

            widget.levelNotifier.value = initialSelection;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LabelText('Level', required: true),
                const Gap(10),
                DropdownMenuFormField<Level>(
                  enabled: remoteLevels.isNotEmpty,
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
                            color: Colors.red.shade800.withOpacity(.5),
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
                  onSelected: (level) {
                    widget.levelNotifier.value = level;
                  },
                  dropdownMenuEntries: remoteLevels
                      .map(
                        (level) => DropdownMenuEntry(
                          label: level.name,
                          value: level,
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
