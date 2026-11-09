import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:habit_quest/data/models/hero_model.dart';
import 'package:habit_quest/data/services/storage_service.dart';
import 'package:habit_quest/data/repositories/game_repository.dart';
import 'package:habit_quest/ui/view_models/game_view_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HabitQuest Core Logic Tests', () {
    late StorageService storageService;
    late GameRepository repository;
    late GameViewModel viewModel;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      storageService = StorageService(prefs);
      repository = GameRepository(storageService: storageService);
      viewModel = GameViewModel(repository: repository);
      await viewModel.init();
    });

    test('Initial hero stats are correct', () {
      expect(viewModel.hero.level, 1);
      expect(viewModel.hero.currentHp, 100);
      expect(viewModel.hero.gold, 50);
      expect(viewModel.quests.length, greaterThan(0));
      expect(viewModel.rewards.length, greaterThan(0));
    });

    test('Completing quest grants EXP and Gold, updates streak', () async {
      final firstQuest = viewModel.quests.first;
      final initialGold = viewModel.hero.gold;
      final initialExp = viewModel.hero.currentExp;

      await viewModel.completeQuest(firstQuest.id);

      expect(viewModel.hero.gold, greaterThan(initialGold));
      expect(viewModel.hero.currentExp, greaterThan(initialExp));
      expect(viewModel.completedQuestsCount, 1);
    });

    test('Buying reward deducts Gold', () async {
      // Find a reward costing 40 gold
      final reward = viewModel.rewards.firstWhere((r) => r.costGold <= viewModel.hero.gold);
      final initialGold = viewModel.hero.gold;

      final success = await viewModel.buyReward(reward);

      expect(success, isTrue);
      expect(viewModel.hero.gold, initialGold - reward.costGold);
    });

    test('Level up calculates correct HP and EXP threshold', () {
      expect(HeroModel.calculateMaxExp(1), 100);
      expect(HeroModel.calculateMaxExp(2), 235);
      expect(HeroModel.calculateMaxHp(1, HeroClass.warrior), 125);
    });

    test('Completing quest unlocks first_quest achievement and grants claim reward', () async {
      final firstQuest = viewModel.quests.first;
      await viewModel.completeQuest(firstQuest.id);

      final firstAch = viewModel.achievements.firstWhere((a) => a.id == 'first_quest');
      expect(firstAch.isUnlocked, isTrue);
      expect(firstAch.isClaimed, isFalse);

      final prevGold = viewModel.hero.gold;
      await viewModel.claimAchievement(firstAch.id);

      expect(viewModel.hero.gold, prevGold + firstAch.rewardGold);
      expect(viewModel.achievements.firstWhere((a) => a.id == 'first_quest').isClaimed, isTrue);
    });

    test('Simulate next day triggers daily rollover penalty on uncompleted quests', () async {
      final initialHp = viewModel.hero.currentHp;
      // Leave all quests incomplete and advance day
      await viewModel.simulateNextDay();

      expect(viewModel.hero.currentHp, lessThan(initialHp));
    });
  });
}
