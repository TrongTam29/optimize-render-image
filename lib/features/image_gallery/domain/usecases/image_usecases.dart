import '../entities/image_item.dart';
import '../repositories/image_repository.dart';

class GetImagesUseCase {
  final ImageRepository repository;
  const GetImagesUseCase(this.repository);

  Future<List<ImageItem>> call({int count = 140}) =>
      repository.getImages(count: count);
}

class AddImageUseCase {
  final ImageRepository repository;
  const AddImageUseCase(this.repository);

  Future<ImageItem> call({required int currentCount}) =>
      repository.addImage(currentCount: currentCount);
}

class ReloadImagesUseCase {
  final ImageRepository repository;
  const ReloadImagesUseCase(this.repository);

  Future<List<ImageItem>> call() =>
      repository.getImages(count: 140, seedOffset: DateTime.now().millisecondsSinceEpoch);
}
