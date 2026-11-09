import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/quest_model.dart';
import '../view_models/game_view_model.dart';
import '../widgets/hero_header_card.dart';
import '../widgets/quest_card.dart';
import '../widgets/add_quest_dialog.dart';

class QuestListScreen extends StatefulWidget {
  final GameViewModel viewModel;
  final VoidCallback onNavigateToHero;

  const QuestListScreen({
    super.key,
    required this.viewModel,
    required this.onNavigateToHero,
  });

  @override
  State<QuestListScreen> createState() => _QuestListScreenState();
}

class _QuestListScreenState extends State<QuestListScreen> {
  int _selectedFilterIndex = 0; // 0: Semua, 1: Belum Selesai, 2: Selesai

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;
    final allQuests = vm.quests;

    final filteredQuests = allQuests.where((q) {
      if (_selectedFilterIndex == 1) return !q.isCompletedToday;
      if (_selectedFilterIndex == 2) return q.isCompletedToday;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text('⚔️', style: TextStyle(fontSize: 22)),
            SizedBox(width: 8),
            Text('Misi Petualang (Quests)'),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => vm.init(),
        color: AppTheme.primary,
        backgroundColor: AppTheme.surface,
        child: CustomScrollView(
          slivers: [
            // Hero Status Header Card
            SliverToBoxAdapter(
              child: HeroHeaderCard(
                hero: vm.hero,
                onTapProfile: widget.onNavigateToHero,
              ),
            ),

            // Daily Progress Banner
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primary.withValues(alpha: 0.15),
                      AppTheme.secondary.withValues(alpha: 0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Progres Hari Ini',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${vm.completedQuestsCount} / ${vm.totalQuestsCount} Selesai (${(vm.todayProgress * 100).toInt()}%)',
                          style: const TextStyle(
                            color: AppTheme.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: vm.todayProgress,
                        minHeight: 8,
                        backgroundColor: AppTheme.surfaceLight,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.secondary),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Filter Chips
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _buildFilterChip(0, 'Semua (${allQuests.length})'),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      1,
                      'Pending (${allQuests.where((q) => !q.isCompletedToday).length})',
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      2,
                      'Selesai (${allQuests.where((q) => q.isCompletedToday).length})',
                    ),
                  ],
                ),
              ),
            ),

            // Quest List or Empty State
            if (filteredQuests.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🛡️', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 12),
                        Text(
                          _selectedFilterIndex == 2
                              ? 'Belum ada misi yang selesai hari ini.\nYuk mulai satu!'
                              : 'Tidak ada misi dalam kategori ini.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final quest = filteredQuests[index];
                    return QuestCard(
                      quest: quest,
                      onComplete: () {
                        HapticFeedback.mediumImpact();
                        vm.completeQuest(quest.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Text('✨ ', style: TextStyle(fontSize: 16)),
                                Expanded(
                                  child: Text(
                                    'Quest Selesai! +${quest.difficulty.expReward} EXP & +${quest.difficulty.goldReward} Gold!',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      onUndo: () => vm.undoQuest(quest.id),
                      onDelete: () => vm.deleteQuest(quest.id),
                    );
                  },
                  childCount: filteredQuests.length,
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Misi Baru',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AddQuestDialog(
              onAdd: ({
                required String title,
                required String description,
                required QuestCategory category,
                required QuestDifficulty difficulty,
              }) {
                vm.addQuest(
                  title: title,
                  description: description,
                  category: category,
                  difficulty: difficulty,
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(int index, String label) {
    final isSelected = _selectedFilterIndex == index;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppTheme.surfaceLight,
      backgroundColor: AppTheme.surface,
      side: BorderSide(
        color: isSelected ? AppTheme.primary : const Color(0xFF2E3F5B),
      ),
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
      onSelected: (val) {
        if (val) setState(() => _selectedFilterIndex = index);
      },
    );
  }
}

