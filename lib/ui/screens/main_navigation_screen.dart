import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../view_models/game_view_model.dart';
import 'quest_list_screen.dart';
import 'hero_screen.dart';
import 'tavern_shop_screen.dart';
import 'battle_log_screen.dart';
import 'dungeon_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final GameViewModel viewModel;

  const MainNavigationScreen({super.key, required this.viewModel});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_checkViewModelAlerts);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_checkViewModelAlerts);
    super.dispose();
  }

  void _checkViewModelAlerts() {
    final vm = widget.viewModel;

    // Check Level Up Alert
    if (vm.lastLevelUpMessage != null && mounted) {
      final msg = vm.lastLevelUpMessage!;
      vm.clearLevelUpMessage();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showLevelUpDialog(msg);
      });
    }

    // Check Penalty Alert
    if (vm.penaltyAlertMessage != null && mounted) {
      final msg = vm.penaltyAlertMessage!;
      vm.clearPenaltyAlert();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showPenaltyDialog(msg);
      });
    }

    // Check Boss Defeat Alert
    if (vm.lastBossDefeatedMessage != null && mounted) {
      final msg = vm.lastBossDefeatedMessage!;
      vm.clearBossDefeatedMessage();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showBossDefeatedDialog(msg);
      });
    }
  }

  void _showLevelUpDialog(String message) {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppTheme.primary, width: 2),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            const Text('🌟 ⚔️ 🌟', style: TextStyle(fontSize: 36)),
            const SizedBox(height: 12),
            const Text(
              'LEVEL UP!',
              style: TextStyle(
                color: AppTheme.primary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                minimumSize: const Size(double.infinity, 44),
              ),
              child: const Text('Lanjutkan Petualangan!'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPenaltyDialog(String message) {
    HapticFeedback.vibrate();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppTheme.hpRed, width: 1.5),
        ),
        title: const Row(
          children: [
            Text('⚠️', style: TextStyle(fontSize: 22)),
            SizedBox(width: 8),
            Text('Peringatan Hari Baru', style: TextStyle(color: AppTheme.hpRed)),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(color: AppTheme.textPrimary, height: 1.4),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.hpRed),
            onPressed: () => Navigator.pop(context),
            child: const Text('Saya Mengerti'),
          ),
        ],
      ),
    );
  }

  void _showBossDefeatedDialog(String message) {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppTheme.gold, width: 2),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            const Text('👑 🏆 ⚔️', style: TextStyle(fontSize: 36)),
            const SizedBox(height: 12),
            const Text(
              'BOS DITAKLUKKAN!',
              style: TextStyle(
                color: AppTheme.gold,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.gold,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 44),
              ),
              child: const Text(
                'Klaim Rampasan & Lanjut!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;

    if (vm.isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AppTheme.primary),
              SizedBox(height: 16),
              Text(
                'Mempersiapkan Perlengkapan Petualang...',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    final screens = [
      QuestListScreen(
        viewModel: vm,
        onNavigateToHero: () => setState(() => _currentIndex = 2),
      ),
      DungeonScreen(viewModel: vm),
      HeroScreen(viewModel: vm),
      TavernShopScreen(viewModel: vm),
      BattleLogScreen(viewModel: vm),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: screens[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFF2E3F5B), width: 1)),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          backgroundColor: AppTheme.surface,
          indicatorColor: AppTheme.primary.withValues(alpha: 0.2),
          onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
          destinations: [
            NavigationDestination(
              icon: const Text('⚔️', style: TextStyle(fontSize: 18)),
              selectedIcon: const Text('⚔️', style: TextStyle(fontSize: 22)),
              label: 'Misi (${vm.completedQuestsCount}/${vm.totalQuestsCount})',
            ),
            NavigationDestination(
              icon: const Text('🐉', style: TextStyle(fontSize: 18)),
              selectedIcon: const Text('🐉', style: TextStyle(fontSize: 22)),
              label: vm.currentActiveBoss != null && !vm.currentActiveBoss!.isDefeated
                  ? 'Bos (${(vm.currentActiveBoss!.currentHp / vm.currentActiveBoss!.maxHp * 100).toInt()}%)'
                  : 'Dungeon',
            ),
            const NavigationDestination(
              icon: Text('🛡️', style: TextStyle(fontSize: 18)),
              selectedIcon: Text('🛡️', style: TextStyle(fontSize: 22)),
              label: 'Pahlawan',
            ),
            NavigationDestination(
              icon: const Text('🍺', style: TextStyle(fontSize: 18)),
              selectedIcon: const Text('🍺', style: TextStyle(fontSize: 22)),
              label: 'Kedai (${vm.hero.gold}🪙)',
            ),
            const NavigationDestination(
              icon: Text('📜', style: TextStyle(fontSize: 18)),
              selectedIcon: Text('📜', style: TextStyle(fontSize: 22)),
              label: 'Riwayat',
            ),
          ],
        ),
      ),
    );
  }
}

