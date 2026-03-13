import 'package:equatable/equatable.dart';

class ImageItem extends Equatable {
  final String id;
  final String imageUrl;

  const ImageItem({
    required this.id,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, imageUrl];
}
