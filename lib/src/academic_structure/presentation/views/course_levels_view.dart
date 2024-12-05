import 'package:course_rep_management_panel/core/common/widgets/info_card.dart';
import 'package:course_rep_management_panel/core/common/widgets/loader.dart';
import 'package:course_rep_management_panel/core/extensions/context_extensions.dart';
import 'package:course_rep_management_panel/core/utils/core_utils.dart';
import 'package:course_rep_management_panel/core/utils/enums/log_level.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/course.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/faculty.dart';
import 'package:course_rep_management_panel/src/academic_structure/domain/entities/level.dart';
import 'package:course_rep_management_panel/src/academic_structure/presentation/app/adapter/academic_structure_cubit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CourseLevelsView extends StatefulWidget {
  const CourseLevelsView({
    required this.faculty,
    required this.course,
    super.key,
  });

  final Faculty faculty;
  final Course course;

  @override
  State<CourseLevelsView> createState() => _CourseLevelsViewState();
}

class _CourseLevelsViewState extends State<CourseLevelsView> {
  void _showContextMenu(BuildContext context) {
    final overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final renderBox = context.findRenderObject()! as RenderBox;

    final offset = renderBox.localToGlobal(Offset.zero, ancestor: overlay);
    final size = renderBox.size;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        overlay.size.width - offset.dx - size.width,
        overlay.size.height - offset.dy - size.height,
      ),
      items: [
        const PopupMenuItem(value: 'edit', child: Text('Edit')),
        const PopupMenuItem(value: 'delete', child: Text('Delete')),
      ],
    );
  }

  List<Level> levels = [];

  void getLevels() {
    context.read<AcademicStructureCubit>().getLevels(
          faculty: widget.faculty,
          course: widget.course,
        );
  }

  @override
  void initState() {
    super.initState();
    context
      ..changeLevel(null)
      ..read<AcademicStructureCubit>().getLevels(
        faculty: widget.faculty,
        course: widget.course,
      );
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
        } else if (state is LevelDeleted) {
          CoreUtils.showSnackBar(
            message: 'Level deleted',
            title: 'Success',
            logLevel: LogLevel.success,
          );
          getLevels();
        } else if (state case LevelsLoaded(:final levels)) {
          this.levels = levels;
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: context.theme.colorScheme.primary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.go('/faculties/${widget.faculty.id}/courses');
                        },
                    ),
                  ],
                ),
              ),
              const Gap(25),
              const Text(
                'Levels',
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
                    children: levels.map(
                      (level) {
                        return Builder(
                          builder: (context) {
                            return InfoCard(
                              infoText: level.name,
                              onDelete: () {
                                context
                                    .read<AcademicStructureCubit>()
                                    .deleteLevel(
                                      facultyId: widget.faculty.id,
                                      courseId: widget.course.id,
                                      levelId: level.id,
                                    );
                              },
                              onTap: () {
                                context
                                  ..changeLevel(level)
                                  ..go(
                                    '/faculties/${widget.faculty.id}'
                                    '/courses/${widget.course.id}/levels'
                                    '/${level.id}/representatives',
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
        );
      },
    );
  }
}
