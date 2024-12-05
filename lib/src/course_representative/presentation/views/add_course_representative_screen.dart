import 'package:course_rep_management_panel/core/common/widgets/input_form_field.dart';
import 'package:course_rep_management_panel/core/common/widgets/label_text.dart';
import 'package:course_rep_management_panel/core/common/widgets/responsive_container.dart';
import 'package:course_rep_management_panel/core/extensions/context_extensions.dart';
import 'package:course_rep_management_panel/core/extensions/widget_extensions.dart';
import 'package:course_rep_management_panel/core/services/injection_container.dart';
import 'package:course_rep_management_panel/core/services/router.dart';
import 'package:course_rep_management_panel/core/utils/core_utils.dart';
import 'package:course_rep_management_panel/core/utils/enums/input_border.dart';
import 'package:course_rep_management_panel/core/utils/enums/log_level.dart';
import 'package:course_rep_management_panel/core/utils/upper_case_input_formatter.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/level.dart';
import 'package:course_rep_management_panel/src/academic_structure/presentation/widgets/courses_dropdown.dart';
import 'package:course_rep_management_panel/src/academic_structure/presentation/widgets/faculties_dropdown.dart';
import 'package:course_rep_management_panel/src/academic_structure/presentation/widgets/levels_dropdown.dart';
import 'package:course_rep_management_panel/src/course_representative/data/models/course_representative_model.dart';
import 'package:course_rep_management_panel/src/course_representative/presentation/app/adapter/course_representative_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class AddCourseRepresentativeScreen extends StatelessWidget {
  const AddCourseRepresentativeScreen({
    required this.refreshAfterAdd,
    super.key,
  });

  static const path = '/add-course-representative';

  final bool refreshAfterAdd;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CourseRepresentativeCubit>(),
      child: AddCourseRepresentativeView(refreshAfterAdd: refreshAfterAdd),
    );
  }
}

class AddCourseRepresentativeView extends StatefulWidget {
  const AddCourseRepresentativeView({required this.refreshAfterAdd, super.key});

  final bool refreshAfterAdd;

  @override
  State<AddCourseRepresentativeView> createState() =>
      _AddCourseRepresentativeViewState();
}

class _AddCourseRepresentativeViewState
    extends State<AddCourseRepresentativeView> {
  ValueNotifier<Faculty?> facultyNotifier = ValueNotifier(null);
  ValueNotifier<Course?> courseNotifier = ValueNotifier(null);
  ValueNotifier<Level?> levelNotifier = ValueNotifier(null);

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final idController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  void submit(_) {
    if (formKey.currentState!.validate()) {
      context.read<CourseRepresentativeCubit>().addCourseRepresentative(
            facultyId: facultyNotifier.value!.id,
            courseId: courseNotifier.value!.id,
            levelId: levelNotifier.value!.id,
            courseRepresentative:
                const CourseRepresentativeModel.empty().copyWith(
              name: nameController.text.trim(),
              studentEmail: emailController.text.trim(),
              indexNumber: idController.text.trim(),
              faculty: facultyNotifier.value,
              course: courseNotifier.value,
              level: levelNotifier.value,
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

    courseNotifier = ValueNotifier(
      context.courseRepresentativeInformationBuilder.courseRepresentativeCourse,
    );

    levelNotifier = ValueNotifier(
      context.courseRepresentativeInformationBuilder.courseRepresentativeLevel,
    );
  }

  @override
  void dispose() {
    facultyNotifier.dispose();
    courseNotifier.dispose();
    levelNotifier.dispose();
    nameController.dispose();
    emailController.dispose();
    idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Course Representative'),
        centerTitle: true,
      ),
      body: BlocConsumer<CourseRepresentativeCubit, CourseRepresentativeState>(
        listener: (context, state) {
          if (state
              case CourseRepresentativeError(:final message, :final title)) {
            CoreUtils.showSnackBar(message: message, title: title);
          } else if (state is CourseRepresentativeAdded) {
            CoreUtils.showSnackBar(
              title: 'Success',
              message: 'Course Representative Added',
              logLevel: LogLevel.success,
            );
            final infoBuilder = context.courseRepresentativeInformationBuilder;
            final originalFaculty = infoBuilder.courseRepresentativeFaculty;
            final originalCourse = infoBuilder.courseRepresentativeCourse;
            final originalLevel = infoBuilder.courseRepresentativeLevel;
            final facultyIsSame = originalFaculty == facultyNotifier.value;
            final courseIsSame = originalCourse == courseNotifier.value;
            final levelIsSame = originalLevel == levelNotifier.value;
            if (widget.refreshAfterAdd &&
                facultyIsSame &&
                courseIsSame &&
                levelIsSame) {
              rootNavigatorKey.currentContext!
                  .read<CourseRepresentativeCubit>()
                  .getCourseRepresentatives(
                    faculty: facultyNotifier.value!,
                    course: courseNotifier.value!,
                    level: levelNotifier.value!,
                  );
            }
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
                            FacultiesDropdown(
                              facultyNotifier: facultyNotifier,
                              courseNotifier: courseNotifier,
                              levelNotifier: levelNotifier,
                              border: InputBorderType.outline,
                            ),
                            const Gap(20),
                            CoursesDropdown(
                              courseNotifier: courseNotifier,
                              facultyNotifier: facultyNotifier,
                              levelNotifier: levelNotifier,
                              border: InputBorderType.outline,
                            ),
                            const Gap(20),
                            LevelsDropdown(
                              courseNotifier: courseNotifier,
                              facultyNotifier: facultyNotifier,
                              levelNotifier: levelNotifier,
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
                              controller: idController,
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
                  ElevatedButton(
                    onPressed: () => submit(null),
                    child: const Text('Add Representative'),
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
