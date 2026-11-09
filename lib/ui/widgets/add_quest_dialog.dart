import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/quest_model.dart';

class AddQuestDialog extends StatefulWidget {
  final Function({
    required String title,
    required String description,
    required QuestCategory category,
    required QuestDifficulty difficulty,
  }) onAdd;

  const AddQuestDialog({super.key, required this.onAdd});

  @override
  State<AddQuestDialog> createState() => _AddQuestDialogState();
}

class _AddQuestDialogState extends State<AddQuestDialog> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  QuestCategory _selectedCategory = QuestCategory.routine;
  QuestDifficulty _selectedDifficulty = QuestDifficulty.medium;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF111728),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF283652), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.2),
              blurRadius: 30,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.accentCyan.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.accentCyan.withValues(alpha: 0.4)),
                      ),
                      child: const Icon(Icons.add_task_rounded, color: AppTheme.accentCyan, size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'KONTRAK MISI BARU',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            letterSpacing: 1.1,
                          ),
                        ),
                        Text(
                          'Daftarkan kebiasaan sebagai quest RPG',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Title Field
                TextField(
                  controller: _titleController,
                  style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    labelText: 'Nama Misi / Kebiasaan',
                    hintText: 'Contoh: Olahraga 20 Menit / Baca Buku',
                    labelStyle: const TextStyle(color: AppTheme.textSecondary),
                    hintStyle: const TextStyle(color: AppTheme.textMuted),
                    filled: true,
                    fillColor: const Color(0xFF161F33),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF283652)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF283652)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppTheme.accentCyan, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Description Field
                TextField(
                  controller: _descController,
                  maxLines: 2,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Deskripsi / Catatan (Opsional)',
                    hintText: 'Target mingguan atau tips pelaksanaan...',
                    labelStyle: const TextStyle(color: AppTheme.textSecondary),
                    hintStyle: const TextStyle(color: AppTheme.textMuted),
                    filled: true,
                    fillColor: const Color(0xFF161F33),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF283652)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF283652)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppTheme.accentCyan, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Category Selector
                const Text(
                  'KATEGORI GUILD:',
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: QuestCategory.values.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return ChoiceChip(
                      label: Text('${cat.icon} ${cat.label}'),
                      selected: isSelected,
                      selectedColor: AppTheme.primary,
                      backgroundColor: const Color(0xFF161F33),
                      side: BorderSide(
                        color: isSelected ? AppTheme.primary : const Color(0xFF283652),
                      ),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppTheme.textSecondary,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                        fontSize: 12,
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _selectedCategory = cat);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Difficulty Selector
                const Text(
                  'TINGKAT KESULITAN & HADIAH:',
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: QuestDifficulty.values.map((diff) {
                    final isSelected = _selectedDifficulty == diff;
                    return ChoiceChip(
                      label: Text(
                        '${diff.icon} ${diff.label} (+${diff.expReward} EXP / +${diff.goldReward} 🪙)',
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFF2A1E4A),
                      backgroundColor: const Color(0xFF161F33),
                      side: BorderSide(
                        color: isSelected ? AppTheme.secondary : const Color(0xFF283652),
                        width: isSelected ? 1.5 : 1.0,
                      ),
                      labelStyle: TextStyle(
                        color: isSelected ? AppTheme.secondary : AppTheme.textSecondary,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                        fontSize: 11.5,
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _selectedDifficulty = diff);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal', style: TextStyle(color: AppTheme.textMuted)),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentCyan,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (_titleController.text.trim().isEmpty) return;
                        widget.onAdd(
                          title: _titleController.text,
                          description: _descController.text,
                          category: _selectedCategory,
                          difficulty: _selectedDifficulty,
                        );
                        Navigator.pop(context);
                      },
                      child: const Text(
                        '⚔️ Terima Quest!',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
