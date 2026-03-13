import 'package:equatable/equatable.dart';

sealed class ImageGalleryEvent extends Equatable {
  const ImageGalleryEvent();

  @override
  List<Object?> get props => [];
}

final class LoadImagesEvent extends ImageGalleryEvent {
  const LoadImagesEvent();
}

final class AddImageEvent extends ImageGalleryEvent {
  const AddImageEvent();
}

final class ReloadAllImagesEvent extends ImageGalleryEvent {
  const ReloadAllImagesEvent();
}
final class PageChangedEvent extends ImageGalleryEvent {
  final int page;
  const PageChangedEvent(this.page);

  @override
  List<Object?> get props => [page];
}
