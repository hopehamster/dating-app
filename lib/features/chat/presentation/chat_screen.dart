
import 'package:flutter/material.dart';
import '../../matching/domain/matching_model.dart';
import '../domain/chat_model.dart';
import '../repository/chat_repository.dart';

class ChatScreen extends StatefulWidget {
  final MatchProfile matchProfile;
  final String currentUserId;

  const ChatScreen({
    super.key,
    required this.matchProfile,
    required this.currentUserId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatRepository _repository = ChatRepository();
  final TextEditingController _messageController = TextEditingController();
  final String _threadId = 'mock_thread_id'; // In real app, derived from match ID

  String? _aiReport;
  List<String> _iceBreakers = [];
  bool _isLoadingAI = false;

  @override
  void initState() {
    super.initState();
    _loadAIContent();
  }

  Future<void> _loadAIContent() async {
    setState(() => _isLoadingAI = true);
    
    // Parallel fetch
    final results = await Future.wait([
      _repository.getMatchReport(
        userAName: 'You',
        userBName: widget.matchProfile.displayName,
        sharedValues: widget.matchProfile.sharedValues,
        frictionPoints: widget.matchProfile.frictionPoints,
      ),
      _repository.getIceBreakers(widget.matchProfile.sharedValues),
    ]);

    if (mounted) {
      setState(() {
        _aiReport = results[0] as String;
        _iceBreakers = results[1] as List<String>;
        _isLoadingAI = false;
      });
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    _repository.sendMessage(_threadId, widget.currentUserId, _messageController.text.trim());
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.matchProfile.displayName),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showMatchDetails(context),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isLoadingAI)
            const LinearProgressIndicator()
          else if (_aiReport != null)
            ExpansionTile(
              title: const Text('💘 AI Compatibility Insight', style: TextStyle(fontWeight: FontWeight.bold)),
              leading: const Icon(Icons.auto_awesome, color: Colors.purple),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(_aiReport!),
                ),
                if (_iceBreakers.isNotEmpty) ...[
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Try asking:', style: Theme.of(context).textTheme.labelLarge),
                  ),
                  Wrap(
                    spacing: 8,
                    children: _iceBreakers.map((q) => ActionChip(
                      label: Text(q),
                      onPressed: () {
                        _messageController.text = q;
                      },
                    )).toList(),
                  ),
                ],
              ],
            ),
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: _repository.getMessages(_threadId),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                final messages = snapshot.data!;
                if (messages.isEmpty) {
                  return const Center(child: Text('Say hello!'));
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == widget.currentUserId;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.deepPurple : Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          msg.content,
                          style: TextStyle(color: isMe ? Colors.white : Colors.black),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMatchDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Shared Values', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: widget.matchProfile.sharedValues.map((v) => Chip(label: Text(v))).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

