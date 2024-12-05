import 'package:course_rep_management_panel/core/common/widgets/info_card.dart';
import 'package:course_rep_management_panel/core/common/widgets/loader.dart';
import 'package:course_rep_management_panel/core/extensions/context_extensions.dart';
import 'package:course_rep_management_panel/core/utils/core_utils.dart';
import 'package:course_rep_management_panel/core/utils/enums/log_level.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/presentation/app/adapter/academic_structure_cubit.dart';
import 'package:course_rep_management_panel/src/academic_structure/presentation/views/edit_faculty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class FacultiesView extends StatefulWidget {
  const FacultiesView({super.key});

  @override
  State<FacultiesView> createState() => _FacultiesViewState();
}

class _FacultiesViewState extends State<FacultiesView> {
  List<Faculty> faculties = [];

  @override
  void initState() {
    super.initState();
    context
      ..changeFaculty(null)
      ..changeCourse(null)
      ..changeLevel(null)
      ..read<AcademicStructureCubit>().getFaculties();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AcademicStructureCubit, AcademicStructureState>(
      listener: (_, state) {
        if (state case AcademicStructureError(:final title, :final message)) {
          CoreUtils.showSnackBar(
            message: message,
            title: title,
            logLevel: LogLevel.error,
          );
        } else if (state is FacultyDeleted) {
          CoreUtils.showSnackBar(
            message: 'Faculty deleted',
            title: 'Success',
            logLevel: LogLevel.success,
          );
          context.read<AcademicStructureCubit>().getFaculties();
        } else if (state case FacultiesLoaded(:final faculties)) {
          this.faculties = faculties;
        }
      },
      builder: (context, state) {
        if (state is AcademicStructureLoading) {
          return const Loader();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(
            bottom: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Faculties',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Gap(20),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: faculties.map(
                      (faculty) {
                        return InfoCard(
                          infoText: faculty.name,
                          onEdit: () {
                            CoreUtils.showCustomDialog(
                              context,
                              dialog: EditFacultyView(faculty),
                            );
                          },
                          onDelete: () {
                            context
                                .read<AcademicStructureCubit>()
                                .deleteFaculty(faculty.id);
                          },
                          onTap: () {
                            context
                              ..changeFaculty(faculty)
                              ..go('/faculties/${faculty.id}/courses');
                          },
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
