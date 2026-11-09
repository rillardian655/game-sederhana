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
        title: const Row(
          children: [
            Text('🐉', style: TextStyle(fontSize: 22)),
            SizedBox(width: 8),
            Text(
              'Dungeon Bos Monster',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.goldBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.gold.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Text('🪙', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text(
                  '${hero.gold}',
                  style: const TextStyle(
                    color: AppTheme.gold,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active Boss Arena Card
            if (activeBoss != null) ...[
              _buildActiveBossCard(context, activeBoss, hero),
              const SizedBox(height: 16),
              _buildCombatMechanicInfo(context, hero),
              const SizedBox(height: 24),
            ],

            // Boss Bestiary List
            const Row(
              children: [
                Text('📜', style: TextStyle(fontSize: 18)),
                SizedBox(width: 8),
                Text(
                  'Daftar Bos Dungeon',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...allBosses.map((boss) {
              final isCurrent = activeBoss?.id == boss.id && !boss.isDefeated;
              return _buildBossRosterCard(context, boss, isCurrent);
            }),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveBossCard(BuildContext context, BossModel boss, HeroModel hero) {
    final double hpRatio = boss.maxHp == 0 ? 0 : (boss.currentHp / boss.maxHp).clamp(0.0, 1.0);
    final isDefeated = boss.isDefeated;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDefeated ? AppTheme.success : AppTheme.hpRed.withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDefeated
                ? AppTheme.success.withValues(alpha: 0.15)
                : AppTheme.hpRed.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Large Boss Avatar
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: isDefeated
                      ? AppTheme.surfaceLight
                      : const Color(0xFF3B1F2B),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDefeated ? AppTheme.success : AppTheme.hpRed,
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  isDefeated ? '💀' : boss.avatar,
                  style: const TextStyle(fontSize: 38),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDefeated
                            ? AppTheme.success.withValues(alpha: 0.2)
                            : AppTheme.hpRed.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isDefeated
                            ? 'DITAKLUKKAN'
                            : 'BOS LEVEL ${boss.bossLevel} • AKTIF',
                        style: TextStyle(
                          color: isDefeated ? AppTheme.success : AppTheme.hpRed,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      boss.name,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      boss.subtitle,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // HP Progress Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Health Points (HP)',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${boss.currentHp} / ${boss.maxHp} HP (${(hpRatio * 100).toInt()}%)',
                style: TextStyle(
                  color: isDefeated ? AppTheme.success : AppTheme.hpRed,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: hpRatio,
              minHeight: 12,
              backgroundColor: const Color(0xFF2E3F5B),
              valueColor: AlwaysStoppedAnimation<Color>(
                isDefeated ? AppTheme.success : AppTheme.hpRed,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Lore / Description
          Text(
            boss.description,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              height: 1.4,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),

          // Loot Info Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    const Text('🎁 Hadiah Kemenangan: ',
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                    Text(
                      '+${boss.rewardExp} EXP',
                      style: const TextStyle(
                        color: AppTheme.expBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Text(
                  '+${boss.rewardGold} Gold',
                  style: const TextStyle(
                    color: AppTheme.gold,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Ultimate Strike Button
          if (!isDefeated)
            ElevatedButton.icon(
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
                    ? 'Kerahkan Jurus Fokus (20 🪙 Gold • 55 DMG)'
                    : 'Butuh 20 🪙 Gold untuk Jurus Fokus',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE58F00),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCombatMechanicInfo(BuildContext context, HeroModel hero) {
    final classBonusText = switch (hero.heroClass) {
      HeroClass.warrior => 'Tebasan Pedang (+15 DMG Fisik)',
      HeroClass.mage => 'Ledakan Sihir (+20 DMG Sihir)',
      HeroClass.rogue => 'Serangan Mengendap (+10 DMG + Peluang Kritis)',
      HeroClass.paladin => 'Hukuman Suci (+12 DMG Suci)',
    };

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2E3F5B)),
      ),
      child: Row(
        children: [
          const Text('⚔️', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mekanisme Serangan Otomatis',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Setiap menyelesaikan misi di dunia nyata, kamu menyerang bos aktif! Pasif ${hero.heroClass.title}: $classBonusText.',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 11,
                    height: 1.3,
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
            ? AppTheme.surface
            : AppTheme.surfaceLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrent
              ? AppTheme.primary
              : (boss.isDefeated ? AppTheme.success.withValues(alpha: 0.4) : const Color(0xFF2E3F5B)),
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
                  : (isCurrent ? const Color(0xFF3B1F2B) : Colors.black26),
              shape: BoxShape.circle,
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
                            ? AppTheme.textSecondary
                            : AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        decoration: boss.isDefeated ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E3F5B),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Lv.${boss.bossLevel}',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
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
              ),
              child: const Text(
                '⚔️ AKTIF',
                style: TextStyle(
                  color: AppTheme.hpRed,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            )
          else if (boss.isDefeated)
            const Text(
              'TUMBANG',
              style: TextStyle(
                color: AppTheme.success,
                fontWeight: FontWeight.bold,
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
