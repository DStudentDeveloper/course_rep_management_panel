import 'package:course_rep_management_panel/core/common/widgets/input_form_field.dart';
import 'package:course_rep_management_panel/core/common/widgets/label_text.dart';
import 'package:course_rep_management_panel/core/common/widgets/responsive_container.dart';
import 'package:course_rep_management_panel/core/extensions/widget_extensions.dart';
import 'package:course_rep_management_panel/core/services/injection_container.dart';
import 'package:course_rep_management_panel/core/services/router.dart';
import 'package:course_rep_management_panel/core/utils/core_utils.dart';
import 'package:course_rep_management_panel/core/utils/enums/input_border.dart';
import 'package:course_rep_management_panel/core/utils/enums/log_level.dart';
import 'package:course_rep_management_panel/core/utils/upper_case_input_formatter.dart';
import 'package:course_rep_management_panel/src/course_representative/domain/entities/course_representative.dart';
import 'package:course_rep_management_panel/src/course_representative/presentation/app/adapter/course_representative_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class EditCourseRepresentativeScreen extends StatelessWidget {
  const EditCourseRepresentativeScreen(this.representative, {super.key});

  final CourseRepresentative representative;

  static const path = '/faculties/:facultyId/courses/:courseId/levels/:levelId'
      '/representatives/:representativeId/edit';

  static const name = 'EditCourseRepresentativeScreen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CourseRepresentativeCubit>(),
      child: EditCourseRepresentativeView(representative),
    );
  }
}

class EditCourseRepresentativeView extends StatefulWidget {
  const EditCourseRepresentativeView(this.representative, {super.key});

  final CourseRepresentative representative;

  @override
  State<EditCourseRepresentativeView> createState() =>
      _EditCourseRepresentativeViewState();
}

class _EditCourseRepresentativeViewState
    extends State<EditCourseRepresentativeView> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController indexNumberController;

  final formKey = GlobalKey<FormState>();

  final changeNotifier = ValueNotifier(false);

  bool nameChanged() =>
      nameController.text.trim() != widget.representative.name;

  bool emailChanged() =>
      emailController.text.trim() != widget.representative.studentEmail;

  bool idChanged() =>
      indexNumberController.text.trim() != widget.representative.indexNumber;

  void submit(_) {
    if (formKey.currentState!.validate()) {
      context.read<CourseRepresentativeCubit>().updateCourseRepresentative(
        facultyId: widget.representative.faculty.id,
        courseId: widget.representative.course.id,
        levelId: widget.representative.level.id,
        courseRepresentativeId: widget.representative.id,
        updateData: {
          if (nameChanged()) 'name': nameController.text.trim(),
          if (emailChanged()) 'studentEmail': emailController.text.trim(),
          if (idChanged()) 'indexNumber': indexNumberController.text.trim(),
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.representative.name)
      ..addListener(() => changeNotifier.value = nameChanged());
    emailController = TextEditingController(
      text: widget.representative.studentEmail,
    )..addListener(() => changeNotifier.value = emailChanged());
    indexNumberController = TextEditingController(
      text: widget.representative.indexNumber,
    )..addListener(() => changeNotifier.value = idChanged());
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    indexNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Course Representative'),
        centerTitle: true,
      ),
      body: BlocConsumer<CourseRepresentativeCubit, CourseRepresentativeState>(
        listener: (context, state) {
          if (state
              case CourseRepresentativeError(:final message, :final title)) {
            CoreUtils.showSnackBar(message: message, title: title);
          } else if (state is CourseRepresentativeUpdated) {
            CoreUtils.showSnackBar(
              title: 'Success',
              message: 'Course Representative Updated',
              logLevel: LogLevel.success,
            );
            rootNavigatorKey.currentContext!
                .read<CourseRepresentativeCubit>()
                .getCourseRepresentatives(
                  faculty: widget.representative.faculty,
                  course: widget.representative.course,
                  level: widget.representative.level,
                );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ).copyWith(bottom: 20),
              child: Column(
                children: [
                  Expanded(
                    child: Form(
                      key: formKey,
                      child: ResponsiveContainer.md(
                        child: ListView(
                          children: [
                            const LabelText('Faculty'),
                            const Gap(10),
                            InputFormField(
                              controller: TextEditingController(
                                text: widget.representative.faculty.name,
                              ),
                              readOnly: true,
                              border: InputBorderType.outline,
                            ),
                            const Gap(20),
                            const LabelText('Course'),
                            const Gap(10),
                            InputFormField(
                              controller: TextEditingController(
                                text: widget.representative.course.name,
                              ),
                              readOnly: true,
                              border: InputBorderType.outline,
                            ),
                            const Gap(20),
                            const LabelText('Level'),
                            const Gap(10),
                            InputFormField(
                              controller: TextEditingController(
                                text: widget.representative.level.name,
                              ),
                              readOnly: true,
                              border: InputBorderType.outline,
                            ),
                            const Gap(20),
                            const LabelText('Student Name', required: true),
                            const Gap(10),
                            InputFormField(
                              controller: nameController,
                              hintText: "Enter Representative's Name",
                              required: true,
                              onSubmitted: submit,
                              border: InputBorderType.outline,
                            ),
                            const Gap(20),
                            const LabelText('Student ID', required: true),
                            const Gap(10),
                            InputFormField(
                              controller: indexNumberController,
                              hintText: "Enter Representative's Student ID",
                              required: true,
                              onSubmitted: submit,
                              border: InputBorderType.outline,
                              inputFormatters: [UpperCaseInputFormatter()],
                            ),
                            const Gap(20),
                            const LabelText('Student Email', required: true),
                            const Gap(10),
                            InputFormField(
                              controller: emailController,
                              hintText: "Enter Representative's Student Email",
                              required: true,
                              onSubmitted: submit,
                              border: InputBorderType.outline,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: changeNotifier,
                    builder: (_, changeDetected, child) {
                      if (changeDetected) return child!;
                      return const SizedBox.shrink();
                    },
                    child: ElevatedButton(
                      onPressed: () => submit(null),
                      child: const Text('Update Representative'),
                    ),
                  ),
                ],
              ).loading(state is CourseRepresentativeLoading),
            ),
          );
        },
      ),
    );
  }
}
