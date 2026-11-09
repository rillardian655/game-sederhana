enum ActivityType {
  questComplete('Selesai Quest', '⚔️'),
  levelUp('Level Naik!', '🌟'),
  damageTaken('Kena Serangan (Penalty)', '💥'),
  rewardBought('Beli Hadiah', '🍺'),
  potionUsed('Minum Ramuan HP', '🧪');

  final String label;
  final String icon;
  const ActivityType(this.label, this.icon);
}

class ActivityLogModel {
  final String id;
  final String message;
  final ActivityType type;
  final DateTime timestamp;

  const ActivityLogModel({
    required this.id,
    required this.message,
    required this.type,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogModel(
      id: json['id'] as String,
      message: json['message'] as String,
      type: ActivityType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ActivityType.questComplete,
      ),
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

