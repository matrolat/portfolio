import 'package:flutter/material.dart';
import 'package:portfolio/models/desktop_icon.dart';

class DesktopIcons extends StatelessWidget {
  final List<DesktopIconData> icons;

  const DesktopIcons({super.key, required this.icons});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate how many icons can fit per row
            const double iconWidth = 100; // icon + padding
            int crossAxisCount = (constraints.maxWidth / iconWidth).floor();

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 30,
                mainAxisSpacing: 40,
                childAspectRatio: 0.8,
              ),
              itemCount: icons.length,
              itemBuilder: (context, index) {
                final icon = icons[index];
                return _buildDesktopIcon(icon);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildDesktopIcon(DesktopIconData iconData) {
    return GestureDetector(
      onTap: iconData.onOpen,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(iconData.iconPath, width: 48, height: 48),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              iconData.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tahoma',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
