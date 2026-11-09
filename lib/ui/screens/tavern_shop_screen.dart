import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../view_models/game_view_model.dart';
import '../widgets/reward_card.dart';
import '../widgets/add_reward_dialog.dart';

class TavernShopScreen extends StatelessWidget {
  final GameViewModel viewModel;

  const TavernShopScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final rewards = viewModel.rewards;
    final gold = viewModel.hero.gold;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text('🍺', style: TextStyle(fontSize: 22)),
            SizedBox(width: 8),
            Text('Kedai Hadiah (Tavern)'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Tavern Ambiance & Gold Balance Banner
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.goldBg.withValues(alpha: 0.4),
                  AppTheme.surface,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.gold.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.goldBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: const Text('🪙', style: TextStyle(fontSize: 26)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kantong Koin Kamu',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$gold Gold',
                        style: const TextStyle(
                          color: AppTheme.gold,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'Tukar hadiah\nself-reward!',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Rewards List
          Expanded(
            child: rewards.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada hadiah di kedai.\nBuat hadiah pertamamu!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: rewards.length,
                    itemBuilder: (context, index) {
                      final reward = rewards[index];
                      return RewardCard(
                        reward: reward,
                        playerGold: gold,
                        onBuy: () async {
                          HapticFeedback.lightImpact();
                          final success = await viewModel.buyReward(reward);
                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '🎉 Selamat menikmati: "${reward.title}"!',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          }
                        },
                        onDelete: () => viewModel.deleteReward(reward.id),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.gold,
        foregroundColor: Colors.black87,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Hadiah Baru',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AddRewardDialog(
              onAdd: ({
                required String title,
                required String description,
                required int costGold,
                required String icon,
              }) {
                viewModel.addCustomReward(
                  title: title,
                  description: description,
                  costGold: costGold,
                  icon: icon,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

