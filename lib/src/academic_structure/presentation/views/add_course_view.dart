import 'package:course_rep_management_panel/core/common/widgets/input_form_field.dart';
import 'package:course_rep_management_panel/core/extensions/context_extensions.dart';
import 'package:course_rep_management_panel/core/extensions/widget_extensions.dart';
import 'package:course_rep_management_panel/core/services/injection_container.dart';
import 'package:course_rep_management_panel/core/services/router.dart';
import 'package:course_rep_management_panel/core/utils/core_utils.dart';
import 'package:course_rep_management_panel/core/utils/enums/log_level.dart';
import 'package:course_rep_management_panel/src/academic_structure/data/models/course_model.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/presentation/app/adapter/academic_structure_cubit.dart';
import 'package:course_rep_management_panel/src/academic_structure/presentation/widgets/faculties_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class AddCourseView extends StatelessWidget {
  const AddCourseView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return BlocProvider(
          create: (_) => sl<AcademicStructureCubit>(),
          child: Row(
            children: [
              if (constraints.maxWidth >= 992) const Spacer(),
              const Expanded(flex: 3, child: AddCoursePage()),
            ],
          ),
        );
      },
    );
  }
}

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({super.key});

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  ValueNotifier<Faculty?> facultyNotifier = ValueNotifier(null);
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void submit(_) {
    if (formKey.currentState!.validate()) {
      context.read<AcademicStructureCubit>().addCourse(
            facultyId: facultyNotifier.value!.id,
            course: const CourseModel.empty().copyWith(
              name: controller.text.trim(),
              faculty: facultyNotifier.value,
            ),
          );
    }
  }

  @override
  void initState() {
    super.initState();
    facultyNotifier = ValueNotifier(
      context
          .courseRepresentativeInformationBuilder.courseRepresentativeFaculty,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    facultyNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AcademicStructureCubit, AcademicStructureState>(
      listener: (context, state) {
        if (state case AcademicStructureError(:final message, :final title)) {
          CoreUtils.showSnackBar(message: message, title: title);
        } else if (state is CourseAdded) {
          final globalFaculty = context.courseRepresentativeInformationBuilder
              .courseRepresentativeFaculty;
          if (globalFaculty == facultyNotifier.value) {
            CoreUtils.showSnackBar(
              title: 'Success',
              message: 'Course added',
              logLevel: LogLevel.success,
            );
            rootNavigatorKey.currentContext!
                .read<AcademicStructureCubit>()
                .getCourses(globalFaculty!);
          } else {
            CoreUtils.showSnackBar(
              title: 'Success',
              message: 'Course added for ${facultyNotifier.value!.name}'
                  '\nPlease select the faculty to view the course',
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
                                'Add Course',
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
                              ),
                              const Gap(15),
                              InputFormField(
                                controller: controller,
                                label: 'Course Name',
                                required: true,
                                onSubmitted: submit,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(50),
                      ElevatedButton(
                        onPressed: () => submit(null),
                        child: const Text('Add Course'),
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
