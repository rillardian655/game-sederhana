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
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF111728),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF283652), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppTheme.gold.withValues(alpha: 0.2),
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.gold.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.gold.withValues(alpha: 0.4)),
                      ),
                      child: const Icon(Icons.redeem_rounded, color: AppTheme.gold, size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DAFTAR HADIAH KEDAI',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            letterSpacing: 1.1,
                          ),
                        ),
                        Text(
                          'Hadiahi dirimu setelah menyelesaikan misi',
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

                // Title
                TextField(
                  controller: _titleController,
                  style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    labelText: 'Nama Hadiah / Aktivitas Santai',
                    hintText: 'Contoh: Nonton Bioskop / Kopi Sore',
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
                      borderSide: const BorderSide(color: AppTheme.gold, width: 1.5),
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
                      borderSide: const BorderSide(color: AppTheme.gold, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Gold Cost
                TextField(
                  controller: _costController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    labelText: 'Harga Tukar (Gold)',
                    labelStyle: const TextStyle(color: AppTheme.textSecondary),
                    prefixIcon: const Icon(Icons.monetization_on_rounded, color: AppTheme.gold),
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
                      borderSide: const BorderSide(color: AppTheme.gold, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Icon Picker
                const Text(
                  'PILIH IKON BARANG:',
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                    letterSpacing: 0.8,
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
                          color: isSelected
                              ? AppTheme.gold.withValues(alpha: 0.25)
                              : const Color(0xFF161F33),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppTheme.gold : const Color(0xFF283652),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(ic, style: const TextStyle(fontSize: 22)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Buttons
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
                        backgroundColor: AppTheme.gold,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (_titleController.text.trim().isEmpty) return;
                        final cost = int.tryParse(_costController.text.trim()) ?? 50;
                        widget.onAdd(
                          title: _titleController.text.trim(),
                          description: _descController.text.trim(),
                          costGold: cost,
                          icon: _selectedIcon,
                        );
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Pajang di Kedai',
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
