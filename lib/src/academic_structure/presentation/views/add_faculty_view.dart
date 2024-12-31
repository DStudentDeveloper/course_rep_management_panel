import 'package:course_rep_management_panel/core/common/widgets/input_form_field.dart';
import 'package:course_rep_management_panel/core/extensions/context_extensions.dart';
import 'package:course_rep_management_panel/core/extensions/widget_extensions.dart';
import 'package:course_rep_management_panel/core/services/injection_container.dart';
import 'package:course_rep_management_panel/core/services/router.dart';
import 'package:course_rep_management_panel/core/utils/core_utils.dart';
import 'package:course_rep_management_panel/core/utils/enums/log_level.dart';
import 'package:course_rep_management_panel/src/academic_structure/data/models/faculty_model.dart';
import 'package:course_rep_management_panel/src/academic_structure/presentation/app/adapter/academic_structure_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class AddFacultyView extends StatelessWidget {
  const AddFacultyView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final width = constraints.maxWidth;
        return BlocProvider(
          create: (_) => sl<AcademicStructureCubit>(),
          child: Row(
            children: [
              if (width >= 992) const Spacer(),
              const Expanded(flex: 3, child: AddFacultyPage()),
            ],
          ),
        );
      },
    );
  }
}

class AddFacultyPage extends StatefulWidget {
  const AddFacultyPage({super.key});

  @override
  State<AddFacultyPage> createState() => _AddFacultyPageState();
}

class _AddFacultyPageState extends State<AddFacultyPage> {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void submit(_) {
    if (formKey.currentState!.validate()) {
      context.read<AcademicStructureCubit>().addFaculty(
            const FacultyModel.empty().copyWith(
              name: controller.text.trim(),
            ),
          );
    }
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
        } else if (state is FacultyAdded) {
          CoreUtils.showSnackBar(
            title: 'Success',
            message: 'Faculty added',
            logLevel: LogLevel.success,
          );
          rootNavigatorKey.currentContext!
              .read<AcademicStructureCubit>()
              .getFaculties();
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
                                'Add Faculty',
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
                          child: InputFormField(
                            controller: controller,
                            label: 'Faculty Name',
                            required: true,
                            onSubmitted: submit,
                          ),
                        ),
                      ),
                      const Gap(50),
                      ElevatedButton(
                        onPressed: () => submit(null),
                        child: const Text('Add Faculty'),
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
