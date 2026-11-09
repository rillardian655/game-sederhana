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
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E1538), Color(0xFF0F1424)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFFFD700), width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFD700).withValues(alpha: 0.35),
                blurRadius: 30,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFF8800)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withValues(alpha: 0.5),
                      blurRadius: 18,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text('🌟', style: TextStyle(fontSize: 36)),
              ),
              const SizedBox(height: 16),
              const Text(
                'LEVEL UP!',
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.5,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 2,
                width: 60,
                color: const Color(0xFFFFD700).withValues(alpha: 0.4),
              ),
              const SizedBox(height: 14),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 22),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 46),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 6,
                ),
                child: const Text(
                  '⚔️ Lanjutkan Petualangan!',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPenaltyDialog(String message) {
    HapticFeedback.vibrate();
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF280B14), Color(0xFF140D1A)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.hpRed, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppTheme.hpRed.withValues(alpha: 0.35),
                blurRadius: 24,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.hpRed.withValues(alpha: 0.2),
                  border: Border.all(color: AppTheme.hpRed, width: 2),
                ),
                alignment: Alignment.center,
                child: const Text('⚠️', style: TextStyle(fontSize: 28)),
              ),
              const SizedBox(height: 14),
              const Text(
                'PENALTI HARI BARU',
                style: TextStyle(
                  color: AppTheme.hpRed,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.hpRed,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Saya Mengerti & Bangkit Kembali',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBossDefeatedDialog(String message) {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF261D08), Color(0xFF131522)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.gold, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppTheme.gold.withValues(alpha: 0.4),
                blurRadius: 30,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFF5500)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.gold.withValues(alpha: 0.6),
                      blurRadius: 20,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text('👑', style: TextStyle(fontSize: 38)),
              ),
              const SizedBox(height: 16),
              const Text(
                'BOS DITAKLUKKAN!',
                style: TextStyle(
                  color: AppTheme.gold,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.8,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 22),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.gold,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 46),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  '🏆 Klaim Rampasan & Lanjut!',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;

    if (vm.isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AppTheme.primary),
              SizedBox(height: 16),
              Text(
                'Mempersiapkan Perlengkapan Petualang...',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
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
      backgroundColor: AppTheme.background,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: screens[_currentIndex],
      ),
      bottomNavigationBar: _buildTactileRpgDock(vm),
    );
  }

  Widget _buildTactileRpgDock(GameViewModel vm) {
    final navItems = [
      _RpgNavItem(
        icon: Icons.checklist_rounded,
        label: 'Misi',
        badge: '${vm.completedQuestsCount}/${vm.totalQuestsCount}',
        color: AppTheme.accentCyan,
      ),
      _RpgNavItem(
        icon: Icons.local_fire_department_rounded,
        label: 'Bos',
        badge: vm.currentActiveBoss != null && !vm.currentActiveBoss!.isDefeated
            ? '${(vm.currentActiveBoss!.currentHp / vm.currentActiveBoss!.maxHp * 100).toInt()}%'
            : 'Clear',
        badgeColor: AppTheme.hpRed,
        color: AppTheme.hpRed,
      ),
      _RpgNavItem(
        icon: Icons.shield_rounded,
        label: 'Hero',
        badge: 'Lv.${vm.hero.level}',
        color: AppTheme.primary,
      ),
      _RpgNavItem(
        icon: Icons.storefront_rounded,
        label: 'Kedai',
        badge: '${vm.hero.gold}',
        badgeColor: AppTheme.gold,
        color: AppTheme.gold,
      ),
      const _RpgNavItem(
        icon: Icons.auto_stories_rounded,
        label: 'Kronik',
        color: AppTheme.secondary,
      ),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xE8101626),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF283652), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.15),
              blurRadius: 18,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(navItems.length, (index) {
            final item = navItems[index];
            final isSelected = _currentIndex == index;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _currentIndex = index);
                },
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? item.color.withValues(alpha: 0.18)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? item.color.withValues(alpha: 0.5)
                          : Colors.transparent,
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            item.icon,
                            size: isSelected ? 24 : 21,
                            color: isSelected
                                ? item.color
                                : AppTheme.textMuted.withValues(alpha: 0.7),
                          ),
                          if (item.badge != null)
                            Positioned(
                              top: -6,
                              right: -12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 1.5,
                                ),
                                decoration: BoxDecoration(
                                  color: item.badgeColor ?? const Color(0xFF1E283F),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: (item.badgeColor ?? AppTheme.primary)
                                        .withValues(alpha: 0.8),
                                    width: 0.8,
                                  ),
                                ),
                                child: Text(
                                  item.badge!,
                                  style: TextStyle(
                                    color: item.badgeColor != null
                                        ? Colors.black87
                                        : Colors.white,
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppTheme.textMuted.withValues(alpha: 0.75),
                          fontSize: 10.5,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _RpgNavItem {
  final IconData icon;
  final String label;
  final String? badge;
  final Color? badgeColor;
  final Color color;

  const _RpgNavItem({
    required this.icon,
    required this.label,
    this.badge,
    this.badgeColor,
    required this.color,
  });
}
