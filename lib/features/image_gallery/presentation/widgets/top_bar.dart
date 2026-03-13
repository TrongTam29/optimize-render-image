import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onAdd;
  final VoidCallback onReloadAll;
  final bool isLoading;

  const TopBar({
    super.key,
    required this.onAdd,
    required this.onReloadAll,
    this.isLoading = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      title: const Text(
        'Image Gallery',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
      ),
      actions: [
        IconButton(
          onPressed: isLoading ? null : onAdd,
          icon: const Icon(Icons.add),
          tooltip: 'Add image',
        ),
        TextButton(
          onPressed: isLoading ? null : onReloadAll,
          child: Text(
            'Reload All',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isLoading
                  ? Theme.of(context).disabledColor
                  : Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
