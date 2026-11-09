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
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Row(
                children: [
                  Text('📜', style: TextStyle(fontSize: 22)),
                  SizedBox(width: 8),
                  Text(
                    'Tambah Misi / Habit Baru',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Title Field
              TextField(
                controller: _titleController,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Nama Misi / Kebiasaan',
                  hintText: 'Contoh: Minum 2L Air / Belajar Koding',
                  labelStyle: const TextStyle(color: AppTheme.textSecondary),
                  hintStyle: const TextStyle(color: AppTheme.textMuted),
                  filled: true,
                  fillColor: AppTheme.surfaceLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
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
                  labelText: 'Deskripsi / Alasan (Opsional)',
                  hintText: 'Biar badan segar & nggak dehidrasi...',
                  labelStyle: const TextStyle(color: AppTheme.textSecondary),
                  hintStyle: const TextStyle(color: AppTheme.textMuted),
                  filled: true,
                  fillColor: AppTheme.surfaceLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Category Selector
              const Text(
                'Kategori:',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
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
                    backgroundColor: AppTheme.surfaceLight,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
                'Tingkat Kesulitan:',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
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
                    selectedColor: AppTheme.secondary,
                    backgroundColor: AppTheme.surfaceLight,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black87 : AppTheme.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
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
                  const SizedBox(width: 8),
                  ElevatedButton(
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
                    child: const Text('Terima Quest!'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

