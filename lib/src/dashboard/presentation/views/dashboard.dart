import 'package:course_rep_management_panel/core/extensions/context_extensions.dart';
import 'package:course_rep_management_panel/core/utils/core_utils.dart';
import 'package:course_rep_management_panel/core/utils/enums/depth.dart';
import 'package:course_rep_management_panel/src/academic_structure/presentation/views/add_course_view.dart';
import 'package:course_rep_management_panel/src/academic_structure/presentation/views/add_faculty_view.dart';
import 'package:course_rep_management_panel/src/academic_structure/presentation/views/add_level_view.dart';
import 'package:course_rep_management_panel/src/course_representative/presentation/views/add_course_representative_screen.dart';
import 'package:course_rep_management_panel/src/dashboard/presentation/sections/dashboard_drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({required this.state, required this.child, super.key});

  final GoRouterState state;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(child: DashboardDrawer(state: state)),
          Expanded(
            flex: 3,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                toolbarHeight: 160,
                title: const Text('COURSE REPRESENTATIVE MANAGEMENT SYSTEM'),
              ),
              body: child,
              floatingActionButton: StatefulBuilder(
                builder: (_, setState) {
                  if (state.fullPath == AddCourseRepresentativeScreen.path) {
                    return const SizedBox.shrink();
                  }

                  var depth = Depth.faculty;
                  if (state.fullPath!.endsWith('/courses')) {
                    depth = Depth.course;
                  } else if (state.fullPath!.endsWith('/levels')) {
                    depth = Depth.level;
                  }
                  return SpeedDial(
                    icon: Icons.add,
                    activeIcon: Icons.close,
                    overlayColor: Colors.transparent,
                    overlayOpacity: 0,
                    children: [
                      SpeedDialChild(
                        onTap: () {
                          context.navigateTo(
                            AddCourseRepresentativeScreen.path,
                            extra: {
                              'refreshAfterAdd': (!kIsWeb && !kIsWasm) &&
                                  state.fullPath!.endsWith('/representatives'),
                            },
                          );
                          setState(() {});
                        },
                        backgroundColor: Colors.transparent,
                        labelStyle: const TextStyle(color: Colors.black),
                        label: 'Add Course Representative',
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.orange,
                          ),
                          child: const Icon(Icons.add),
                        ),
                      ),
                      if (!state.fullPath!.endsWith('/representatives'))
                        SpeedDialChild(
                          onTap: () {
                            CoreUtils.showCustomDialog(
                              context,
                              dialog: switch (depth) {
                                Depth.faculty => const AddFacultyView(),
                                Depth.course => const AddCourseView(),
                                Depth.level => const AddLevelView(),
                              },
                            );
                          },
                          backgroundColor: Colors.transparent,
                          labelStyle: const TextStyle(color: Colors.black),
                          label: 'Add ${depth.value}',
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFd82a23),
                            ),
                            child: const Icon(Icons.add),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
