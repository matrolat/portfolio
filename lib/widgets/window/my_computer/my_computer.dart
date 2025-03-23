import 'package:flutter/material.dart';
import 'package:portfolio/widgets/window/projects/projects.dart';
import 'package:portfolio/widgets/window/education/education.dart';
import 'package:portfolio/widgets/window/experience/experience.dart';
import 'package:portfolio/widgets/window/contact_me/contact_me.dart';
import 'package:portfolio/provider/window_manager.dart';
import 'package:provider/provider.dart';
import 'package:portfolio/models/folder_item.dart';

class MyComputer extends StatelessWidget {
  const MyComputer({super.key});

  @override
  Widget build(BuildContext context) {
    final windowManager = Provider.of<WindowManager>(context, listen: false);

    final List<FolderItem> folders = [
      FolderItem(
        title: 'My Projects',
        icon: 'assets/images/folder_icon.png',
        onTap: () => windowManager.openWindow(
          "My Projects",
          ProjectsExplorer(projects: [
            {'title': 'EzShop Website', 'icon': 'assets/images/folder_icon.png'},
            {'title': 'LibMaster app', 'icon': 'assets/images/folder_icon.png'},
            {'title': 'Dhruva Website', 'icon': 'assets/images/folder_icon.png'},
          ]),
        ),
      ),
      FolderItem(
        title: 'Education',
        icon: 'assets/images/folder_icon.png',
        onTap: () => windowManager.openWindow("Education", const Education()),
      ),
      FolderItem(
        title: 'Experience',
        icon: 'assets/images/folder_icon.png',
        onTap: () => windowManager.openWindow("Experience", const Experience()),
      ),
      FolderItem(
        title: 'Contact Me',
        icon: 'assets/images/folder_icon.png',
        onTap: () => windowManager.openWindow("Contact Me", const ContactMe()),
      ),
    ];

    return SizedBox(
      width: 700,
      height: 510,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              const double iconWidth = 100;
              final int crossAxisCount = (constraints.maxWidth / iconWidth).floor().clamp(1, folders.length);

              return GridView.builder(
                itemCount: folders.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 30,
                  crossAxisSpacing: 30,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final folder = folders[index];
                  return GestureDetector(
                    onDoubleTap: folder.onTap,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(folder.icon, width: 64, height: 64),
                        const SizedBox(height: 8),
                        Text(
                          folder.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Tahoma',
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
