import 'package:course_rep_management_panel/core/common/widgets/input_form_field.dart';
import 'package:course_rep_management_panel/core/extensions/context_extensions.dart';
import 'package:course_rep_management_panel/core/extensions/widget_extensions.dart';
import 'package:course_rep_management_panel/core/services/injection_container.dart';
import 'package:course_rep_management_panel/core/services/router.dart';
import 'package:course_rep_management_panel/core/utils/core_utils.dart';
import 'package:course_rep_management_panel/core/utils/enums/log_level.dart';
import 'package:course_rep_management_panel/core/utils/hundreds_input_formatter.dart';
import 'package:course_rep_management_panel/src/academic_structure/data/models/level_model.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/presentation/app/adapter/academic_structure_cubit.dart';
import 'package:course_rep_management_panel/src/academic_structure/presentation/widgets/courses_dropdown.dart';
import 'package:course_rep_management_panel/src/academic_structure/presentation/widgets/dial.dart';
import 'package:course_rep_management_panel/src/academic_structure/presentation/widgets/faculties_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class AddLevelView extends StatelessWidget {
  const AddLevelView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return BlocProvider(
          create: (_) => sl<AcademicStructureCubit>(),
          child: Row(
            children: [
              if (constraints.maxWidth >= 992) const Spacer(),
              const Expanded(flex: 3, child: AddLevelPage()),
            ],
          ),
        );
      },
    );
  }
}

class AddLevelPage extends StatefulWidget {
  const AddLevelPage({super.key});

  @override
  State<AddLevelPage> createState() => _AddLevelPageState();
}

class _AddLevelPageState extends State<AddLevelPage> {
  ValueNotifier<Faculty?> facultyNotifier = ValueNotifier(null);
  ValueNotifier<Course?> courseNotifier = ValueNotifier(null);
  final startController = TextEditingController();
  final endController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void submit(_) {
    if (formKey.currentState!.validate()) {
      final startLevel = int.parse(startController.text.trim());
      final endLevel = endController.text.trim().isEmpty
          ? startLevel
          : int.parse(endController.text.trim());
      if (startLevel > endLevel) {
        CoreUtils.showSnackBar(
          title: 'Error',
          message: 'Start level cannot be greater than end level',
          logLevel: LogLevel.error,
        );
        return;
      }
      if (startLevel == endLevel) {
        context.read<AcademicStructureCubit>().addLevel(
              facultyId: facultyNotifier.value!.id,
              courseId: courseNotifier.value!.id,
              level: const LevelModel.empty().copyWith(
                name: 'Level $startLevel',
                course: courseNotifier.value,
              ),
            );
      } else {
        final levelsToGenerate = (endLevel ~/ 100) - (startLevel ~/ 100) + 1;

        context.read<AcademicStructureCubit>().addLevels(
              facultyId: facultyNotifier.value!.id,
              courseId: courseNotifier.value!.id,
              levels: List.generate(
                levelsToGenerate,
                (index) => const LevelModel.empty().copyWith(
                  name: 'Level ${startLevel + index * 100}',
                  course: courseNotifier.value,
                ),
              ),
            );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    facultyNotifier = ValueNotifier(
      context
          .courseRepresentativeInformationBuilder.courseRepresentativeFaculty,
    );

    courseNotifier = ValueNotifier(
      context.courseRepresentativeInformationBuilder.courseRepresentativeCourse,
    );
  }

  @override
  void dispose() {
    startController.dispose();
    endController.dispose();
    facultyNotifier.dispose();
    courseNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AcademicStructureCubit, AcademicStructureState>(
      listener: (context, state) {
        if (state case AcademicStructureError(:final message, :final title)) {
          CoreUtils.showSnackBar(message: message, title: title);
        } else if (state is LevelAdded || state is LevelsAdded) {
          final globalCourse = context.courseRepresentativeInformationBuilder
              .courseRepresentativeCourse;
          final pluralizedLevelText = state is LevelsAdded ? 'Levels' : 'Level';
          if (globalCourse == courseNotifier.value) {
            CoreUtils.showSnackBar(
              title: 'Success',
              message: '$pluralizedLevelText added',
              logLevel: LogLevel.success,
            );
            rootNavigatorKey.currentContext!
                .read<AcademicStructureCubit>()
                .getLevels(
                  faculty: facultyNotifier.value!,
                  course: globalCourse!,
                );
          } else {
            CoreUtils.showSnackBar(
              title: 'Success',
              message: '$pluralizedLevelText added '
                  'for ${courseNotifier.value!.name}'
                  '\nPlease select the course to view the level',
              logLevel: LogLevel.success,
            );
          }
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return LayoutBuilder(
          builder: (_, constraints) {
            return FractionallySizedBox(
              widthFactor: constraints.maxWidth > 768 ? .5 : 1,
              child: Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(20).copyWith(bottom: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                'Add Level(s)',
                                style: context.theme.textTheme.titleLarge,
                              ),
                            ),
                          ),
                          IconButton.outlined(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                      const Gap(20),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FacultiesDropdown(
                                facultyNotifier: facultyNotifier,
                                courseNotifier: courseNotifier,
                              ),
                              const Gap(15),
                              CoursesDropdown(
                                facultyNotifier: facultyNotifier,
                                courseNotifier: courseNotifier,
                              ),
                              const Gap(15),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Level(s)',
                                  style: context.theme.textTheme.bodyLarge,
                                ),
                              ),
                              const Gap(8),
                              Row(
                                children: [
                                  InputFormField(
                                    width: 125,
                                    controller: startController,
                                    label: 'Start',
                                    required: true,
                                    prefixText: 'Level ',
                                    onSubmitted: submit,
                                    suffixIcon: Dial(
                                      controller: startController,
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      HundredsInputFormatter(),
                                    ],
                                  ),
                                  const Gap(20),
                                  Flexible(
                                    child: InputFormField(
                                      width: 125,
                                      controller: endController,
                                      label: 'End',
                                      prefixText: 'Level ',
                                      onSubmitted: submit,
                                      suffixIcon:
                                          Dial(controller: endController),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        HundredsInputFormatter(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(10),
                              Text(
                                'Note: The levels will be added from the '
                                'start level to the end level.\nIf you want to '
                                'add a single level, enter the same value in '
                                'both fields, or leave the end field empty.',
                                style:
                                    context.theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(50),
                      ElevatedButton(
                        onPressed: () => submit(null),
                        child: const Text('Add Level(s)'),
                      ).loading(state is AcademicStructureLoading),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
