
class ValueDomain {
  final String id;
  final String name;
  final String description;

  const ValueDomain({
    required this.id,
    required this.name,
    required this.description,
  });
}

class DomainScore {
  final String domainId;
  final double score; // 0.0 to 1.0
  final int confidence; // Number of questions answered in this domain

  DomainScore({
    required this.domainId,
    required this.score,
    required this.confidence,
  });
}

class MatchProfile {
  final String userId;
  final String displayName;
  final double compatibilityScore; // 0.0 to 1.0
  final List<String> sharedValues;
  final List<String> frictionPoints;

  MatchProfile({
    required this.userId,
    required this.displayName,
    required this.compatibilityScore,
    required this.sharedValues,
    required this.frictionPoints,
  });
}

