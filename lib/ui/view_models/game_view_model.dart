import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/hero_model.dart';
import '../../data/models/quest_model.dart';
import '../../data/models/reward_model.dart';
import '../../data/models/activity_log_model.dart';
import '../../data/repositories/game_repository.dart';

class GameViewModel extends ChangeNotifier {
  final GameRepository repository;
  final Uuid _uuid = const Uuid();

  HeroModel _hero = HeroModel.initial();
  List<QuestModel> _quests = [];
  List<RewardModel> _rewards = [];
  List<ActivityLogModel> _logs = [];
  bool _isLoading = true;

  // Event callbacks for UI triggers (like level-up dialogs or alerts)
  String? _lastLevelUpMessage;
  String? get lastLevelUpMessage => _lastLevelUpMessage;

  String? _penaltyAlertMessage;
  String? get penaltyAlertMessage => _penaltyAlertMessage;

  GameViewModel({required this.repository});

  HeroModel get hero => _hero;
  List<QuestModel> get quests => _quests;
  List<RewardModel> get rewards => _rewards;
  List<ActivityLogModel> get logs => _logs;
  bool get isLoading => _isLoading;

  int get completedQuestsCount => _quests.where((q) => q.isCompletedToday).length;
  int get totalQuestsCount => _quests.length;
  double get todayProgress =>
      totalQuestsCount == 0 ? 0 : completedQuestsCount / totalQuestsCount;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    _hero = await repository.loadHero();
    _quests = await repository.loadQuests();
    _rewards = await repository.loadRewards();
    _logs = await repository.loadLogs();

    await _checkDailyRollover();

