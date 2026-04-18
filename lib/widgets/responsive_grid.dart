import 'package:flutter/material.dart';

class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;

  const ResponsiveGrid({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = _getCrossAxisCount(screenWidth);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: _getAspectRatio(screenWidth),
        ),
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
      ),
    );
  }

  int _getCrossAxisCount(double width) {
    if (width > 1200) return 3;      // Desktop
    if (width > 800) return 2;        // Tablet
    return 1;                          // Mobile
  }

  double _getAspectRatio(double width) {
    if (width > 1200) return 1.2;
    if (width > 800) return 1.1;
    return 1.0;
  }
}