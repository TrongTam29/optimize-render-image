import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/cache/app_cache_manager.dart';
import '../../domain/entities/image_item.dart';
import '../bloc/image_gallery_bloc.dart';
import '../bloc/image_gallery_event.dart';
import '../bloc/image_gallery_state.dart';
import '../constants/gallery_constants.dart';
import '../widgets/image_cell.dart';
import '../widgets/top_bar.dart';

class ImageGalleryPage extends StatefulWidget {
  const ImageGalleryPage({super.key});

  @override
  State<ImageGalleryPage> createState() => _ImageGalleryPageState();
}

class _ImageGalleryPageState extends State<ImageGalleryPage> {
  late final PageController _pageController;

  double _aspectRatio = 1.0;
  int _memCacheSize = 200;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _preloadAdjacentPages(int currentPage, List<ImageItem> images) {
    final cacheManager = AppCacheManager();
    for (final offset in [-1, 1]) {
      final targetPage = currentPage + offset;
      if (targetPage < 0) continue;
      final start = targetPage * kItemsPerPage;
      if (start >= images.length) continue;
      final end = (start + kItemsPerPage).clamp(0, images.length);
      for (var i = start; i < end; i++) {
        precacheImage(
          CachedNetworkImageProvider(
            images[i].imageUrl,
            cacheManager: cacheManager,
          ),
          context,
        );
      }
    }
  }

  void _scrollToLastPage(List<ImageItem> images, bool isAdding) {
    if (!_pageController.hasClients) return;
    final totalItems = images.length + (isAdding ? 1 : 0);
    final lastPage = (totalItems / kItemsPerPage).ceil().clamp(1, 999) - 1;
    final currentPage = (_pageController.page ?? 0).round();
    if (lastPage > currentPage) {
      _pageController.animateToPage(
        lastPage,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ImageGalleryBloc, ImageGalleryState>(
      buildWhen: (prev, curr) =>
          prev.runtimeType != curr.runtimeType ||
          (prev is ImageGalleryLoaded &&
              curr is ImageGalleryLoaded &&
              (prev.images.length != curr.images.length ||
                  prev.isAddingImage != curr.isAddingImage ||
                  prev.currentPage != curr.currentPage)),
      listenWhen: (prev, curr) =>
          prev is ImageGalleryLoaded &&
          curr is ImageGalleryLoaded &&
          (prev.images.length < curr.images.length ||
              (curr.shouldScrollToLastPage && !prev.shouldScrollToLastPage) ||
              prev.currentPage != curr.currentPage),
      listener: (context, state) {
        if (state is ImageGalleryLoaded) {
          if (state.shouldScrollToLastPage) {
            _scrollToLastPage(state.images, state.isAddingImage);
          }
          _preloadAdjacentPages(state.currentPage, state.images);
        }
      },
      builder: (context, state) {
        final isLoading = state is ImageGalleryLoading;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: TopBar(
            isLoading: isLoading,
            onAdd: () =>
                context.read<ImageGalleryBloc>().add(const AddImageEvent()),
            onReloadAll: () => context.read<ImageGalleryBloc>().add(
                  const ReloadAllImagesEvent(),
                ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: switch (state) {
                ImageGalleryInitial() ||
                ImageGalleryLoading() => _buildLoading(),
                ImageGalleryLoaded() => _buildPagedGrid(state),
                ImageGalleryError() => _buildError(context, state.message),
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator.adaptive());
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () =>
                context.read<ImageGalleryBloc>().add(const LoadImagesEvent()),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildPagedGrid(ImageGalleryLoaded state) {
    final images = state.images;
    final isAdding = state.isAddingImage;
    final totalItems = images.length + (isAdding ? 1 : 0);
    final pageCount = (totalItems / kItemsPerPage).ceil().clamp(1, 999);

    return LayoutBuilder(
      builder: (context, constraints) {
        final cellW =
            (constraints.maxWidth - (kColumns - 1) * kGap) / kColumns;
        final cellH = (constraints.maxHeight - (kRows - 1) * kGap) / kRows;
        final ratio = cellW / cellH;

        final dpr = MediaQuery.of(context).devicePixelRatio;
        final pxSize = (cellW * dpr).ceil();

        if (ratio != _aspectRatio || pxSize != _memCacheSize) {
          _aspectRatio = ratio;
          _memCacheSize = pxSize;
        }

        return PageView.builder(
          controller: _pageController,
          physics: const ClampingScrollPhysics(),
          itemCount: pageCount,
          onPageChanged: (page) => context.read<ImageGalleryBloc>().add(
                PageChangedEvent(page),
              ),
          itemBuilder: (context, pageIndex) {
            final start = pageIndex * kItemsPerPage;
            final end = (start + kItemsPerPage).clamp(0, totalItems);
            return _GridPage(
              key: PageStorageKey<int>(pageIndex),
              images: images,
              startIdx: start,
              pageItemCount: end - start,
              totalItems: totalItems,
              isAdding: isAdding,
              aspectRatio: _aspectRatio,
              memCacheSize: _memCacheSize,
            );
          },
        );
      },
    );
  }
}

class _GridPage extends StatefulWidget {
  final List<ImageItem> images;
  final int startIdx;
  final int pageItemCount;
  final int totalItems;
  final bool isAdding;
  final double aspectRatio;
  final int memCacheSize;

  const _GridPage({
    super.key,
    required this.images,
    required this.startIdx,
    required this.pageItemCount,
    required this.totalItems,
    required this.isAdding,
    required this.aspectRatio,
    required this.memCacheSize,
  });

  @override
  State<_GridPage> createState() => _GridPageState();
}

class _GridPageState extends State<_GridPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); 
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      addRepaintBoundaries: false,
      addAutomaticKeepAlives: false,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: kColumns,
        mainAxisSpacing: kGap,
        crossAxisSpacing: kGap,
        childAspectRatio: widget.aspectRatio,
      ),
      itemCount: widget.pageItemCount,
      itemBuilder: (_, localIdx) {
        final globalIdx = widget.startIdx + localIdx;
        final isSpinner = widget.isAdding && globalIdx == widget.totalItems - 1;

        if (isSpinner) {
          return ImageCell(
            key: const ValueKey('__placeholder__'),
            item: const ImageItem(id: '__placeholder__', imageUrl: ''),
            memCacheSize: widget.memCacheSize,
            isPlaceholder: true,
          );
        }

        final item = widget.images[globalIdx];
        return ImageCell(
          key: ValueKey(item.id),
          item: item,
          memCacheSize: widget.memCacheSize,
        );
      },
    );
  }
}
