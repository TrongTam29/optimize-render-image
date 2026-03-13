import 'package:equatable/equatable.dart';
import '../../domain/entities/image_item.dart';

sealed class ImageGalleryState extends Equatable {
  const ImageGalleryState();

  @override
  List<Object?> get props => [];
}

final class ImageGalleryInitial extends ImageGalleryState {
  const ImageGalleryInitial();
}

final class ImageGalleryLoading extends ImageGalleryState {
  const ImageGalleryLoading();
}

final class ImageGalleryLoaded extends ImageGalleryState {
  final List<ImageItem> images;
  final bool isAddingImage;
  final int currentPage;
  final bool shouldScrollToLastPage;

  const ImageGalleryLoaded({
    required this.images,
    this.isAddingImage = false,
    this.currentPage = 0,
    this.shouldScrollToLastPage = false,
  });

  ImageGalleryLoaded copyWith({
    List<ImageItem>? images,
    bool? isAddingImage,
    int? currentPage,
    bool? shouldScrollToLastPage,
  }) {
    return ImageGalleryLoaded(
      images: images ?? this.images,
      isAddingImage: isAddingImage ?? this.isAddingImage,
      currentPage: currentPage ?? this.currentPage,
      shouldScrollToLastPage: shouldScrollToLastPage ?? this.shouldScrollToLastPage,
    );
  }

  @override
  List<Object?> get props => [
        images,
        isAddingImage,
        currentPage,
        shouldScrollToLastPage,
      ];
}

final class ImageGalleryError extends ImageGalleryState {
  final String message;
  const ImageGalleryError(this.message);

  @override
  List<Object?> get props => [message];
}
