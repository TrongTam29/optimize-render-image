import 'package:get_it/get_it.dart';
import '../cache/app_cache_manager.dart';
import '../../features/image_gallery/data/datasources/image_remote_datasource.dart';
import '../../features/image_gallery/data/repositories/image_repository_impl.dart';
import '../../features/image_gallery/domain/repositories/image_repository.dart';
import '../../features/image_gallery/domain/usecases/image_usecases.dart';
import '../../features/image_gallery/presentation/bloc/image_gallery_bloc.dart';

final GetIt sl = GetIt.instance;

void setupDependencies() {
  sl.registerLazySingleton<AppCacheManager>(() => AppCacheManager());

  sl.registerLazySingleton<ImageRemoteDataSource>(
    () => ImageRemoteDataSource(),
  );

  sl.registerLazySingleton<ImageRepository>(
    () => ImageRepositoryImpl(dataSource: sl()),
  );

  sl.registerLazySingleton(() => GetImagesUseCase(sl()));
  sl.registerLazySingleton(() => AddImageUseCase(sl()));
  sl.registerLazySingleton(() => ReloadImagesUseCase(sl()));

  sl.registerFactory(
    () => ImageGalleryBloc(
      getImagesUseCase: sl(),
      addImageUseCase: sl(),
      reloadImagesUseCase: sl(),
    ),
  );
}
