import 'package:course_rep_management_panel/core/extensions/context_extensions.dart';
import 'package:course_rep_management_panel/src/course_representative/presentation/views/add_course_representative_screen.dart';
import 'package:course_rep_management_panel/src/dashboard/presentation/app/course_represenatative_information_builder.dart';
import 'package:course_rep_management_panel/src/profile/presentation/views/user_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({
    required this.state,
    this.isStatic = false,
    super.key,
  });

  final GoRouterState state;
  final bool isStatic;

  @override
  Widget build(BuildContext context) {
    final foregroundColour = context.theme.colorScheme.onPrimary;

    void closeDrawer() {
      if (!isStatic) {
        Scaffold.of(context).closeDrawer();
      }
    }

    return Drawer(
      backgroundColor: context.theme.colorScheme.primary,
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go('/');
            });
            return const SizedBox.shrink();
          }
          final user = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DrawerHeader(
                child: Center(
                  child: Column(
                    children: [
                      if (!isStatic)
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            color: foregroundColour,
                            onPressed: () {
                              Scaffold.of(context).closeDrawer();
                            },
                            icon: const Icon(IconlyBroken.close_square),
                          ),
                        ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                user.displayName ?? 'Unknown User',
                                style: context.theme.textTheme.titleLarge
                                    ?.copyWith(
                                  color: foregroundColour,
                                ),
                              ),
                            ),
                            const Gap(8),
                            Flexible(
                              child: IconButton(
                                color: foregroundColour,
                                onPressed: () {
                                  context.navigateTo(UserProfileScreen.path);
                                },
                                icon: const Icon(IconlyBroken.edit),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Consumer<CourseRepresentativeInformationBuilder>(
                  builder: (_, info, __) {
                    return ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        if (info.courseRepresentativeFaculty != null ||
                            ((kIsWeb || kIsWasm) &&
                                state.fullPath ==
                                    AddCourseRepresentativeScreen.path)) ...[
                          ListTile(
                            leading: const Icon(IconlyBroken.home),
                            title: const Text('Home'),
                            iconColor: foregroundColour,
                            textColor: foregroundColour,
                            onTap: () {
                              closeDrawer();
                              context.go('/');
                            },
                          ),
                          if (info.courseRepresentativeCourse != null)
                            ListTile(
                              leading: const Icon(IconlyBroken.bookmark),
                              title: const Text('Courses'),
                              iconColor: foregroundColour,
                              textColor: foregroundColour,
                              onTap: () {
                                closeDrawer();
                                context.go(
                                  '/faculties'
                                  '/${info.courseRepresentativeFaculty!.id}'
                                  '/courses',
                                );
                              },
                            ),
                          if (info.courseRepresentativeLevel != null)
                            ListTile(
                              leading: const Icon(IconlyBroken.bookmark),
                              title: const Text('Levels'),
                              iconColor: foregroundColour,
                              textColor: foregroundColour,
                              onTap: () {
                                closeDrawer();
                                context.go(
                                  '/faculties'
                                  '/${info.courseRepresentativeFaculty!.id}'
                                  '/courses'
                                  '/${info.courseRepresentativeCourse!.id}'
                                  '/levels',
                                );
                              },
                            ),
                        ],
                      ],
                    );
                  },
                ),
              ),
              LayoutBuilder(
                builder: (_, constraints) {
                  final width = constraints.maxWidth;
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * .05,
                    ).copyWith(bottom: 20),
                    child: ElevatedButton.icon(
                      icon: const Icon(IconlyBroken.logout),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                      },
                      label: const Text('Sign Out'),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
