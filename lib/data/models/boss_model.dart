class BossModel {
  final String id;
  final String name;
  final String subtitle;
  final String avatar;
  final int maxHp;
  final int currentHp;
  final int rewardExp;
  final int rewardGold;
  final bool isDefeated;
  final int bossLevel;
  final String description;

  const BossModel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.avatar,
    required this.maxHp,
    required this.currentHp,
    required this.rewardExp,
    required this.rewardGold,
    this.isDefeated = false,
    required this.bossLevel,
    required this.description,
  });

  BossModel copyWith({
    String? id,
    String? name,
    String? subtitle,
    String? avatar,
    int? maxHp,
    int? currentHp,
    int? rewardExp,
    int? rewardGold,
    bool? isDefeated,
    int? bossLevel,
    String? description,
  }) {
    return BossModel(
      id: id ?? this.id,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      avatar: avatar ?? this.avatar,
      maxHp: maxHp ?? this.maxHp,
      currentHp: currentHp ?? this.currentHp,
      rewardExp: rewardExp ?? this.rewardExp,
      rewardGold: rewardGold ?? this.rewardGold,
      isDefeated: isDefeated ?? this.isDefeated,
      bossLevel: bossLevel ?? this.bossLevel,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subtitle': subtitle,
      'avatar': avatar,
      'maxHp': maxHp,
      'currentHp': currentHp,
      'rewardExp': rewardExp,
      'rewardGold': rewardGold,
      'isDefeated': isDefeated,
      'bossLevel': bossLevel,
      'description': description,
    };
  }

  factory BossModel.fromJson(Map<String, dynamic> json) {
    return BossModel(
      id: json['id'] as String,
      name: json['name'] as String,
      subtitle: json['subtitle'] as String,
      avatar: json['avatar'] as String,
      maxHp: json['maxHp'] as int,
      currentHp: json['currentHp'] as int,
      rewardExp: json['rewardExp'] as int,
      rewardGold: json['rewardGold'] as int,
      isDefeated: json['isDefeated'] as bool? ?? false,
      bossLevel: json['bossLevel'] as int,
      description: json['description'] as String,
    );
  }
}

