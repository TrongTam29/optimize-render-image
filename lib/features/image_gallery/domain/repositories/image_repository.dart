import '../entities/image_item.dart';

abstract class ImageRepository {
  Future<List<ImageItem>> getImages({int count = 140, int seedOffset = 0});

  Future<ImageItem> addImage({required int currentCount});
}
