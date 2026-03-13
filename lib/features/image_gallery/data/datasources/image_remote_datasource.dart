import 'package:flutter/foundation.dart';
import '../../domain/entities/image_item.dart';

class _GenerateParams {
  final int count;
  final int seedOffset;
  const _GenerateParams({required this.count, required this.seedOffset});
}

List<ImageItem> _generateInIsolate(_GenerateParams params) {
  return List.generate(params.count, (i) {
    final seed = '${params.seedOffset}_$i';
    return ImageItem(
      id: '${params.seedOffset}_$i',
      imageUrl: 'https://picsum.photos/seed/$seed/200/200',
    );
  });
}

ImageItem _generateSingle(int params) {
  final ts = params;
  return ImageItem(
    id: '${ts}_single',
    imageUrl: 'https://picsum.photos/seed/${ts}_s/200/200',
  );
}

class ImageRemoteDataSource {
  Future<List<ImageItem>> generateImages({
    int count = 140,
    int seedOffset = 0,
  }) {
    return compute(
      _generateInIsolate,
      _GenerateParams(count: count, seedOffset: seedOffset),
    );
  }

  Future<ImageItem> generateSingleImage({required int currentCount}) async {
    final ts = DateTime.now().microsecondsSinceEpoch + currentCount;
    return _generateSingle(ts);
  }
}
