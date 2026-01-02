
import 'package:flutter/material.dart';
import '../../chat/presentation/chat_screen.dart';
import '../domain/matching_model.dart';
import '../repository/matching_repository.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  final MatchingRepository _repository = MatchingRepository();
  List<MatchProfile> _matches = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    final matches = await _repository.getMatches('current_user_id');
    setState(() {
      _matches = matches;
      _isLoading = false;
    });
  }

  void _handleAccept(MatchProfile match) {
    _repository.acceptMatch(match.userId);
    // Navigate to Chat directly for demo purposes
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          matchProfile: match,
          currentUserId: 'current_user_id', // Mock ID
        ),
      ),
    );
  }

  void _handleReject(MatchProfile match) {
    _repository.rejectMatch(match.userId);
    setState(() {
      _matches.remove(match);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_matches.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Your Matches')),
        body: const Center(child: Text('No more matches for now. Check back later!')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Your Matches')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _matches.length,
        itemBuilder: (context, index) {
          final match = _matches[index];
          return _buildMatchCard(match);
        },
      ),
    );
  }

  Widget _buildMatchCard(MatchProfile match) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  match.displayName,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${(match.compatibilityScore * 100).round()}% Match',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Shared Values:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              children: match.sharedValues
                  .map((v) => Chip(label: Text(v, style: const TextStyle(fontSize: 12))))
                  .toList(),
            ),
            if (match.frictionPoints.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'Potential Friction:',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                children: match.frictionPoints
                    .map((v) => Chip(
                          label: Text(v, style: const TextStyle(fontSize: 12)),
                          backgroundColor: Colors.orange.withOpacity(0.1),
                        ))
                    .toList(),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton.filled(
                  onPressed: () => _handleReject(match),
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(backgroundColor: Colors.grey[200]),
                  iconSize: 32,
                ),
                IconButton.filled(
                  onPressed: () => _handleAccept(match),
                  icon: const Icon(Icons.favorite),
                  style: IconButton.styleFrom(backgroundColor: Colors.pink[100], foregroundColor: Colors.pink),
                  iconSize: 32,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