    _isLoading = false;
    notifyListeners();
  }

  void clearLevelUpMessage() {
    _lastLevelUpMessage = null;
    notifyListeners();
  }

  void clearPenaltyAlert() {
    _penaltyAlertMessage = null;
    notifyListeners();
  }

  Future<void> _checkDailyRollover() async {
    final now = DateTime.now();
    final lastActive = _hero.lastActiveDate;

    final todayStr = DateFormat('yyyy-MM-dd').format(now);
    final lastActiveStr = DateFormat('yyyy-MM-dd').format(lastActive);

    // If it's a new day
    if (todayStr != lastActiveStr) {
      int totalPenaltyDamage = 0;
      int uncompletedCount = 0;

      for (final quest in _quests) {
        if (!quest.isCompletedToday) {
          uncompletedCount++;
          int damage = quest.difficulty.hpPenalty;
          if (_hero.heroClass == HeroClass.paladin) {
            damage = (damage * 0.8).round(); // Paladin 20% damage reduction
          }
          totalPenaltyDamage += damage;
        }
      }

      int newHp = _hero.currentHp - totalPenaltyDamage;

      if (totalPenaltyDamage > 0) {
        if (newHp <= 0) {
          newHp = 50; // revive with 50 HP
          final goldPenalty = (_hero.gold * 0.15).round();
          _hero = _hero.copyWith(
            currentHp: newHp,
            gold: (_hero.gold - goldPenalty).clamp(0, 999999),
          );
          _addLog(
            '💥 Kamu pingsan karena terlalu banyak quest terlewat! Dihidupkan kembali dengan 50 HP dan kehilangan $goldPenalty Gold.',
            ActivityType.damageTaken,
          );
          _penaltyAlertMessage =
              'HP kamu habis karena $uncompletedCount quest belum selesai kemarin! Kamu kehilangan $goldPenalty Gold.';
        } else {
          _hero = _hero.copyWith(currentHp: newHp);
          _addLog(
            '⚠️ Kena serangan -$totalPenaltyDamage HP karena melewatkan $uncompletedCount quest kemarin.',
            ActivityType.damageTaken,
          );
          _penaltyAlertMessage =
              'Kemarin ada $uncompletedCount quest yang terlewat. Kamu terkena -$totalPenaltyDamage HP!';
        }
      }

      // Check streak: Did they complete all or at least 1 quest?
      final hadCompletedAny = _quests.any((q) => q.isCompletedToday);
      final newStreak = hadCompletedAny ? _hero.streakDays + 1 : 1;

      // Reset today's status for quests
      _quests = _quests.map((q) => q.copyWith(isCompletedToday: false)).toList();

      _hero = _hero.copyWith(
        streakDays: newStreak,
        lastActiveDate: now,
      );

      await _saveAll();
    }
  }

  Future<void> completeQuest(String questId) async {
    final index = _quests.indexWhere((q) => q.id == questId);
    if (index == -1) return;

    final quest = _quests[index];
    if (quest.isCompletedToday) return; // Already completed today

    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final newDates = List<String>.from(quest.completedDates)..add(todayStr);

    // Calculate EXP reward (Mage gets +10%)
    int expGained = quest.difficulty.expReward;
    if (_hero.heroClass == HeroClass.mage) {
      expGained = (expGained * 1.1).round();
    }

    // Calculate Gold reward (Rogue gets +15%)
    int goldGained = quest.difficulty.goldReward;
    if (_hero.heroClass == HeroClass.rogue) {
      goldGained = (goldGained * 1.15).round();
    }

    // Update quest
    _quests[index] = quest.copyWith(
      isCompletedToday: true,
      streak: quest.streak + 1,
      completedDates: newDates,
    );

    // Apply EXP & Gold to Hero
    int newExp = _hero.currentExp + expGained;
    int newLevel = _hero.level;
    int currentMaxExp = _hero.maxExp;
    int newHp = _hero.currentHp;
    int newMaxHp = _hero.maxHp;
    int newGold = _hero.gold + goldGained;

    // Check Level Up
    if (newExp >= currentMaxExp) {
      newLevel += 1;
      newExp -= currentMaxExp;
      currentMaxExp = HeroModel.calculateMaxExp(newLevel);
      newMaxHp = HeroModel.calculateMaxHp(newLevel, _hero.heroClass);
      newHp = newMaxHp; // Full heal on level up
      newGold += 35; // Level up bonus gold

      _lastLevelUpMessage =
          'Selamat! Naik ke Level $newLevel!\nHP pulih penuh & dapat bonus 35 Gold!';
      _addLog(
        '🌟 NAIK LEVEL! Pahlawan mencapai Level $newLevel! HP kembali penuh.',
        ActivityType.levelUp,
      );
    }

    _hero = _hero.copyWith(
      level: newLevel,
      currentExp: newExp,
      maxExp: currentMaxExp,
      currentHp: newHp,
      maxHp: newMaxHp,
      gold: newGold,
      totalQuestsCompleted: _hero.totalQuestsCompleted + 1,
    );

    _addLog(
      '⚔️ Selesai: "${quest.title}" (+$expGained EXP, +$goldGained Gold)',
      ActivityType.questComplete,
    );

    notifyListeners();
    await _saveAll();
  }

  Future<void> undoQuest(String questId) async {
    final index = _quests.indexWhere((q) => q.id == questId);
    if (index == -1) return;

    final quest = _quests[index];
    if (!quest.isCompletedToday) return;

    _quests[index] = quest.copyWith(
      isCompletedToday: false,
      streak: (quest.streak - 1).clamp(0, 99999),
    );

    notifyListeners();
    await _saveAll();
  }

  Future<void> addQuest({
    required String title,
    required String description,
    required QuestCategory category,
    required QuestDifficulty difficulty,
  }) async {
    final newQuest = QuestModel(
      id: _uuid.v4(),
      title: title.trim(),
      description: description.trim(),
      category: category,
      difficulty: difficulty,
      createdAt: DateTime.now(),
    );

    _quests.insert(0, newQuest);
    _addLog('📜 Misi Baru Diterima: "${newQuest.title}"', ActivityType.questComplete);

    notifyListeners();
    await repository.saveQuests(_quests);
  }

  Future<void> deleteQuest(String questId) async {
    _quests.removeWhere((q) => q.id == questId);
    notifyListeners();
    await repository.saveQuests(_quests);
  }

  Future<bool> buyReward(RewardModel reward) async {
    if (_hero.gold < reward.costGold) {
      return false;
    }

    final newGold = _hero.gold - reward.costGold;
    int newHp = _hero.currentHp;

    // Special item logic: Health Potion
    if (reward.icon == '🧪') {
      newHp = (_hero.currentHp + 40).clamp(0, _hero.maxHp);
      _hero = _hero.copyWith(gold: newGold, currentHp: newHp);
      _addLog('🧪 Meminum Ramuan HP! Pulih +40 HP.', ActivityType.potionUsed);
    } else {
      _hero = _hero.copyWith(gold: newGold);
      _addLog('🍺 Menukarkan Hadiah: "${reward.title}" seharga ${reward.costGold} Gold.', ActivityType.rewardBought);
    }

    // Update reward purchase counter
    final rIndex = _rewards.indexWhere((r) => r.id == reward.id);
    if (rIndex != -1) {
      _rewards[rIndex] = reward.copyWith(timesRedeemed: reward.timesRedeemed + 1);
    }

    notifyListeners();
    await _saveAll();
    return true;
  }

  Future<void> addCustomReward({
    required String title,
    required String description,
    required int costGold,
    required String icon,
  }) async {
    final newReward = RewardModel(
      id: _uuid.v4(),
      title: title.trim(),
      description: description.trim(),
      costGold: costGold,
      icon: icon.isNotEmpty ? icon : '🎁',
      isDefault: false,
    );

    _rewards.add(newReward);
    notifyListeners();
    await repository.saveRewards(_rewards);
  }

  Future<void> deleteReward(String rewardId) async {
    _rewards.removeWhere((r) => r.id == rewardId);
    notifyListeners();
    await repository.saveRewards(_rewards);
  }

  Future<void> updateHeroProfile({String? name, HeroClass? heroClass}) async {
    _hero = _hero.copyWith(
      name: name ?? _hero.name,
      heroClass: heroClass ?? _hero.heroClass,
      maxHp: heroClass != null
          ? HeroModel.calculateMaxHp(_hero.level, heroClass)
          : _hero.maxHp,
    );
    notifyListeners();
    await repository.saveHero(_hero);
  }

  void _addLog(String message, ActivityType type) {
    final log = ActivityLogModel(
      id: _uuid.v4(),
      message: message,
      type: type,
      timestamp: DateTime.now(),
    );
    _logs.insert(0, log);
    if (_logs.length > 50) {
      _logs = _logs.sublist(0, 50);
    }
    repository.saveLogs(_logs);
  }

  Future<void> _saveAll() async {
    await Future.wait([
      repository.saveHero(_hero),
      repository.saveQuests(_quests),
      repository.saveRewards(_rewards),
      repository.saveLogs(_logs),
    ]);
  }
}

