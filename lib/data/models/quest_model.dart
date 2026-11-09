enum QuestDifficulty {
  easy('Mudah', 20, 8, 8, '🟢'),
  medium('Sedang', 45, 18, 15, '🔵'),
  hard('Sulit', 80, 35, 25, '🟣'),
  epic('Epik', 150, 70, 40, '🔥');

  final String label;
  final int expReward;
  final int goldReward;
  final int hpPenalty;
  final String icon;

  const QuestDifficulty(this.label, this.expReward, this.goldReward, this.hpPenalty, this.icon);
}

enum QuestCategory {
  fitness('Kebugaran', '💪'),
  mind('Pikiran & Belajar', '🧠'),
  health('Kesehatan', '❤️'),
  work('Karier & Koding', '💻'),
  finance('Keuangan', '💰'),
  routine('Rutinitas', '⭐');

  final String label;
  final String icon;
  const QuestCategory(this.label, this.icon);
}

class QuestModel {
  final String id;
  final String title;
  final String description;
  final QuestCategory category;
  final QuestDifficulty difficulty;
  final bool isCompletedToday;
  final int streak;
  final List<String> completedDates; // YYYY-MM-DD
  final DateTime createdAt;

  const QuestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    this.isCompletedToday = false,
    this.streak = 0,
    this.completedDates = const [],
    required this.createdAt,
  });

  QuestModel copyWith({
    String? id,
    String? title,
    String? description,
    QuestCategory? category,
    QuestDifficulty? difficulty,
    bool? isCompletedToday,
    int? streak,
    List<String>? completedDates,
    DateTime? createdAt,
  }) {
    return QuestModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      isCompletedToday: isCompletedToday ?? this.isCompletedToday,
      streak: streak ?? this.streak,
      completedDates: completedDates ?? this.completedDates,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.name,
      'difficulty': difficulty.name,
      'isCompletedToday': isCompletedToday,
      'streak': streak,
      'completedDates': completedDates,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory QuestModel.fromJson(Map<String, dynamic> json) {
    return QuestModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      category: QuestCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => QuestCategory.routine,
      ),
      difficulty: QuestDifficulty.values.firstWhere(
        (e) => e.name == json['difficulty'],
        orElse: () => QuestDifficulty.medium,
      ),
      isCompletedToday: json['isCompletedToday'] as bool? ?? false,
      streak: json['streak'] as int? ?? 0,
      completedDates: (json['completedDates'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

