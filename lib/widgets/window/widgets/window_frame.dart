import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:portfolio/provider/window_manager.dart';

class WindowFrame extends StatefulWidget {
  final String title;
  final Widget child;
  final bool disableMaximize;

  const WindowFrame({
    super.key,
    required this.title,
    required this.child,
    this.disableMaximize = false,
  });

  @override
  _WindowFrameState createState() => _WindowFrameState();
}

class _WindowFrameState extends State<WindowFrame> {
  Offset position = const Offset(100, 100);
  bool isMaximized = false;
  bool isMinimized = false;
  Size? windowSize;

  @override
  void initState() {
    super.initState();
    windowSize = null; // Let it be dynamic based on child
  }

  void _toggleMaximize() {
    final screenSize = MediaQuery.of(context).size;
    setState(() {
      isMaximized = !isMaximized;
      if (isMaximized) {
        position = Offset(0, 0);
        windowSize = Size(screenSize.width, screenSize.height - 40);
      } else {
        position = const Offset(100, 100);
        windowSize = null;
      }
    });
  }

  void _bringToFront() {
    final windowManager = Provider.of<WindowManager>(context, listen: false);
    var matchingWindows =
        windowManager.windows.where((w) => w.title == widget.title);

    if (matchingWindows.isNotEmpty) {
      windowManager.setActiveWindow(matchingWindows.first);
    }
  }

  void _minimizeWindow() {
    final windowManager = Provider.of<WindowManager>(context, listen: false);
    final matchingWindows =
        windowManager.windows.where((w) => w.title == widget.title);

    if (matchingWindows.isNotEmpty) {
      windowManager.minimizeWindow(matchingWindows.first);
      setState(() {
        isMinimized = true;
      });
    }
  }

  void _closeWindow() {
    final windowManager = Provider.of<WindowManager>(context, listen: false);
    final matchingWindows =
        windowManager.windows.where((w) => w.title == widget.title);

    if (matchingWindows.isNotEmpty) {
      windowManager.closeWindow(matchingWindows.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isMinimized) return const SizedBox.shrink();

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onTap: _bringToFront,
        onPanUpdate: (details) {
          if (!isMaximized) {
            setState(() {
              position = Offset(
                  position.dx + details.delta.dx, position.dy + details.delta.dy);
            });
          }
        },
        child: ClipRect(
          child: Container(
            width: windowSize?.width,
            height: windowSize?.height,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: Border.all(
                color: const Color(0xFF1B58B8),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 5,
                  offset: const Offset(3, 3),
                ),
              ],
            ),
            child: IntrinsicWidth(
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🏷️ Title Bar
                    Container(
                      height: 30,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF1B58B8),
                            Color(0xFF3A81DD),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 6),
                          Image.asset(
                            'assets/images/my_computer_icon.png',
                            width: 16,
                            height: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Tahoma',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          _buildXPButton('assets/images/minimize.png', _minimizeWindow),

                          if (!widget.disableMaximize)
                            _buildXPButton('assets/images/maximize.png', _toggleMaximize),

                          _buildXPCloseButton(_closeWindow),
                        ],
                      ),
                    ),

                    // 📄 Window Content
                    Flexible(
                      child: widget.child,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ❌ Close Button
  Widget _buildXPCloseButton(VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/cross.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  // 🔳 XP-Style Button (Minimize / Maximize)
  Widget _buildXPButton(String assetPath, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(assetPath),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
