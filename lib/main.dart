import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'main_app.dart';
import 'src/config/router/app_router.dart';
import 'src/core/database/local_database.dart';
import 'src/core/network/dio_client.dart';
import 'src/core/theme/cubit/theme_cubit.dart';
import 'src/data/datasources/export_datasources.dart';
import 'src/data/repositories/export_repository_impls.dart';
import 'src/domain/repositories/actor/actor_repository.dart';
import 'src/domain/repositories/movie/movie_repository.dart';
import 'src/domain/usecases/export_usecases.dart';
import 'src/presentation/cubit/actor/export_actor_cubits.dart';
import 'src/presentation/cubit/movie/export_movie_cubits.dart';
import 'src/presentation/cubit/movie/get_movie_credits/get_movie_credits_cubit.dart';

part './src/injector.dart';

final router = AppRouter();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await init();

  await injector<LocalDatabase>().initialize();

  final directory =
      HydratedStorageDirectory((await getApplicationDocumentsDirectory()).path);

  HydratedBloc.storage =
      await HydratedStorage.build(storageDirectory: directory);

  runApp(const MainApp());
}
