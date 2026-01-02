
import 'package:flutter/material.dart';
import '../../chat/presentation/chat_screen.dart';
import '../../chat/repository/chat_repository.dart';
import '../../matching/domain/matching_model.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for inbox threads
    final mockThreads = [
      MatchProfile(
        userId: 'user_2',
        displayName: 'Alex',
        compatibilityScore: 0.85,
        sharedValues: ['Honesty', 'Financial Independence'],
        frictionPoints: [],
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Inbox')),
      body: ListView.builder(
        itemCount: mockThreads.length,
        itemBuilder: (context, index) {
          final profile = mockThreads[index];
          return ListTile(
            leading: CircleAvatar(child: Text(profile.displayName[0])),
            title: Text(profile.displayName),
            subtitle: const Text('Tap to chat'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    matchProfile: profile,
                    currentUserId: 'current_user_id',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

