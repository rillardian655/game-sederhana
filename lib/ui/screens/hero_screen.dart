import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/hero_model.dart';
import '../view_models/game_view_model.dart';

class HeroScreen extends StatelessWidget {
  final GameViewModel viewModel;

  const HeroScreen({super.key, required this.viewModel});

  String _getHeroTitle(int level) {
    if (level < 3) return 'Magang Petualang';
    if (level < 6) return 'Pengembara Tangguh';
    if (level < 10) return 'Ksatria Disiplin';
    if (level < 15) return 'Pahlawan Kebiasaan';
    return 'Legenda Keabadian';
  }

  @override
  Widget build(BuildContext context) {
    final hero = viewModel.hero;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/app_logo.png',
                width: 30,
                height: 30,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Text('🛡️', style: TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: 10),
            const Text('Status Pahlawan (Hero)'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar & Name Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppTheme.primary.withValues(alpha: 0.4), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Avatar with Class Icon
                  Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.surfaceLight,
                      border: Border.all(color: AppTheme.primary, width: 3),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      hero.heroClass.icon,
                      style: const TextStyle(fontSize: 42),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Name & Edit Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        hero.name,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 18, color: AppTheme.textSecondary),
                        onPressed: () => _showEditNameDialog(context),
                      ),
                    ],
                  ),

                  // Title Rank Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.primary.withValues(alpha: 0.5)),
                    ),
                    child: Text(
                      '${_getHeroTitle(hero.level)} • Level ${hero.level}',
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Class & Perk
                  Text(
                    'Kelas: ${hero.heroClass.title} (${hero.heroClass.perk})',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Class Switcher
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF2E3F5B)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih Kelas Pahlawan',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: HeroClass.values.map((hClass) {
                      final isSelected = hero.heroClass == hClass;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => viewModel.updateHeroProfile(heroClass: hClass),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.primary : AppTheme.surfaceLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? Colors.white : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(hClass.icon, style: const TextStyle(fontSize: 22)),
                                const SizedBox(height: 4),
                                Text(
                                  hClass.title,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // RPG Attributes Grid
            Row(
              children: [
                Expanded(
                  child: _buildStatTile(
                    '❤️ Health Points',
                    '${hero.currentHp} / ${hero.maxHp}',
                    AppTheme.hpRed,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatTile(
                    '⚡ Experience',
                    '${hero.currentExp} / ${hero.maxExp}',
                    AppTheme.expBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatTile(
                    '🪙 Koin Gold',
                    '${hero.gold}',
                    AppTheme.gold,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatTile(
                    '🔥 Hari Streak',
                    '${hero.streakDays} Hari',
                    Colors.orangeAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildStatTile(
              '🏆 Total Misi Diselesaikan',
              '${hero.totalQuestsCompleted} Misi Berhasil',
              AppTheme.success,
              isFullWidth: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatTile(String label, String value, Color color, {bool isFullWidth = false}) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2E3F5B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditNameDialog(BuildContext context) {
    final controller = TextEditingController(text: viewModel.hero.name);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ganti Nama Pahlawan'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Nama baru...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                viewModel.updateHeroProfile(name: controller.text.trim());
              }
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}

