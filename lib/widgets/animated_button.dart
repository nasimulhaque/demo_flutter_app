import 'package:flutter/material.dart';

class AnimatedButtonDemo extends StatefulWidget {
  const AnimatedButtonDemo({super.key});

  @override
  State<AnimatedButtonDemo> createState() => _AnimatedButtonDemoState();
}

class _AnimatedButtonDemoState extends State<AnimatedButtonDemo> {
  bool _isExpanded = false;
  bool _isLiked = false;
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Animated Container
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            width: _isExpanded ? 200 : 100,
            height: _isExpanded ? 80 : 50,
            decoration: BoxDecoration(
              color: _isExpanded ? Colors.teal : Colors.blue,
              borderRadius: BorderRadius.circular(_isExpanded ? 20 : 25),
              boxShadow: [
                BoxShadow(
                  color: (_isExpanded ? Colors.teal : Colors.blue).withOpacity(0.5),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Text(
                _isExpanded ? 'Tap to shrink!' : 'Tap to expand!',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Animated Like Button
        GestureDetector(
          onTap: () {
            setState(() {
              _isLiked = !_isLiked;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.elasticOut,
            transform: Matrix4.identity()..scale(_isLiked ? 1.2 : 1.0),
            child: Icon(
              _isLiked ? Icons.favorite : Icons.favorite_border,
              size: 50,
              color: _isLiked ? Colors.red : Colors.grey,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Scale Animation on Hover (tap for demo)
        GestureDetector(
          onTapDown: (_) => setState(() => _scale = 0.95),
          onTapUp: (_) => setState(() => _scale = 1.0),
          onTapCancel: () => setState(() => _scale = 1.0),
          child: AnimatedScale(
            duration: const Duration(milliseconds: 100),
            scale: _scale,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Press Me (Scale Effect)'),
            ),
          ),
        ),
      ],
    );
  }
}