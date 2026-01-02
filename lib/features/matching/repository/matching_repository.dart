
import '../domain/matching_model.dart';

class MatchingRepository {
  // Mock data for profiles to match against
  final List<MatchProfile> _mockMatches = [
    MatchProfile(
      userId: 'user_2',
      displayName: 'Alex',
      compatibilityScore: 0.85,
      sharedValues: ['Honesty', 'Financial Independence'],
      frictionPoints: ['Work-Life Balance'],
    ),
    MatchProfile(
      userId: 'user_3',
      displayName: 'Jordan',
      compatibilityScore: 0.72,
      sharedValues: ['Ambition', 'Health'],
      frictionPoints: ['Communication Style'],
    ),
    MatchProfile(
      userId: 'user_4',
      displayName: 'Taylor',
      compatibilityScore: 0.91,
      sharedValues: ['Family', 'Loyalty', 'Empathy'],
      frictionPoints: [],
    ),
  ];

  Future<List<MatchProfile>> getMatches(String userId) async {
    // Simulate network delay and calculation
    await Future.delayed(const Duration(seconds: 1));
    
    // In a real implementation, this would query Data Connect or Cloud Functions
    // to find users with high overlap in DomainScores.
    return _mockMatches;
  }

  Future<void> acceptMatch(String matchUserId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    print('Accepted match with $matchUserId');
  }

  Future<void> rejectMatch(String matchUserId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    print('Rejected match with $matchUserId');
  }
}

