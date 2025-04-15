class Chemical {
  final String name;
  final String usageGuidelines;
  final String safetyRating;
  final String soilImpact;
  final List<String> compatibleCrops;
  final String status; // e.g., "Allowed", "Banned", "Restricted"

  Chemical({
    required this.name,
    required this.usageGuidelines,
    required this.safetyRating,
    required this.soilImpact,
    required this.compatibleCrops,
    required this.status,
  });

  factory Chemical.fromMap(Map<String, dynamic> map) {
    return Chemical(
      name: map['name'],
      usageGuidelines: map['usageGuidelines'],
      safetyRating: map['safetyRating'],
      soilImpact: map['soilImpact'],
      compatibleCrops: List<String>.from(map['compatibleCrops']),
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'usageGuidelines': usageGuidelines,
      'safetyRating': safetyRating,
      'soilImpact': soilImpact,
      'compatibleCrops': compatibleCrops,
      'status': status,
    };
  }
}
