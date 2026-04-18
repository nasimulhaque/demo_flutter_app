import 'package:flutter/material.dart';

import '../login_screen_getx.dart';
import '../login_screen_provider.dart';
import '../login_screen_setstate.dart';
import '../widgets/animated_button.dart';
import '../widgets/responsive_grid.dart';
import '../widgets/stack_profile_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Portfolio'),
        centerTitle: true,
        elevation: 0,
        actions: [
          // Responsive: show more actions on larger screens
          if (isTablet) ...[
            TextButton.icon(
              onPressed: () => _showLoginOptions(context),
              icon: const Icon(Icons.login),
              label: const Text('Login Demo'),
            ),
            const SizedBox(width: 8),
          ],
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
          ),
        ],
      ),
      body: ResponsiveGrid(
        children: [
          // Section 1: Stack Widget Demo
          _buildSectionCard(
            context,
            title: 'Stack Widget Demo',
            subtitle: 'Overlapping UI elements',
            child: const StackProfileCard(),
          ),

          // Section 2: Animated Button Demo
          _buildSectionCard(
            context,
            title: 'Animated Components',
            subtitle: 'Tap to see animations',
            child: const AnimatedButtonDemo(),
          ),

          // Section 3: Login Options
          _buildSectionCard(
            context,
            title: 'State Management Login',
            subtitle: 'Compare Provider vs GetX vs setState',
            child: Column(
              children: [
                _buildLoginOptionButton(
                  context,
                  title: 'setState Approach',
                  subtitle: 'Traditional StatefulWidget',
                  icon: Icons.code,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreenSetState()),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildLoginOptionButton(
                  context,
                  title: 'Provider Approach',
                  subtitle: 'ChangeNotifier + Provider',
                  icon: Icons.share,
                  color: Colors.teal,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreenProvider()),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildLoginOptionButton(
                  context,
                  title: 'GetX Approach',
                  subtitle: 'Reactive state management',
                  icon: Icons.trending_up,
                  color: Colors.purple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreenGetX()),
                    );
                  },
                ),
              ],
            ),
          ),

          // Section 4: UI Components Demo
          _buildSectionCard(
            context,
            title: 'UI Components',
            subtitle: 'Bottom sheets, dialogs, snackbars',
            child: Column(
              children: [
                _buildActionButton(
                  context,
                  title: 'Show Bottom Sheet',
                  icon: Icons.view_headline,
                  onTap: () => _showBottomSheet(context),
                ),
                const SizedBox(height: 8),
                _buildActionButton(
                  context,
                  title: 'Show Custom Dialog',
                  icon: Icons.chat_bubble_outline,
                  onTap: () => _showCustomDialog(context),
                ),
                const SizedBox(height: 8),
                _buildActionButton(
                  context,
                  title: 'Show Snackbar',
                  icon: Icons.message,
                  onTap: () => _showSnackbar(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, {
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildLoginOptionButton(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: color),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  void _showLoginOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose Login Method',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildLoginOptionButton(
              context,
              title: 'setState',
              subtitle: 'Traditional approach',
              icon: Icons.code,
              color: Colors.blue,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreenSetState())),
            ),
            const SizedBox(height: 10),
            _buildLoginOptionButton(
              context,
              title: 'Provider',
              subtitle: 'Modern state management',
              icon: Icons.share,
              color: Colors.teal,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreenProvider())),
            ),
            const SizedBox(height: 10),
            _buildLoginOptionButton(
              context,
              title: 'GetX',
              subtitle: 'Reactive framework',
              icon: Icons.trending_up,
              color: Colors.purple,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreenGetX())),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About This Demo'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Responsive Design with MediaQuery'),
            Text('• Stack Widget for overlapping UI'),
            Text('• Animated Components'),
            Text('• 3 State Management Approaches'),
            Text('• Custom Dialogs & Bottom Sheets'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Responsive Bottom Sheet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('This bottom sheet adapts to screen size automatically.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, size: 50, color: Colors.amber),
              const SizedBox(height: 10),
              const Text(
                'Custom Dialog',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text('This is a fully customizable dialog with Stack effects!'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('You can customize this snackbar!'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {},
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}