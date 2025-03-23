class DesktopIconData {
  final String title;
  final String iconPath;
  final void Function()? onOpen;

  DesktopIconData({
    required this.title,
    required this.iconPath,
    this.onOpen,
  });
}
