import 'package:flutter/material.dart';
import 'package:portfolio/models/desktop_icon.dart';
import 'package:portfolio/provider/window_manager.dart';
import 'package:portfolio/widgets/desktop/clippy.dart';
import 'package:portfolio/widgets/desktop/desktop_icons.dart';
import 'package:portfolio/widgets/window/my_computer/my_computer.dart';
import 'package:portfolio/widgets/window/widgets/window_frame.dart';
import 'package:portfolio/widgets/taskbar/taskbar.dart';
import 'package:portfolio/widgets/start_menu/start_menu.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // 👈 Added this

class Desktop extends StatefulWidget {
  const Desktop({super.key});

  @override
  _DesktopState createState() => _DesktopState();
}

class _DesktopState extends State<Desktop> {
  bool isStartMenuOpen = false;

  void _toggleStartMenu() {
    setState(() {
      isStartMenuOpen = !isStartMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final windowManager = Provider.of<WindowManager>(context);

    List<Window> nonMinimizedWindows =
        windowManager.windows.where((w) => !w.isMinimized).toList();

    // Ensure active window appears last
    nonMinimizedWindows
        .sort((a, b) => a == windowManager.activeWindow ? 1 : -1);

    return Material(
      child: Stack(
        children: [
          // 🌄 XP Desktop Background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/windows_bg.webp'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // 🖥 Desktop Icons
          DesktopIcons(
            icons: [
              DesktopIconData(
                title: 'My Computer',
                iconPath: 'assets/images/my_computer_icon.png',
                onOpen: () {
                  windowManager.openWindow("My Computer", const MyComputer());
                },
              ),
              DesktopIconData(
                title: 'Resume',
                iconPath: 'assets/images/txt_icon.png',
                onOpen: () async {
                  const resumeUrl = 'https://drive.google.com/file/d/1LyTXI2RBLj2gXcpcy4Mn_W3kEG3aEaAR/view?usp=sharing'; // 🔗 Replace this
                  final uri = Uri.parse(resumeUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    debugPrint('Could not launch $resumeUrl');
                  }
                },
              ),
            ],
          ),

          Clippy(),

          // 🗂 Windows (non-minimized)
          for (var window in nonMinimizedWindows)
            WindowFrame(
              key: ValueKey(window.title),
              title: window.title,
              child: window.child,
              disableMaximize: _shouldDisableMaximize(window.title),
            ),

          // 🟢 Start Menu
          if (isStartMenuOpen)
            StartMenu(
              onOpenFolder: (title, content) {
                windowManager.openWindow(title, content);
                _toggleStartMenu();
              },
            ),

          // 📌 Taskbar
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: Taskbar(
              onStartPressed: _toggleStartMenu,
              windows: windowManager.windows,
              onRestoreWindow: windowManager.restoreWindow,
              activeWindow: windowManager.activeWindow,
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldDisableMaximize(String title) {
    const disabled = {
      'Experience',
      'Education',
      'Contact Me',
    };
    return disabled.contains(title);
  }
}
