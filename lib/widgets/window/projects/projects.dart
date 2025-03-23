import 'package:flutter/material.dart';

class ProjectsExplorer extends StatelessWidget {
  final List<Map<String, String>> projects;

  const ProjectsExplorer({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 510,
      width: 700,
      child: Column(
        children: [
          // Optional XP Toolbar (you can uncomment if needed)
          // _buildToolbar(),

          Expanded(
            child: Row(
              children: [
                // Optional XP Sidebar (you can uncomment if needed)
                // _buildSidebar(),

                // 📁 Right Content (Responsive Grid of Projects)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        const double iconWidth = 100;
                        int crossAxisCount = (constraints.maxWidth / iconWidth).floor().clamp(1, projects.length);

                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                          ),
                          itemCount: projects.length,
                          itemBuilder: (context, index) {
                            return _buildProjectItem(
                              projects[index]['title']!,
                              projects[index]['icon']!,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔵 Windows XP Toolbar (optional)
  Widget _buildToolbar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF3A81DD),
        border: Border(bottom: BorderSide(color: Colors.grey.shade400)),
      ),
      child: Row(
        children: [
          _toolbarButton('assets/images/back.png'),
          _toolbarButton('assets/images/forward.png'),
          _toolbarButton('assets/images/search.png'),
          const Spacer(),
          const Text(
            "My Projects",
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  Widget _toolbarButton(String iconPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Image.asset(iconPath, width: 30, height: 30),
    );
  }

  // 📌 XP Sidebar (optional)
  Widget _buildSidebar() {
    return Container(
      width: 150,
      color: const Color(0xFFE3F2FD),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sidebarItem('assets/images/folder_icon.png', 'New Folder'),
          _sidebarItem('assets/images/refresh.png', 'Refresh'),
          _sidebarItem('assets/images/delete.png', 'Delete'),
          _sidebarItem('assets/images/properties.png', 'Properties'),
        ],
      ),
    );
  }

  Widget _sidebarItem(String iconPath, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Image.asset(iconPath, width: 20, height: 20),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // 📁 Project Item (icon + title)
  Widget _buildProjectItem(String title, String iconPath) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(iconPath, width: 50, height: 50),
        const SizedBox(height: 5),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
