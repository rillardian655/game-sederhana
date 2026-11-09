import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/boss_model.dart';
import '../../data/models/hero_model.dart';
import '../view_models/game_view_model.dart';

class DungeonScreen extends StatelessWidget {
  final GameViewModel viewModel;

  const DungeonScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final activeBoss = viewModel.currentActiveBoss;
    final allBosses = viewModel.bosses;
    final hero = viewModel.hero;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'DUNGEON BOS MONSTER',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: 1.2,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              'Taklukkan Raksasa Penunda Waktu',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 11,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.goldBg.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.gold.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                const Text('🪙', style: TextStyle(fontSize: 13)),
                const SizedBox(width: 5),
                Text(
                  '${hero.gold}',
                  style: const TextStyle(
                    color: AppTheme.gold,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active Boss Raid Banner
            if (activeBoss != null) ...[
              _buildActiveBossArenaCard(context, activeBoss, hero),
              const SizedBox(height: 16),
              _buildCombatMechanicCard(context, hero),
              const SizedBox(height: 24),
            ],

            // Boss Bestiary Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.shield_outlined, color: AppTheme.secondary, size: 16),
                ),
                const SizedBox(width: 8),
                const Text(
                  'DAFTAR BOS DUNGEON',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Boss Cards List
            ...allBosses.map((boss) {
              final isCurrent = activeBoss?.id == boss.id && !boss.isDefeated;
              return _buildBossRosterCard(context, boss, isCurrent);
            }),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveBossArenaCard(BuildContext context, BossModel boss, HeroModel hero) {
    final double hpRatio = boss.maxHp == 0 ? 0 : (boss.currentHp / boss.maxHp).clamp(0.0, 1.0);
    final isDefeated = boss.isDefeated;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDefeated
              ? [const Color(0xFF11221C), const Color(0xFF0A1412)]
              : [const Color(0xFF261017), const Color(0xFF14080D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDefeated
              ? AppTheme.success.withValues(alpha: 0.6)
              : AppTheme.hpRed.withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDefeated
                ? AppTheme.success.withValues(alpha: 0.15)
                : AppTheme.hpRed.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Large Boss Portrait Frame
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: isDefeated
                            ? [const Color(0xFF164E3D), const Color(0xFF091F18)]
                            : [const Color(0xFF581C25), const Color(0xFF2B0A11)],
                      ),
                      border: Border.all(
                        color: isDefeated ? AppTheme.success : AppTheme.hpRed,
                        width: 2.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDefeated
                              ? AppTheme.success.withValues(alpha: 0.3)
                              : AppTheme.hpRed.withValues(alpha: 0.4),
                          blurRadius: 14,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      isDefeated ? '💀' : boss.avatar,
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // Boss Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDefeated
                            ? AppTheme.success.withValues(alpha: 0.2)
                            : AppTheme.hpRed.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isDefeated
                              ? AppTheme.success.withValues(alpha: 0.4)
                              : AppTheme.hpRed.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        isDefeated
                            ? 'BOS TELAH TUMBANG'
                            : 'BOS RAID LEVEL ${boss.bossLevel}',
                        style: TextStyle(
                          color: isDefeated ? AppTheme.success : AppTheme.hpRed,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      boss.name,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      boss.subtitle,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Boss Health Bar Gauge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Text('💀', style: TextStyle(fontSize: 12)),
                  SizedBox(width: 5),
                  Text(
                    'HEALTH POOL (HP BOS)',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
              Text(
                '${boss.currentHp} / ${boss.maxHp} HP (${(hpRatio * 100).toInt()}%)',
                style: TextStyle(
                  color: isDefeated ? AppTheme.success : AppTheme.hpRed,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 12,
              color: const Color(0xFF1E080D),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: constraints.maxWidth * hpRatio,
                      decoration: BoxDecoration(
                        gradient: isDefeated
                            ? const LinearGradient(
                                colors: [Color(0xFF10B981), Color(0xFF059669)],
                              )
                            : AppTheme.hpGradient,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: isDefeated
                                ? AppTheme.success.withValues(alpha: 0.5)
                                : AppTheme.hpRed.withValues(alpha: 0.6),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Lore Lore Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Text(
              '"${boss.description}"',
              style: const TextStyle(
                color: Color(0xFFCBD5E1),
                fontSize: 11,
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Loot Preview Strip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.surface.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    const Text('🎁 Peti Hadiah: ',
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                    Text(
                      '+${boss.rewardExp} EXP',
                      style: const TextStyle(
                        color: AppTheme.expBlue,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Text(
                  '+${boss.rewardGold} Gold',
                  style: const TextStyle(
                    color: AppTheme.gold,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tactile Ultimate Strike Action Button
          if (!isDefeated)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: hero.gold >= 20 ? AppTheme.goldGradient : null,
                color: hero.gold >= 20 ? null : AppTheme.surfaceLight,
                boxShadow: hero.gold >= 20
                    ? [
                        BoxShadow(
                          color: AppTheme.gold.withValues(alpha: 0.4),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: ElevatedButton.icon(
                onPressed: hero.gold >= 20
                    ? () async {
                        HapticFeedback.heavyImpact();
                        final success = await viewModel.castUltimateFocusSkill();
                        if (context.mounted && success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                '⚡ Jurus Fokus Membara berhasil dilancarkan! 55 DMG ke bos!',
                              ),
                              backgroundColor: AppTheme.primary,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    : null,
                icon: const Text('⚡', style: TextStyle(fontSize: 18)),
                label: Text(
                  hero.gold >= 20
                      ? 'Kerahkan Jurus Fokus (20 🪙 • 55 DMG)'
                      : 'Butuh 20 🪙 Gold untuk Jurus Fokus',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: hero.gold >= 20 ? Colors.black : AppTheme.textMuted,
                    letterSpacing: 0.3,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCombatMechanicCard(BuildContext context, HeroModel hero) {
    final classBonusText = switch (hero.heroClass) {
      HeroClass.warrior => 'Tebasan Pedang (+15 DMG Fisik)',
      HeroClass.mage => 'Ledakan Sihir (+20 DMG Sihir)',
      HeroClass.rogue => 'Serangan Mengendap (+10 DMG + Peluang Kritis)',
      HeroClass.paladin => 'Hukuman Suci (+12 DMG Suci)',
    };

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.borderLight, width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceAccent,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.borderGlow),
            ),
            child: const Icon(Icons.flash_on_rounded, color: AppTheme.gold, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MEKANISME SERANGAN OTOMATIS',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Setiap menyelesaikan misi di dunia nyata, kamu menebas bos aktif! Pasif ${hero.heroClass.title}: $classBonusText.',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 11,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBossRosterCard(BuildContext context, BossModel boss, bool isCurrent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isCurrent
            ? const Color(0xFF1B1B2F)
            : AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrent
              ? AppTheme.primaryGlow
              : (boss.isDefeated ? AppTheme.success.withValues(alpha: 0.5) : AppTheme.borderLight),
          width: isCurrent ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: boss.isDefeated
                  ? AppTheme.success.withValues(alpha: 0.2)
                  : (isCurrent ? const Color(0xFF451A24) : AppTheme.surfaceLight),
              shape: BoxShape.circle,
              border: Border.all(
                color: isCurrent
                    ? AppTheme.hpRed
                    : (boss.isDefeated ? AppTheme.success : AppTheme.borderGlow),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              boss.isDefeated ? '✅' : boss.avatar,
              style: const TextStyle(fontSize: 22),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      boss.name,
                      style: TextStyle(
                        color: boss.isDefeated
                            ? AppTheme.textMuted
                            : AppTheme.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        decoration: boss.isDefeated ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceAccent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Lv.${boss.bossLevel}',
                        style: const TextStyle(
                          color: AppTheme.secondary,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  boss.subtitle,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.hpRed.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.hpRed.withValues(alpha: 0.5)),
              ),
              child: const Text(
                '⚔️ AKTIF',
                style: TextStyle(
                  color: AppTheme.hpRed,
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                ),
              ),
            )
          else if (boss.isDefeated)
            const Text(
              'TUMBANG',
              style: TextStyle(
                color: AppTheme.success,
                fontWeight: FontWeight.w800,
                fontSize: 11,
              ),
            )
          else
            const Text('🔒', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
