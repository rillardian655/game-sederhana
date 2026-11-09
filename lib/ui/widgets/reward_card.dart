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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111728),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: canAfford ? AppTheme.gold.withValues(alpha: 0.5) : const Color(0xFF222E47),
          width: canAfford ? 1.5 : 1.0,
        ),
        boxShadow: canAfford
            ? [
                BoxShadow(
                  color: AppTheme.gold.withValues(alpha: 0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon Container with Runic Glow
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: canAfford
                  ? AppTheme.gold.withValues(alpha: 0.15)
                  : const Color(0xFF182238),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: canAfford ? AppTheme.gold.withValues(alpha: 0.6) : const Color(0xFF2E3F5B),
                width: 1.2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              reward.icon,
              style: const TextStyle(fontSize: 26),
            ),
          ),
          const SizedBox(width: 14),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        reward.title,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                if (reward.description.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    reward.description,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.gold.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.gold.withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.monetization_on_rounded, size: 14, color: AppTheme.gold),
                          const SizedBox(width: 4),
                          Text(
                            '${reward.costGold} Gold',
                            style: const TextStyle(
                              color: AppTheme.gold,
                              fontWeight: FontWeight.w900,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (reward.timesRedeemed > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Ditukar ${reward.timesRedeemed}x',
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Action Button & Delete
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: canAfford ? onBuy : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canAfford ? AppTheme.gold : const Color(0xFF1E283F),
                  foregroundColor: canAfford ? Colors.black : AppTheme.textMuted,
                  disabledBackgroundColor: const Color(0xFF192135),
                  disabledForegroundColor: AppTheme.textMuted.withValues(alpha: 0.5),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  elevation: canAfford ? 4 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: canAfford ? AppTheme.gold : const Color(0xFF283652),
                      width: 1,
                    ),
                  ),
                ),
                child: Text(
                  canAfford ? 'Tukar' : 'Terkunci',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 12.5,
                  ),
                ),
              ),
              if (!reward.isDefault && onDelete != null) ...[
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: const Text(
                      'Hapus',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 11,
                        decoration: TextDecoration.underline,
                      ),
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
