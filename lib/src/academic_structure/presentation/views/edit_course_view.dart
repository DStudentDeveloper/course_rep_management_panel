import 'package:course_rep_management_panel/core/common/widgets/input_form_field.dart';
import 'package:course_rep_management_panel/core/extensions/context_extensions.dart';
import 'package:course_rep_management_panel/core/extensions/widget_extensions.dart';
import 'package:course_rep_management_panel/core/services/injection_container.dart';
import 'package:course_rep_management_panel/core/services/router.dart';
import 'package:course_rep_management_panel/core/utils/core_utils.dart';
import 'package:course_rep_management_panel/core/utils/enums/log_level.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:course_rep_management_panel/src/academic_structure/presentation/app/adapter/academic_structure_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class EditCourseView extends StatelessWidget {
  const EditCourseView(this.course, {super.key});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AcademicStructureCubit>(),
      child: Row(
        children: [
          const Spacer(),
          Expanded(flex: 3, child: EditCoursePage(course)),
        ],
      ),
    );
  }
}

class EditCoursePage extends StatefulWidget {
  const EditCoursePage(this.course, {super.key});

  final Course course;

  @override
  State<EditCoursePage> createState() => _EditCoursePageState();
}

class _EditCoursePageState extends State<EditCoursePage> {
  late TextEditingController controller;
  final formKey = GlobalKey<FormState>();

  final changeNotifier = ValueNotifier(false);

  void submit(_) {
    if (formKey.currentState!.validate()) {
      context.read<AcademicStructureCubit>().updateCourse(
        facultyId: widget.course.faculty.id,
        courseId: widget.course.id,
        updateData: {'name': controller.text.trim()},
      );
    }
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.course.name)
      ..addListener(() {
        changeNotifier.value = controller.text.trim() != widget.course.name;
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AcademicStructureCubit, AcademicStructureState>(
      listener: (context, state) {
        if (state case AcademicStructureError(:final message, :final title)) {
          CoreUtils.showSnackBar(message: message, title: title);
        } else if (state is CourseUpdated) {
          CoreUtils.showSnackBar(
            title: 'Success',
            message: 'Course updated',
            logLevel: LogLevel.success,
          );
          rootNavigatorKey.currentContext!
              .read<AcademicStructureCubit>()
              .getCourses(widget.course.faculty);

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
                                'Edit Course',
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
                            children: [
                              InputFormField(
                                controller: TextEditingController(
                                  text: widget.course.faculty.name,
                                ),
                                label: 'Faculty Name',
                                readOnly: true,
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
                      ValueListenableBuilder(
                        valueListenable: changeNotifier,
                        builder: (_, changeDetected, child) {
                          if (changeDetected) return child!;
                          return const SizedBox.shrink();
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Gap(50),
                            ElevatedButton(
                              onPressed: () => submit(null),
                              child: const Text('Update Course'),
                            ).loading(state is AcademicStructureLoading),
                          ],
                        ),
                      ),
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
