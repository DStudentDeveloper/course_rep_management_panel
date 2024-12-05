import 'package:course_rep_management_panel/core/res/colours.dart';
import 'package:course_rep_management_panel/core/services/injection_container.dart';
import 'package:course_rep_management_panel/core/services/router.dart';
import 'package:course_rep_management_panel/l10n/l10n.dart';
import 'package:course_rep_management_panel/src/academic_structure/presentation/app/adapter/academic_structure_cubit.dart';
import 'package:course_rep_management_panel/src/course_representative/presentation/app/adapter/course_representative_cubit.dart';
import 'package:course_rep_management_panel/src/dashboard/presentation/app/course_represenatative_information_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<CourseRepresentativeCubit>()),
        BlocProvider(create: (context) => sl<AcademicStructureCubit>()),
      ],
      child: ChangeNotifierProvider(
        create: (_) => CourseRepresentativeInformationBuilder(),
        child: MaterialApp.router(
          routerConfig: router,
          themeMode: ThemeMode.dark,
          darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
            colorScheme: ColorScheme.fromSeed(seedColor: Colours.primary),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
            ),
          ),
          builder: FToastBuilder(),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colours.primary),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black,
            ),
            useMaterial3: true,
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
  }
}
