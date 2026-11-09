class RewardModel {
  final String id;
  final String title;
  final String description;
  final int costGold;
  final String icon;
  final int timesRedeemed;
  final bool isDefault;

  const RewardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.costGold,
    required this.icon,
    this.timesRedeemed = 0,
    this.isDefault = false,
  });

  RewardModel copyWith({
    String? id,
    String? title,
    String? description,
    int? costGold,
    String? icon,
    int? timesRedeemed,
    bool? isDefault,
  }) {
    return RewardModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      costGold: costGold ?? this.costGold,
      icon: icon ?? this.icon,
      timesRedeemed: timesRedeemed ?? this.timesRedeemed,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'costGold': costGold,
      'icon': icon,
      'timesRedeemed': timesRedeemed,
      'isDefault': isDefault,
    };
  }

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      costGold: json['costGold'] as int? ?? 20,
      icon: json['icon'] as String? ?? '🎁',
      timesRedeemed: json['timesRedeemed'] as int? ?? 0,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }
}

