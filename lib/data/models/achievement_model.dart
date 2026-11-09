class AchievementModel {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int rewardExp;
  final int rewardGold;
  final bool isUnlocked;
  final bool isClaimed;

  const AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.rewardExp,
    required this.rewardGold,
    this.isUnlocked = false,
    this.isClaimed = false,
  });

  AchievementModel copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    int? rewardExp,
    int? rewardGold,
    bool? isUnlocked,
    bool? isClaimed,
  }) {
    return AchievementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      rewardExp: rewardExp ?? this.rewardExp,
      rewardGold: rewardGold ?? this.rewardGold,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isClaimed: isClaimed ?? this.isClaimed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'rewardExp': rewardExp,
      'rewardGold': rewardGold,
      'isUnlocked': isUnlocked,
      'isClaimed': isClaimed,
    };
  }

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String? ?? '🏆',
      rewardExp: json['rewardExp'] as int? ?? 50,
      rewardGold: json['rewardGold'] as int? ?? 25,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      isClaimed: json['isClaimed'] as bool? ?? false,
    );
  }
}

