import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'main.dart';
import 'src/core/theme/app_theme.dart';
import 'src/core/theme/cubit/theme_cubit.dart';
import 'src/presentation/cubit/movie/export_movie_cubits.dart';
import 'src/presentation/cubit/movie/get_movie_credits/get_movie_credits_cubit.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (context) => injector<ThemeCubit>()),
        BlocProvider<GetMovieCreditsCubit>(
            create: (context) => injector<GetMovieCreditsCubit>()),
        BlocProvider<GetSavedMoviesCubit>(
            create: (context) =>
            injector<GetSavedMoviesCubit>()..getSavedMovieDetails()),
      ],
      child: ScreenUtilInit(
        builder: (context, child) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              // Determine ThemeData based on themeMode
              ThemeData themeData;
              switch (themeState.themeMode) {
                case ThemeMode.light:
                  themeData = AppTheme.lightTheme;
                  break;
                case ThemeMode.dark:
                  themeData = AppTheme.darkTheme;
                  break;
                case ThemeMode.system:
                  themeData = MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? AppTheme.darkTheme
                      : AppTheme.lightTheme;
                  break;
              }

              return AnimatedTheme(
                data: themeData,
                duration: const Duration(milliseconds: 500), // Animation duration
                curve: Curves.easeInOut, // Smooth animation curve
                child: MaterialApp.router(
                  theme: themeData, // Required for MaterialApp
                  routerDelegate: AutoRouterDelegate(router),
                  routeInformationParser: router.defaultRouteParser(),
                  debugShowCheckedModeBanner: false,
                ),
              );
            },
          );
        },
      ),
    );
  }
}