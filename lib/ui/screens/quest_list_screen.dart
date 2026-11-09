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
  int _selectedFilterIndex = 0; // 0: Semua, 1: Pending, 2: Selesai

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;
    final allQuests = vm.quests;

    final filteredQuests = allQuests.where((q) {
      if (_selectedFilterIndex == 1) return !q.isCompletedToday;
      if (_selectedFilterIndex == 2) return q.isCompletedToday;
      return true;
    }).toList();

    final pendingCount = allQuests.where((q) => !q.isCompletedToday).length;
    final doneCount = allQuests.where((q) => q.isCompletedToday).length;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.primaryGlow, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/app_logo.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Text('⚔️', style: TextStyle(fontSize: 18))),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'HABITQUEST',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  'Papan Misi & Kebiasaan Harian',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => vm.init(),
        color: AppTheme.primary,
        backgroundColor: AppTheme.surface,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Hero Status Header Card
            SliverToBoxAdapter(
              child: HeroHeaderCard(
                hero: vm.hero,
                onTapProfile: widget.onNavigateToHero,
              ),
            ),

            // Daily Progress Objective Banner
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF15223A), Color(0xFF10192A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.borderLight,
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppTheme.secondary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.track_changes_rounded,
                                color: AppTheme.secondary,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Target Misi Hari Ini',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.secondary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.secondary.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            '$doneCount / ${allQuests.length} (${(vm.todayProgress * 100).toInt()}%)',
                            style: const TextStyle(
                              color: AppTheme.secondary,
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        height: 8,
                        color: const Color(0xFF0D1726),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: constraints.maxWidth * vm.todayProgress,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Segmented Game Filter Bar
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderLight, width: 1),
                ),
                child: Row(
                  children: [
                    _buildSegmentFilter(0, 'Semua', allQuests.length),
                    _buildSegmentFilter(1, 'Pending', pendingCount),
                    _buildSegmentFilter(2, 'Selesai', doneCount),
                  ],
                ),
              ),
            ),

            // Quests List or Empty State
            if (filteredQuests.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceLight,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppTheme.borderGlow, width: 1.5),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _selectedFilterIndex == 2 ? '🏆' : '📜',
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _selectedFilterIndex == 2
                              ? 'Belum ada misi yang selesai hari ini.\nYuk selesaikan satu misi pertamamu!'
                              : 'Tidak ada misi aktif.\nTambahkan misi baru untuk mulai berpetualang!',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 13,
                            height: 1.4,
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
                                const Text('⚔️ ', style: TextStyle(fontSize: 16)),
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

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: AppTheme.purpleGradient,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.4),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add_task_rounded, size: 20),
          label: const Text(
            'Misi Baru',
            style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5),
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
      ),
    );
  }

  Widget _buildSegmentFilter(int index, String label, int count) {
    final isSelected = _selectedFilterIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => _selectedFilterIndex = index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            gradient: isSelected ? AppTheme.purpleGradient : null,
            color: isSelected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.25)
                      : AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
