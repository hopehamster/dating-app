
import 'package:flutter/material.dart';
import '../../questionnaire/presentation/questionnaire_screen.dart';
import '../../matching/presentation/matches_screen.dart';
import '../../inbox/presentation/inbox_screen.dart';
import '../../settings/presentation/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const QuestionnaireScreen(), // Home tab is Question flow
    const InboxScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.quiz),
            label: 'Discover',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat),
            label: 'Inbox',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

