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

  Color _getDifficultyColor(QuestDifficulty difficulty) {
    switch (difficulty) {
      case QuestDifficulty.easy:
        return const Color(0xFF10B981); // Emerald
      case QuestDifficulty.medium:
        return const Color(0xFF38BDF8); // Sapphire
      case QuestDifficulty.hard:
        return const Color(0xFFA855F7); // Amethyst
      case QuestDifficulty.epic:
        return const Color(0xFFF97316); // Blazing Ember
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDone = quest.isCompletedToday;
    final diffColor = _getDifficultyColor(quest.difficulty);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isDone ? const Color(0xFF0D171A) : AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDone
              ? AppTheme.success.withValues(alpha: 0.6)
              : AppTheme.borderLight,
          width: isDone ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isDone
                ? AppTheme.success.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left Difficulty Accent Rail
              Container(
                width: 5,
                decoration: BoxDecoration(
                  color: isDone
                      ? AppTheme.success.withValues(alpha: 0.4)
                      : diffColor,
                  boxShadow: [
                    if (!isDone)
                      BoxShadow(
                        color: diffColor.withValues(alpha: 0.6),
                        blurRadius: 6,
                      ),
                  ],
                ),
              ),

              // Card Content
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: isDone ? onUndo : onComplete,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tactile Checkbox Button
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 36,
                            height: 36,
                            margin: const EdgeInsets.only(top: 2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: isDone
                                  ? const LinearGradient(
                                      colors: [Color(0xFF34D399), Color(0xFF059669)],
                                    )
                                  : null,
                              color: isDone ? null : AppTheme.surfaceLight,
                              border: Border.all(
                                color: isDone ? Colors.white : AppTheme.borderGlow,
                                width: isDone ? 1.5 : 1.8,
                              ),
                              boxShadow: isDone
                                  ? [
                                      BoxShadow(
                                        color: AppTheme.success.withValues(alpha: 0.4),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              isDone ? Icons.check_rounded : Icons.radio_button_unchecked,
                              color: isDone ? Colors.white : AppTheme.textMuted,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Text & Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title & Streak
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        quest.title,
                                        style: TextStyle(
                                          color: isDone
                                              ? AppTheme.textMuted
                                              : AppTheme.textPrimary,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                          letterSpacing: 0.2,
                                          decoration: isDone
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                          decorationColor: AppTheme.textMuted,
                                        ),
                                      ),
                                    ),
                                    if (quest.streak > 0)
                                      Container(
                                        margin: const EdgeInsets.only(left: 6),
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF381507),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: const Color(0xFFF97316).withValues(alpha: 0.4),
                                            width: 0.8,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text('🔥', style: TextStyle(fontSize: 10)),
                                            const SizedBox(width: 2),
                                            Text(
                                              '${quest.streak}',
                                              style: const TextStyle(
                                                color: Color(0xFFFB923C),
                                                fontWeight: FontWeight.w800,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    // More options
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      icon: const Icon(
                                        Icons.more_vert,
                                        size: 18,
                                        color: AppTheme.textMuted,
                                      ),
                                      onPressed: () => _showOptionsSheet(context),
                                    ),
                                  ],
                                ),
                                if (quest.description.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    quest.description,
                                    style: TextStyle(
                                      color: isDone
                                          ? AppTheme.textMuted.withValues(alpha: 0.7)
                                          : AppTheme.textSecondary,
                                      fontSize: 12,
                                      height: 1.3,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                const SizedBox(height: 10),

                                // Loot Tags Row
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    // Category Pill
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppTheme.surfaceLight,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: AppTheme.borderLight, width: 0.8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(quest.category.icon, style: const TextStyle(fontSize: 10)),
                                          const SizedBox(width: 4),
                                          Text(
                                            quest.category.label,
                                            style: const TextStyle(
                                              color: AppTheme.textSecondary,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Difficulty Pill
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: diffColor.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: diffColor.withValues(alpha: 0.3), width: 0.8),
                                      ),
                                      child: Text(
                                        quest.difficulty.label,
                                        style: TextStyle(
                                          color: diffColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),

                                    // EXP Tag
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppTheme.expBlueBg.withValues(alpha: 0.5),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '+${quest.difficulty.expReward} EXP',
                                        style: const TextStyle(
                                          color: AppTheme.expBlue,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),

                                    // Gold Tag
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppTheme.goldBg.withValues(alpha: 0.5),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '+${quest.difficulty.goldReward} 🪙',
                                        style: const TextStyle(
                                          color: AppTheme.gold,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOptionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded, color: AppTheme.hpRed),
                title: const Text(
                  'Hapus Misi Ini',
                  style: TextStyle(color: AppTheme.hpRed, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onDelete();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
