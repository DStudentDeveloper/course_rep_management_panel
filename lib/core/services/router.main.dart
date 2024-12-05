part of 'router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

const authRoutes = [
  LoginScreen.path,
  SignUpScreen.path,
  VerifyEmailScreen.path,
];

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  redirect: (_, state) async {
    if (authRoutes.contains(state.fullPath)) {
      if (FirebaseAuth.instance.currentUser != null &&
          state.fullPath != VerifyEmailScreen.path) {
        return '/';
      }
      return null;
    }

    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      user = await FirebaseAuth.instance.authStateChanges().first;
      if (user == null || user.displayName == null) {
        return LoginScreen.path;
      }
    } else if (!user.emailVerified) {
      return VerifyEmailScreen.path;
    }
    return null;
  },
  routes: [
    GoRoute(path: LoginScreen.path, builder: (_, __) => const LoginScreen()),
    GoRoute(path: SignUpScreen.path, builder: (_, __) => const SignUpScreen()),
    GoRoute(
      path: UserProfileScreen.path,
      builder: (_, __) => const UserProfileScreen(),
    ),
    GoRoute(
      path: VerifyEmailScreen.path,
      builder: (_, __) => const VerifyEmailScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (_, state, child) {
        return Dashboard(state: state, child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const FacultiesView(),
        ),
        GoRoute(
          path: AddCourseRepresentativeScreen.path,
          builder: (_, state) => AddCourseRepresentativeScreen(
            refreshAfterAdd:
                (state.extra as DataMap?)?['refreshAfterAdd'] as bool? ?? false,
          ),
        ),
        GoRoute(
          path: '/faculties/:facultyId/courses',
          redirect: (context, state) {
            final faculty = context
                .read<CourseRepresentativeInformationBuilder>()
                .courseRepresentativeFaculty;
            if (faculty == null) {
              CoreUtils.showSnackBar(
                message: 'Please select a faculty',
                logLevel: LogLevel.error,
              );
              return '/';
            }
            return null;
          },
          builder: (context, state) {
            final faculty = context
                .read<CourseRepresentativeInformationBuilder>()
                .courseRepresentativeFaculty!;
            return FacultyCoursesView(faculty: faculty);
          },
        ),
        GoRoute(
          path: '/faculties/:facultyId/courses/:courseId/levels',
          redirect: (context, state) {
            final infoBuilder =
                context.read<CourseRepresentativeInformationBuilder>();
            final faculty = infoBuilder.courseRepresentativeFaculty;
            final course = infoBuilder.courseRepresentativeCourse;
            if (faculty == null || course == null) {
              CoreUtils.showSnackBar(
                message: 'Please select a faculty and course',
                logLevel: LogLevel.error,
              );
              return '/';
            }
            return null;
          },
          builder: (context, state) {
            final infoBuilder =
                context.read<CourseRepresentativeInformationBuilder>();
            final faculty = infoBuilder.courseRepresentativeFaculty!;
            final course = infoBuilder.courseRepresentativeCourse!;
            return CourseLevelsView(faculty: faculty, course: course);
          },
        ),
        GoRoute(
          path: '/faculties/:facultyId/courses/:courseId/levels/:levelId'
              '/representatives',
          redirect: (context, state) {
            final infoBuilder =
                context.read<CourseRepresentativeInformationBuilder>();
            final faculty = infoBuilder.courseRepresentativeFaculty;
            final course = infoBuilder.courseRepresentativeCourse;
            final level = infoBuilder.courseRepresentativeLevel;
            if (faculty == null || course == null || level == null) {
              CoreUtils.showSnackBar(
                message: 'Please select a faculty, course and level',
                logLevel: LogLevel.error,
              );
              return '/';
            }
            return null;
          },
          builder: (context, state) {
            final infoBuilder =
                context.read<CourseRepresentativeInformationBuilder>();
            final faculty = infoBuilder.courseRepresentativeFaculty!;
            final course = infoBuilder.courseRepresentativeCourse!;
            final level = infoBuilder.courseRepresentativeLevel!;
            return LevelRepresentativesView(
              faculty: faculty,
              course: course,
              level: level,
            );
          },
        ),
        GoRoute(
          name: EditCourseRepresentativeScreen.name,
          path: EditCourseRepresentativeScreen.path,
          redirect: (context, state) {
            if (state.extra is! CourseRepresentative) {
              CoreUtils.showSnackBar(
                message: 'Invalid course representative',
                logLevel: LogLevel.error,
              );
              return '/';
            }
            return null;
          },
          builder: (context, state) {
            return EditCourseRepresentativeScreen(
              state.extra! as CourseRepresentative,
            );
          },
        ),
      ],
    ),
  ],
);
