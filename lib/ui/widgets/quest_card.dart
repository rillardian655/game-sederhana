import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/quest_model.dart';

class QuestCard extends StatelessWidget {
  final QuestModel quest;
  final VoidCallback onComplete;
  final VoidCallback onUndo;
  final VoidCallback onDelete;

  const QuestCard({
    super.key,
    required this.quest,
    required this.onComplete,
    required this.onUndo,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = quest.isCompletedToday;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isDone ? const Color(0xFF0F231D) : AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDone
              ? AppTheme.success.withValues(alpha: 0.5)
              : const Color(0xFF2E3F5B),
          width: isDone ? 1.5 : 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isDone ? onUndo : onComplete,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Complete Button / Check Icon
                Container(
                  width: 38,
                  height: 38,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone
                        ? AppTheme.success
                        : AppTheme.surfaceLight,
                    border: Border.all(
                      color: isDone
                          ? AppTheme.success
                          : AppTheme.textMuted,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    isDone ? Icons.check_rounded : Icons.radio_button_unchecked_rounded,
                    color: isDone ? Colors.white : AppTheme.textMuted,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),

                // Main Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Category
                      Row(
                        children: [
                          Text(quest.category.icon, style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              quest.title,
                              style: TextStyle(
                                color: isDone
                                    ? AppTheme.textSecondary
                                    : AppTheme.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                decoration: isDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                          ),
                          if (quest.streak > 0) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('🔥', style: TextStyle(fontSize: 11)),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${quest.streak}',
                                    style: const TextStyle(
                                      color: Colors.orangeAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (quest.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          quest.description,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 10),

                      // Reward and Difficulty Badges
                      Row(
                        children: [
                          // Difficulty
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${quest.difficulty.icon} ${quest.difficulty.label}',
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // EXP Reward
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.expBlue.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '+${quest.difficulty.expReward} EXP',
                              style: const TextStyle(
                                color: AppTheme.expBlue,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),

                          // Gold Reward
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.gold.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '+${quest.difficulty.goldReward} 🪙',
                              style: const TextStyle(
                                color: AppTheme.gold,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const Spacer(),

                          // Delete Icon Popup
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.more_vert, size: 18, color: AppTheme.textMuted),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: AppTheme.surface,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                builder: (_) => SafeArea(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.delete_outline, color: AppTheme.hpRed),
                                        title: const Text('Hapus Misi Ini', style: TextStyle(color: AppTheme.hpRed)),
                                        onTap: () {
                                          Navigator.pop(context);
                                          onDelete();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

