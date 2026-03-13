import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'features/image_gallery/presentation/bloc/image_gallery_bloc.dart';
import 'features/image_gallery/presentation/bloc/image_gallery_event.dart';
import 'features/image_gallery/presentation/pages/image_gallery_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  setupDependencies();
  runApp(const ImageGalleryApp());
}

class ImageGalleryApp extends StatelessWidget {
  const ImageGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Gallery',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const _NoGlowScrollBehaviour(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2196F3),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      home: BlocProvider<ImageGalleryBloc>(
        create: (_) =>
            sl<ImageGalleryBloc>()..add(const LoadImagesEvent()),
        child: const ImageGalleryPage(),
      ),
    );
  }
}

class _NoGlowScrollBehaviour extends ScrollBehavior {
  const _NoGlowScrollBehaviour();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) =>
      child;
}
