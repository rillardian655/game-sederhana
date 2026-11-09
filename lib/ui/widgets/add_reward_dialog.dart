import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AddRewardDialog extends StatefulWidget {
  final Function({
    required String title,
    required String description,
    required int costGold,
    required String icon,
  }) onAdd;

  const AddRewardDialog({super.key, required this.onAdd});

  @override
  State<AddRewardDialog> createState() => _AddRewardDialogState();
}

class _AddRewardDialogState extends State<AddRewardDialog> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _costController = TextEditingController(text: '50');
  String _selectedIcon = '🎁';

  final List<String> _quickIcons = ['🎁', '☕', '🍕', '🎮', '🎬', '🍦', '🛍️', '🏖️', '🎧', '🍰'];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _costController.dispose();
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
              const Row(
                children: [
                  Text('🍺', style: TextStyle(fontSize: 22)),
                  SizedBox(width: 8),
                  Text(
                    'Tambah Hadiah Self-Reward',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Title
              TextField(
                controller: _titleController,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Nama Hadiah / Aktivitas Santai',
                  hintText: 'Contoh: Nonton Bioskop / Beli Buku Baru',
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

              // Description
              TextField(
                controller: _descController,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Deskripsi Singkat',
                  hintText: 'Self-reward setelah streak 5 hari!',
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

              // Gold Cost
              TextField(
                controller: _costController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Harga Tukar (Gold 🪙)',
                  labelStyle: const TextStyle(color: AppTheme.textSecondary),
                  prefixIcon: const Icon(Icons.monetization_on_outlined, color: AppTheme.gold),
                  filled: true,
                  fillColor: AppTheme.surfaceLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Icon Picker
              const Text(
                'Pilih Ikon:',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _quickIcons.map((ic) {
                  final isSelected = _selectedIcon == ic;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIcon = ic),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.gold.withValues(alpha: 0.3) : AppTheme.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppTheme.gold : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(ic, style: const TextStyle(fontSize: 22)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Actions
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
                      final cost = int.tryParse(_costController.text) ?? 50;
                      widget.onAdd(
                        title: _titleController.text,
                        description: _descController.text,
                        costGold: cost.clamp(5, 9999),
                        icon: _selectedIcon,
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.gold, foregroundColor: Colors.black87),
                    child: const Text('Simpan Hadiah'),
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

