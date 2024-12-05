part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initCourseRepresentative();
  await _initAcademicStructure();
}

Future<void> _initAcademicStructure() async {
  sl
    ..registerFactory(
      () => AcademicStructureCubit(
        getCourses: sl(),
        getLevels: sl(),
        getFaculties: sl(),
        addCourse: sl(),
        updateCourse: sl(),
        deleteCourse: sl(),
        addLevel: sl(),
        updateLevel: sl(),
        deleteLevel: sl(),
        addFaculty: sl(),
        updateFaculty: sl(),
        deleteFaculty: sl(),
      ),
    )
    ..registerLazySingleton(() => GetCourses(sl()))
    ..registerLazySingleton(() => GetLevels(sl()))
    ..registerLazySingleton(() => GetFaculties(sl()))
    ..registerLazySingleton(() => AddCourse(sl()))
    ..registerLazySingleton(() => UpdateCourse(sl()))
    ..registerLazySingleton(() => DeleteCourse(sl()))
    ..registerLazySingleton(() => AddLevel(sl()))
    ..registerLazySingleton(() => UpdateLevel(sl()))
    ..registerLazySingleton(() => DeleteLevel(sl()))
    ..registerLazySingleton(() => AddFaculty(sl()))
    ..registerLazySingleton(() => UpdateFaculty(sl()))
    ..registerLazySingleton(() => DeleteFaculty(sl()))
    ..registerLazySingleton<AcademicStructureRepo>(
      () => AcademicStructureRepoImpl(sl()),
    )
    ..registerLazySingleton<AcademicStructureRemoteDataSrc>(
      () => AcademicStructureRemoteDataSrcImpl(
        firestore: sl(),
        auth: sl(),
      ),
    );
}

Future<void> _initCourseRepresentative() async {
  sl
    ..registerFactory(
      () => CourseRepresentativeCubit(
        addCourseRepresentative: sl(),
        deleteCourseRepresentative: sl(),
        updateCourseRepresentative: sl(),
        getCourseRepresentatives: sl(),
      ),
    )
    ..registerLazySingleton(() => AddCourseRepresentative(sl()))
    ..registerLazySingleton(() => DeleteCourseRepresentative(sl()))
    ..registerLazySingleton(() => UpdateCourseRepresentative(sl()))
    ..registerLazySingleton(() => GetCourseRepresentatives(sl()))
    ..registerLazySingleton<CourseRepresentativeRepo>(
      () => CourseRepresentativeRepoImpl(sl()),
    )
    ..registerLazySingleton<CourseRepresentativeRemoteDataSrc>(
      () => CourseRepresentativeRemoteDataSrcImpl(
        firestore: sl(),
        auth: sl(),
        functions: sl(),
      ),
    )
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => FirebaseFunctions.instance);
}
