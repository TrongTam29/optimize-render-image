import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/cache/app_cache_manager.dart';
import '../../domain/entities/image_item.dart';

class ImageCell extends StatelessWidget {
  final ImageItem item;
  final int memCacheSize;
  final bool isPlaceholder;

  static const BorderRadius _kBorderRadius =
      BorderRadius.all(Radius.circular(7));

  static final _cacheManager = AppCacheManager();

  const ImageCell({
    super.key,
    required this.item,
    required this.memCacheSize,
    this.isPlaceholder = false,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: _kBorderRadius,
        child: isPlaceholder ? _placeholder : _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    return CachedNetworkImage(
      imageUrl: item.imageUrl,
      cacheManager: _cacheManager,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.medium,
      memCacheWidth: memCacheSize,
      memCacheHeight: memCacheSize,
      fadeInDuration: const Duration(milliseconds: 220),
      fadeOutDuration: const Duration(milliseconds: 110),
      placeholder: (_, _) => _placeholder,
      errorWidget: (_, _, _) => _errorWidget,
    );
  }

  static const Widget _placeholder = ColoredBox(
    color: Color(0xFFE0E0E0),
    child: Center(child: CupertinoActivityIndicator(radius: 8)),
  );

  static const Widget _errorWidget = ColoredBox(
    color: Color(0xFFBDBDBD),
    child: Center(
      child: Icon(Icons.broken_image_outlined, size: 18, color: Colors.grey),
    ),
  );
}
