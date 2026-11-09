import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/hero_model.dart';

class HeroHeaderCard extends StatelessWidget {
  final HeroModel hero;
  final VoidCallback? onTapProfile;

  const HeroHeaderCard({
    super.key,
    required this.hero,
    this.onTapProfile,
  });

  @override
  Widget build(BuildContext context) {
    final hpPercent = (hero.currentHp / hero.maxHp).clamp(0.0, 1.0);
    final expPercent = (hero.currentExp / hero.maxExp).clamp(0.0, 1.0);
    final isCriticalHp = hero.currentHp < (hero.maxHp * 0.25);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: AppTheme.heroCardGradient,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isCriticalHp
              ? AppTheme.hpRed.withValues(alpha: 0.8)
              : AppTheme.borderGlow.withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isCriticalHp
                ? AppTheme.hpRed.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.4),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTapProfile,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                // Header Row: Avatar Frame, Hero Info & Stat Badges
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar Crest with Level Badge
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const RadialGradient(
                              colors: [Color(0xFF2A3A5E), Color(0xFF131D33)],
                            ),
                            border: Border.all(
                              color: AppTheme.primaryGlow,
                              width: 2.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withValues(alpha: 0.35),
                                blurRadius: 12,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            hero.heroClass.icon,
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                        Positioned(
                          bottom: -4,
                          right: -4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              gradient: AppTheme.purpleGradient,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white, width: 1),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              'Lv.${hero.level}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),

                    // Hero Name & Class Perk
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  hero.name,
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                    letterSpacing: 0.3,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: AppTheme.textSecondary,
                                size: 18,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceAccent,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  hero.heroClass.title.toUpperCase(),
                                  style: const TextStyle(
                                    color: AppTheme.secondary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  hero.heroClass.perk,
                                  style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Badges: Gold & Streak
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Gold Pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.goldBg.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.gold.withValues(alpha: 0.5),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('🪙', style: TextStyle(fontSize: 12)),
                              const SizedBox(width: 4),
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
                        const SizedBox(height: 6),
                        // Streak Pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF381507),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFFF97316).withValues(alpha: 0.4),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('🔥', style: TextStyle(fontSize: 11)),
                              const SizedBox(width: 4),
                              Text(
                                '${hero.streakDays}d Streak',
                                style: const TextStyle(
                                  color: Color(0xFFFB923C),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Health Gauge
                _buildGaugeBar(
                  icon: '❤️',
                  label: 'HP (DARAH)',
                  current: hero.currentHp,
                  max: hero.maxHp,
                  percent: hpPercent,
                  gradient: AppTheme.hpGradient,
                  bgTrack: const Color(0xFF2B1216),
                  isAlert: isCriticalHp,
                ),
                const SizedBox(height: 12),

                // Experience Gauge
                _buildGaugeBar(
                  icon: '⚡',
                  label: 'EXP (PENGALAMAN)',
                  current: hero.currentExp,
                  max: hero.maxExp,
                  percent: expPercent,
                  gradient: AppTheme.expGradient,
                  bgTrack: const Color(0xFF0C243B),
                  isAlert: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGaugeBar({
    required String icon,
    required String label,
    required int current,
    required int max,
    required double percent,
    required LinearGradient gradient,
    required Color bgTrack,
    required bool isAlert,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 11)),
                const SizedBox(width: 5),
                Text(
                  label,
                  style: TextStyle(
                    color: isAlert ? AppTheme.hpRed : AppTheme.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            Text(
              '$current / $max',
              style: TextStyle(
                color: isAlert ? AppTheme.hpRed : AppTheme.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Container(
          height: 9,
          decoration: BoxDecoration(
            color: bgTrack,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
              width: 0.8,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    width: constraints.maxWidth * percent,
                    decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: gradient.colors.first.withValues(alpha: 0.5),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
