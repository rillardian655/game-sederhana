import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/reward_model.dart';

class RewardCard extends StatelessWidget {
  final RewardModel reward;
  final int playerGold;
  final VoidCallback onBuy;
  final VoidCallback? onDelete;

  const RewardCard({
    super.key,
    required this.reward,
    required this.playerGold,
    required this.onBuy,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final canAfford = playerGold >= reward.costGold;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: canAfford ? AppTheme.gold.withValues(alpha: 0.3) : const Color(0xFF2E3F5B),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          // Icon Container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: canAfford ? AppTheme.gold.withValues(alpha: 0.5) : Colors.transparent,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              reward.icon,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(width: 14),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reward.title,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                if (reward.description.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    reward.description,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.goldBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🪙', style: TextStyle(fontSize: 12)),
                          const SizedBox(width: 4),
                          Text(
                            '${reward.costGold} Gold',
                            style: const TextStyle(
                              color: AppTheme.gold,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (reward.timesRedeemed > 0) ...[
                      const SizedBox(width: 8),
                      Text(
                        'Ditukar ${reward.timesRedeemed}x',
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Action Button
          Column(
            children: [
              ElevatedButton(
                onPressed: canAfford ? onBuy : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canAfford ? AppTheme.gold : AppTheme.surfaceLight,
                  foregroundColor: canAfford ? Colors.black87 : AppTheme.textMuted,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  canAfford ? 'Tukar' : 'Kunci',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              if (!reward.isDefault && onDelete != null) ...[
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: onDelete,
                  child: const Text(
                    'Hapus',
                    style: TextStyle(
                      color: AppTheme.hpRed,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

