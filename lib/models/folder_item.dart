import 'dart:ui';

class FolderItem {
  final String title;
  final String icon;
  final VoidCallback onTap;

  FolderItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}
