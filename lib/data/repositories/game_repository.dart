import 'package:uuid/uuid.dart';
import '../models/hero_model.dart';
import '../models/quest_model.dart';
import '../models/reward_model.dart';
import '../models/activity_log_model.dart';
import '../models/achievement_model.dart';
import '../services/storage_service.dart';

class GameRepository {
  final StorageService storageService;
  final Uuid _uuid = const Uuid();

  GameRepository({required this.storageService});

  Future<HeroModel> loadHero() async {
    final data = storageService.getHero();
    if (data == null) {
      final initialHero = HeroModel.initial();
      await saveHero(initialHero);
      return initialHero;
    }
    return HeroModel.fromJson(data);
  }

  Future<void> saveHero(HeroModel hero) async {
    await storageService.saveHero(hero.toJson());
  }

  Future<List<QuestModel>> loadQuests() async {
    final list = storageService.getQuests();
    if (list.isEmpty) {
      final seedQuests = [
        QuestModel(
          id: _uuid.v4(),
          title: 'Minum 2 Liter Air Bersih',
          description: 'Jaga hidrasi tubuh sepanjang hari untuk stamina maksimal.',
          category: QuestCategory.health,
          difficulty: QuestDifficulty.easy,
          createdAt: DateTime.now(),
        ),
        QuestModel(
          id: _uuid.v4(),
          title: 'Belajar Koding / Baca Buku 30 Menit',
          description: 'Tingkatkan skill logika dan konsentrasi pahlawan.',
          category: QuestCategory.work,
          difficulty: QuestDifficulty.medium,
          createdAt: DateTime.now(),
        ),
        QuestModel(
          id: _uuid.v4(),
          title: 'Workout / Olahraga Ringan 15 Menit',
          description: 'Push-up, jogging, atau stretching untuk memperkuat fisik.',
          category: QuestCategory.fitness,
          difficulty: QuestDifficulty.hard,
          createdAt: DateTime.now(),
        ),
        QuestModel(
          id: _uuid.v4(),
          title: 'Rapikan Tempat Tidur & Meja Kerja',
          description: 'Mulai pagi hari dengan lingkungan yang teratur.',
          category: QuestCategory.routine,
          difficulty: QuestDifficulty.easy,
          createdAt: DateTime.now(),
        ),
      ];
      await saveQuests(seedQuests);
      return seedQuests;
    }
    return list.map((e) => QuestModel.fromJson(e)).toList();
  }

  Future<void> saveQuests(List<QuestModel> quests) async {
    await storageService.saveQuests(quests.map((q) => q.toJson()).toList());
  }

  Future<List<RewardModel>> loadRewards() async {
    final list = storageService.getRewards();
    if (list.isEmpty) {
      final seedRewards = [
        RewardModel(
          id: _uuid.v4(),
          title: 'Ramuan HP (+40 Darah)',
          description: 'Pulihkan 40 Health Points setelah lelah beraktivitas.',
          costGold: 25,
          icon: '🧪',
          isDefault: true,
        ),
        RewardModel(
          id: _uuid.v4(),
          title: 'Beli Kopi / Minuman Favorit',
          description: 'Hadiah istimewa pelepas penat setelah menyelesaikan quest.',
          costGold: 40,
          icon: '☕',
          isDefault: true,
        ),
        RewardModel(
          id: _uuid.v4(),
          title: 'Nonton 1 Episode Series / Anime',
          description: 'Waktu santai tanpa rasa bersalah.',
          costGold: 50,
          icon: '🎬',
          isDefault: true,
        ),
        RewardModel(
          id: _uuid.v4(),
          title: 'Main Game Bebas 1 Jam',
          description: 'Waktu refreshing bermain game kesukaan.',
          costGold: 75,
          icon: '🎮',
          isDefault: true,
        ),
      ];
      await saveRewards(seedRewards);
      return seedRewards;
    }
    return list.map((e) => RewardModel.fromJson(e)).toList();
  }

  Future<void> saveRewards(List<RewardModel> rewards) async {
    await storageService.saveRewards(rewards.map((r) => r.toJson()).toList());
  }

  Future<List<ActivityLogModel>> loadLogs() async {
    final list = storageService.getLogs();
    if (list.isEmpty) {
      final initialLog = [
        ActivityLogModel(
          id: _uuid.v4(),
          message: 'Petualangan dimulai! Selamat datang di HabitQuest.',
          type: ActivityType.questComplete,
          timestamp: DateTime.now(),
        ),
      ];
      await saveLogs(initialLog);
      return initialLog;
    }
    return list.map((e) => ActivityLogModel.fromJson(e)).toList();
  }

  Future<void> saveLogs(List<ActivityLogModel> logs) async {
    // Keep last 50 logs only
    final trimmed = logs.take(50).map((l) => l.toJson()).toList();
    await storageService.saveLogs(trimmed);
  }

  Future<List<AchievementModel>> loadAchievements() async {
    final list = storageService.getAchievements();
    if (list.isEmpty) {
      final defaultAchievements = [
        const AchievementModel(
          id: 'first_quest',
          title: 'Langkah Pertama',
          description: 'Selesaikan misi petualangan pertamamu.',
          icon: '🥉',
          rewardExp: 30,
          rewardGold: 15,
        ),
        const AchievementModel(
          id: 'trio_quests',
          title: 'Trio Disiplin',
          description: 'Selesaikan minimal 3 misi dalam 1 hari.',
          icon: '🥈',
          rewardExp: 50,
          rewardGold: 25,
        ),
        const AchievementModel(
          id: 'streak_3',
          title: 'Konsistensi Baja',
          description: 'Capai rekor 3 hari streak berturut-turut.',
          icon: '🥇',
          rewardExp: 100,
          rewardGold: 50,
        ),
        const AchievementModel(
          id: 'level_3',
          title: 'Ksatria Tangguh',
          description: 'Tingkatkan level pahlawanmu hingga Level 3.',
          icon: '👑',
          rewardExp: 150,
          rewardGold: 75,
        ),
        const AchievementModel(
          id: 'first_reward',
          title: 'Pelanggan Kedai',
          description: 'Tukarkan hadiah pertamamu di kedai.',
          icon: '🍺',
          rewardExp: 40,
          rewardGold: 20,
        ),
        const AchievementModel(
          id: 'rich_hero',
          title: 'Juragan Koin',
          description: 'Kumpulkan total simpanan minimal 150 Gold.',
          icon: '💰',
          rewardExp: 60,
          rewardGold: 30,
        ),
      ];
      await saveAchievements(defaultAchievements);
      return defaultAchievements;
    }
    return list.map((e) => AchievementModel.fromJson(e)).toList();
  }

  Future<void> saveAchievements(List<AchievementModel> achievements) async {
    await storageService.saveAchievements(achievements.map((a) => a.toJson()).toList());
  }
}

