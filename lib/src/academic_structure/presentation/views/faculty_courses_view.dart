import 'package:course_rep_management_panel/core/common/widgets/info_card.dart';
import 'package:course_rep_management_panel/core/common/widgets/loader.dart';
import 'package:course_rep_management_panel/core/extensions/context_extensions.dart';
import 'package:course_rep_management_panel/core/utils/core_utils.dart';
import 'package:course_rep_management_panel/core/utils/enums/log_level.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/presentation/app/adapter/academic_structure_cubit.dart';
import 'package:course_rep_management_panel/src/academic_structure/presentation/views/edit_course_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class FacultyCoursesView extends StatefulWidget {
  const FacultyCoursesView({required this.faculty, super.key});

  final Faculty faculty;

  @override
  State<FacultyCoursesView> createState() => _FacultyCoursesViewState();
}

class _FacultyCoursesViewState extends State<FacultyCoursesView> {
  List<Course> courses = [];

  @override
  void initState() {
    super.initState();
    context
      ..changeLevel(null)
      ..changeCourse(null)
      ..read<AcademicStructureCubit>().getCourses(widget.faculty);
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
        } else if (state is CourseDeleted) {
          CoreUtils.showSnackBar(
            message: 'Faculty deleted',
            title: 'Success',
            logLevel: LogLevel.success,
          );
          context.read<AcademicStructureCubit>().getCourses(widget.faculty);
        } else if (state case CoursesLoaded(:final courses)) {
          this.courses = courses;
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
              InkWell(
                onTap: () {
                  context.go('/');
                },
                hoverColor: Colors.transparent,
                child: Text(
                  widget.faculty.name,
                  style: TextStyle(
                    fontSize: 18,
                    color: context.theme.colorScheme.primary,
                  ),
                ),
              ),
              const Gap(25),
              const Text(
                'Courses',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Gap(20),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: courses.map(
                      (course) {
                        return InfoCard(
                          infoText: course.name,
                          onEdit: () {
                            CoreUtils.showCustomDialog(
                              context,
                              dialog: EditCourseView(course),
                            );
                          },
                          onDelete: () {
                            context.read<AcademicStructureCubit>().deleteCourse(
                                  facultyId: widget.faculty.id,
                                  courseId: course.id,
                                );
                          },
                          onTap: () {
                            context
                              ..changeCourse(course)
                              ..go(
                                '/faculties/${widget.faculty.id}'
                                '/courses/${course.id}/levels',
                              );
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
