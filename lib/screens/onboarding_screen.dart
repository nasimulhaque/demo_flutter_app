import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splash_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Responsive Design',
      description: 'Beautiful layouts that adapt to any screen size - phone, tablet, or desktop.',
      icon: Icons.phone_android,
      color: Colors.teal,
    ),
    OnboardingData(
      title: 'Stack Widget Mastery',
      description: 'Create overlapping UI elements with precise positioning using Stack and Positioned.',
      icon: Icons.layers,
      color: Colors.blue,
    ),
    OnboardingData(
      title: 'State Management',
      description: 'Compare Provider and GetX approaches for login authentication.',
      icon: Icons.account_circle,
      color: Colors.orange,
    ),
    OnboardingData(
      title: 'Get Started',
      description: 'Explore all the features and build amazing apps!',
      icon: Icons.rocket_launch,
      color: Colors.purple,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.teal.shade50, Colors.white],
              ),
            ),
          ),

          // PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return OnboardingPage(data: _pages[index]);
            },
          ),

          // Bottom navigation
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: _currentPage == index ? 30 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.teal : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),

          // Skip/Next buttons
          Positioned(
            bottom: 30,
            right: 20,
            child: TextButton(
              onPressed: () {
                if (_currentPage == _pages.length - 1) {
                  _completeOnboarding();
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: Text(
                _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                style: const TextStyle(
                  color: Colors.teal,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SplashScreen()),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated icon container with Stack effect
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: data.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: data.color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: data.color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: data.color.withOpacity(0.5),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  data.icon,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            data.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}