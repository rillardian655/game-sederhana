import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/activity_log_model.dart';
import '../view_models/game_view_model.dart';

class BattleLogScreen extends StatelessWidget {
  final GameViewModel viewModel;

  const BattleLogScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final logs = viewModel.logs;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.secondary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.secondary.withValues(alpha: 0.4)),
              ),
              child: const Icon(Icons.auto_stories_rounded, size: 20, color: AppTheme.secondary),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'KRONIK PETUALANGAN',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'Buku Catatan Sejarah Pertempuran & Habit',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Chronicle Stats Bar
          Container(
            margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF111728),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF283652)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.history_edu_rounded, size: 18, color: AppTheme.accentCyan),
                    const SizedBox(width: 8),
                    Text(
                      'TOTAL REKAMAN: ${logs.length}',
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.accentCyan.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Aktif Tercatat',
                    style: TextStyle(
                      color: AppTheme.accentCyan,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Timeline Log List
          Expanded(
            child: logs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF161F33),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF283652)),
                          ),
                          child: const Icon(
                            Icons.menu_book_rounded,
                            size: 40,
                            color: AppTheme.textMuted,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Lembaran Kronik Masih Bersih',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Selesaikan misi harian untuk menuliskan sejarahmu!',
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      final timeFormatted =
                          DateFormat('dd MMM, HH:mm').format(log.timestamp);

                      Color accentColor = AppTheme.accentCyan;
                      IconData eventIcon = Icons.done_all_rounded;

                      switch (log.type) {
                        case ActivityType.questComplete:
                          accentColor = AppTheme.success;
                          eventIcon = Icons.task_alt_rounded;
                          break;
                        case ActivityType.levelUp:
                          accentColor = const Color(0xFFFFD700);
                          eventIcon = Icons.star_rounded;
                          break;
                        case ActivityType.damageTaken:
                          accentColor = AppTheme.hpRed;
                          eventIcon = Icons.heart_broken_rounded;
                          break;
                        case ActivityType.rewardBought:
                          accentColor = AppTheme.gold;
                          eventIcon = Icons.card_giftcard_rounded;
                          break;
                        case ActivityType.potionUsed:
                          accentColor = AppTheme.secondary;
                          eventIcon = Icons.healing_rounded;
                          break;
                        case ActivityType.bossAttack:
                          accentColor = Colors.orangeAccent;
                          eventIcon = Icons.flash_on_rounded;
                          break;
                        case ActivityType.bossDefeated:
                          accentColor = const Color(0xFFFFD700);
                          eventIcon = Icons.emoji_events_rounded;
                          break;
                      }

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111728),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.28),
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: accentColor.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: accentColor.withValues(alpha: 0.4),
                                  width: 1,
                                ),
                              ),
                              child: Icon(eventIcon, size: 18, color: accentColor),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 1.5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: accentColor.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          log.type.label.toUpperCase(),
                                          style: TextStyle(
                                            color: accentColor,
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 0.6,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        timeFormatted,
                                        style: const TextStyle(
                                          color: AppTheme.textMuted,
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    log.message,
                                    style: const TextStyle(
                                      color: AppTheme.textPrimary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
