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
      appBar: AppBar(
        title: const Row(
          children: [
            Text('📜', style: TextStyle(fontSize: 22)),
            SizedBox(width: 8),
            Text('Catatan Petualangan (Logs)'),
          ],
        ),
      ),
      body: logs.isEmpty
          ? const Center(
              child: Text(
                'Belum ada catatan aktivitas petualangan.',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                final timeFormatted =
                    DateFormat('dd MMM, HH:mm').format(log.timestamp);

                Color badgeColor = AppTheme.surfaceLight;
                if (log.type == ActivityType.levelUp) {
                  badgeColor = AppTheme.primary.withValues(alpha: 0.3);
                } else if (log.type == ActivityType.damageTaken) {
                  badgeColor = AppTheme.hpRed.withValues(alpha: 0.2);
                } else if (log.type == ActivityType.rewardBought) {
                  badgeColor = AppTheme.gold.withValues(alpha: 0.2);
                } else if (log.type == ActivityType.potionUsed) {
                  badgeColor = AppTheme.secondary.withValues(alpha: 0.2);
                }

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF2E3F5B), width: 0.8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(log.type.icon, style: const TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              log.message,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              timeFormatted,
                              style: const TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 11,
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
    );
  }
}

