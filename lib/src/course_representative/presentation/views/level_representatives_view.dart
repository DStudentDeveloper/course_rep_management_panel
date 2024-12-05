import 'package:course_rep_management_panel/core/common/widgets/info_card.dart';
import 'package:course_rep_management_panel/core/common/widgets/loader.dart';
import 'package:course_rep_management_panel/core/extensions/context_extensions.dart';
import 'package:course_rep_management_panel/core/utils/core_utils.dart';
import 'package:course_rep_management_panel/core/utils/enums/log_level.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/level.dart';
import 'package:course_rep_management_panel/src/course_representative/domain/entities/course_representative.dart';
import 'package:course_rep_management_panel/src/course_representative/presentation/app/adapter/course_representative_cubit.dart';
import 'package:course_rep_management_panel/src/course_representative/presentation/views/edit_course_representative_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class LevelRepresentativesView extends StatefulWidget {
  const LevelRepresentativesView({
    required this.faculty,
    required this.course,
    required this.level,
    super.key,
  });

  final Faculty faculty;
  final Course course;
  final Level level;

  @override
  State<LevelRepresentativesView> createState() =>
      _LevelRepresentativesViewState();
}

class _LevelRepresentativesViewState extends State<LevelRepresentativesView> {
  List<CourseRepresentative> representatives = [];

  void getRepresentatives() {
    context.read<CourseRepresentativeCubit>().getCourseRepresentatives(
          faculty: widget.faculty,
          course: widget.course,
          level: widget.level,
        );
  }

  @override
  void initState() {
    super.initState();
    getRepresentatives();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CourseRepresentativeCubit, CourseRepresentativeState>(
      listener: (_, state) {
        if (state
            case CourseRepresentativeError(:final title, :final message)) {
          CoreUtils.showSnackBar(
            message: message,
            title: title,
            logLevel: LogLevel.error,
          );
        } else if (state is CourseRepresentativeDeleted) {
          CoreUtils.showSnackBar(
            message: 'Course Representative deleted',
            title: 'Success',
            logLevel: LogLevel.success,
          );
          getRepresentatives();
        } else if (state
            case CourseRepresentativesLoaded(
              :final courseRepresentatives,
            )) {
          representatives = courseRepresentatives;
        }
      },
      builder: (context, state) {
        if (state is CourseRepresentativeLoading) {
          return const Loader();
        }

        return SelectionArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(
              bottom: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: widget.faculty.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: context.theme.colorScheme.primary,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        context.go('/');
                      },
                    children: [
                      TextSpan(
                        text: ' - ',
                        style: TextStyle(
                          color: context.theme.textTheme.titleLarge?.color,
                        ),
                      ),
                      TextSpan(
                        text: widget.course.name,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.go(
                              '/faculties/${widget.faculty.id}/courses',
                            );
                          },
                      ),
                      TextSpan(
                        text: ' - ',
                        style: TextStyle(
                          color: context.theme.textTheme.titleLarge?.color,
                        ),
                      ),
                      TextSpan(
                        text: widget.level.name,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.go(
                              '/faculties/${widget.faculty.id}/courses/${widget.course.id}/levels',
                            );
                          },
                      ),
                    ],
                  ),
                ),
                const Gap(25),
                const Text(
                  'Course Representatives',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: representatives.map(
                        (representative) {
                          return Builder(
                            builder: (context) {
                              return InfoCard(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      representative.name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const Gap(10),
                                    Text(
                                      representative.indexNumber,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const Gap(10),
                                    Text(
                                      representative.studentEmail,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                onDelete: () {
                                  context
                                      .read<CourseRepresentativeCubit>()
                                      .deleteCourseRepresentative(
                                        facultyId: widget.faculty.id,
                                        courseId: widget.course.id,
                                        levelId: widget.level.id,
                                        courseRepresentativeId:
                                            representative.id,
                                      );
                                },
                                onEdit: () {
                                  final location = context.namedLocation(
                                    EditCourseRepresentativeScreen.name,
                                    pathParameters: {
                                      'facultyId': widget.faculty.id,
                                      'courseId': widget.course.id,
                                      'levelId': widget.level.id,
                                      'representativeId': representative.id,
                                    },
                                  );
                                  context.navigateTo(
                                    location,
                                    extra: representative,
                                  );
                                },
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
          ),
        );
      },
    );
  }
}
