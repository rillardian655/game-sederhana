enum HeroClass {
  warrior('Warrior', '⚔️', 'Kekuatan fisik & pertahanan tinggi. Bonus HP max.'),
  mage('Mage', '🧙‍♂️', 'Penguasa ilmu & konsentrasi. Bonus EXP 10%.'),
  rogue('Rogue', '🗡️', 'Cepat & penuh taktik. Bonus Gold 15%.'),
  paladin('Paladin', '🛡️', 'Pelindung kebiasaan suci. Pengurangan damage 20%.');

  final String title;
  final String icon;
  final String perk;
  const HeroClass(this.title, this.icon, this.perk);
}

class HeroModel {
  final String name;
  final HeroClass heroClass;
  final int level;
  final int currentExp;
  final int maxExp;
  final int currentHp;
  final int maxHp;
  final int gold;
  final int totalQuestsCompleted;
  final int streakDays;
  final DateTime lastActiveDate;

  const HeroModel({
    required this.name,
    required this.heroClass,
    required this.level,
    required this.currentExp,
    required this.maxExp,
    required this.currentHp,
    required this.maxHp,
    required this.gold,
    required this.totalQuestsCompleted,
    required this.streakDays,
    required this.lastActiveDate,
  });

  factory HeroModel.initial() {
    return HeroModel(
      name: 'Adventurer',
      heroClass: HeroClass.warrior,
      level: 1,
      currentExp: 0,
      maxExp: 100,
      currentHp: 100,
      maxHp: 100,
      gold: 50,
      totalQuestsCompleted: 0,
      streakDays: 1,
      lastActiveDate: DateTime.now(),
    );
  }

  static int calculateMaxExp(int lvl) {
    return (lvl * 100) + ((lvl - 1) * 35);
  }

  static int calculateMaxHp(int lvl, HeroClass hClass) {
    final base = 100 + ((lvl - 1) * 15);
    return hClass == HeroClass.warrior ? base + 25 : base;
  }

  HeroModel copyWith({
    String? name,
    HeroClass? heroClass,
    int? level,
    int? currentExp,
    int? maxExp,
    int? currentHp,
    int? maxHp,
    int? gold,
    int? totalQuestsCompleted,
    int? streakDays,
    DateTime? lastActiveDate,
  }) {
    return HeroModel(
      name: name ?? this.name,
      heroClass: heroClass ?? this.heroClass,
      level: level ?? this.level,
      currentExp: currentExp ?? this.currentExp,
      maxExp: maxExp ?? this.maxExp,
      currentHp: currentHp ?? this.currentHp,
      maxHp: maxHp ?? this.maxHp,
      gold: gold ?? this.gold,
      totalQuestsCompleted: totalQuestsCompleted ?? this.totalQuestsCompleted,
      streakDays: streakDays ?? this.streakDays,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'heroClass': heroClass.name,
      'level': level,
      'currentExp': currentExp,
      'maxExp': maxExp,
      'currentHp': currentHp,
      'maxHp': maxHp,
      'gold': gold,
      'totalQuestsCompleted': totalQuestsCompleted,
      'streakDays': streakDays,
      'lastActiveDate': lastActiveDate.toIso8601String(),
    };
  }

  factory HeroModel.fromJson(Map<String, dynamic> json) {
    final hClass = HeroClass.values.firstWhere(
      (e) => e.name == json['heroClass'],
      orElse: () => HeroClass.warrior,
    );
    return HeroModel(
      name: json['name'] as String? ?? 'Adventurer',
      heroClass: hClass,
      level: json['level'] as int? ?? 1,
      currentExp: json['currentExp'] as int? ?? 0,
      maxExp: json['maxExp'] as int? ?? 100,
      currentHp: json['currentHp'] as int? ?? 100,
      maxHp: json['maxHp'] as int? ?? 100,
      gold: json['gold'] as int? ?? 50,
      totalQuestsCompleted: json['totalQuestsCompleted'] as int? ?? 0,
      streakDays: json['streakDays'] as int? ?? 1,
      lastActiveDate: json['lastActiveDate'] != null
          ? DateTime.tryParse(json['lastActiveDate'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

