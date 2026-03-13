import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/image_usecases.dart';
import 'image_gallery_event.dart';
import 'image_gallery_state.dart';

class ImageGalleryBloc extends Bloc<ImageGalleryEvent, ImageGalleryState> {
  final GetImagesUseCase getImagesUseCase;
  final AddImageUseCase addImageUseCase;
  final ReloadImagesUseCase reloadImagesUseCase;

  ImageGalleryBloc({
    required this.getImagesUseCase,
    required this.addImageUseCase,
    required this.reloadImagesUseCase,
  }) : super(const ImageGalleryInitial()) {
    on<LoadImagesEvent>(_onLoadImages, transformer: droppable());
    on<AddImageEvent>(_onAddImage, transformer: droppable());
    on<ReloadAllImagesEvent>(_onReloadAll, transformer: droppable());
    on<PageChangedEvent>(_onPageChanged);
  }

  void _onPageChanged(
    PageChangedEvent event,
    Emitter<ImageGalleryState> emit,
  ) {
    final current = state;
    if (current is! ImageGalleryLoaded) return;
    emit(current.copyWith(
      currentPage: event.page,
      shouldScrollToLastPage: false,
    ));
  }

  Future<void> _onLoadImages(
    LoadImagesEvent event,
    Emitter<ImageGalleryState> emit,
  ) async {
    emit(const ImageGalleryLoading());
    try {
      final images = await getImagesUseCase(count: 140);
      emit(ImageGalleryLoaded(images: images));
    } catch (e) {
      emit(ImageGalleryError('Failed to load images: $e'));
    }
  }

  Future<void> _onAddImage(
    AddImageEvent event,
    Emitter<ImageGalleryState> emit,
  ) async {
    final current = state;
    if (current is! ImageGalleryLoaded) return;

    emit(current.copyWith(isAddingImage: true));

    try {
      final newItem = await addImageUseCase(currentCount: current.images.length);
      final updated = [...current.images, newItem];
      emit(ImageGalleryLoaded(
        images: updated,
        currentPage: current.currentPage,
        shouldScrollToLastPage: true,
      ));
    } catch (e) {
      emit(current.copyWith(isAddingImage: false));
    }
  }

  Future<void> _onReloadAll(
    ReloadAllImagesEvent event,
    Emitter<ImageGalleryState> emit,
  ) async {
    emit(const ImageGalleryLoading());
    try {
      final images = await reloadImagesUseCase();
      emit(ImageGalleryLoaded(images: images));
    } catch (e) {
      emit(ImageGalleryError('Failed to reload: $e'));
    }
  }
}
