import '../../domain/entities/image_item.dart';
import '../../domain/repositories/image_repository.dart';
import '../datasources/image_remote_datasource.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImageRemoteDataSource dataSource;

  const ImageRepositoryImpl({required this.dataSource});

  @override
  Future<List<ImageItem>> getImages({
    int count = 140,
    int seedOffset = 0,
  }) async {
    return dataSource.generateImages(count: count, seedOffset: seedOffset);
  }

  @override
  Future<ImageItem> addImage({required int currentCount}) async {
    return dataSource.generateSingleImage(currentCount: currentCount);
  }
}
