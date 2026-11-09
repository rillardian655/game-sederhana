import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/hero_model.dart';
import '../../data/models/achievement_model.dart';
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

  Color _getClassColor(HeroClass heroClass) {
    switch (heroClass) {
      case HeroClass.warrior:
        return AppTheme.hpRed;
      case HeroClass.mage:
        return AppTheme.primary;
      case HeroClass.rogue:
        return AppTheme.gold;
      case HeroClass.paladin:
        return AppTheme.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hero = viewModel.hero;
    final classColor = _getClassColor(hero.heroClass);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: classColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: classColor.withValues(alpha: 0.4)),
              ),
              child: const Icon(Icons.shield_outlined, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STATUS PAHLAWAN',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'Karakter, Atribut & Gelar Kehormatan',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
        child: Column(
          children: [
            // Character Codex Card
            _buildCharacterHeroCard(context, hero, classColor),
            const SizedBox(height: 18),

            // Class Switcher Deck
            _buildClassDeck(hero),
            const SizedBox(height: 18),

            // RPG Attributes Vault
            _buildAttributesVault(hero),
            const SizedBox(height: 22),

            // Achievements Hall
            _buildAchievementsHall(context),
            const SizedBox(height: 22),

            // Time Altar / Demo Simulator
            _buildTimeAltarCard(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterHeroCard(BuildContext context, HeroModel hero, Color classColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            classColor.withValues(alpha: 0.22),
            const Color(0xFF13192B),
            const Color(0xFF0D121F),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: classColor.withValues(alpha: 0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: classColor.withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Crest Frame & Level Medallion
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      classColor.withValues(alpha: 0.35),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF161E30),
                  border: Border.all(color: classColor, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: classColor.withValues(alpha: 0.5),
                      blurRadius: 16,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  hero.heroClass.icon,
                  style: const TextStyle(fontSize: 40),
                ),
              ),
              Positioned(
                bottom: -2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFF8800)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    'LV.${hero.level}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Hero Name with Edit Button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                hero.name,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => _showEditNameDialog(context),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    size: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Title Ribbon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: classColor.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: classColor.withValues(alpha: 0.45)),
            ),
            child: Text(
              _getHeroTitle(hero.level).toUpperCase(),
              style: TextStyle(
                color: classColor,
                fontWeight: FontWeight.w800,
                fontSize: 11.5,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Class Lore & Perk
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome_rounded, size: 14, color: classColor),
                const SizedBox(width: 8),
                Text(
                  '${hero.heroClass.title} • ${hero.heroClass.perk}',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassDeck(HeroModel hero) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111728),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF283652)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.workspace_premium_rounded, size: 18, color: AppTheme.accentCyan),
              SizedBox(width: 8),
              Text(
                'PILIH KELAS PETUALANG',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: HeroClass.values.map((hClass) {
              final isSelected = hero.heroClass == hClass;
              final color = _getClassColor(hClass);

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    viewModel.updateHeroProfile(heroClass: hClass);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.1)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )
                          : const LinearGradient(
                              colors: [Color(0xFF161F33), Color(0xFF111728)],
                            ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? color : const Color(0xFF283652),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: 0.3),
                                blurRadius: 10,
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      children: [
                        Text(hClass.icon, style: const TextStyle(fontSize: 26)),
                        const SizedBox(height: 6),
                        Text(
                          hClass.title,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppTheme.textSecondary,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          hClass.perk.split(' ')[0],
                          style: TextStyle(
                            color: isSelected ? color : AppTheme.textMuted,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
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
    );
  }

  Widget _buildAttributesVault(HeroModel hero) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            children: [
              Icon(Icons.analytics_rounded, size: 18, color: AppTheme.gold),
              SizedBox(width: 8),
              Text(
                'ATRIBUT & PRESTASI KINERJA',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildVaultStatCard(
                icon: Icons.favorite_rounded,
                title: 'HEALTH POINT',
                value: '${hero.currentHp}/${hero.maxHp}',
                color: AppTheme.hpRed,
                subtitle: 'Daya tahan hidup',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildVaultStatCard(
                icon: Icons.bolt_rounded,
                title: 'EXPERIENCE',
                value: '${hero.currentExp}/${hero.maxExp}',
                color: AppTheme.expBlue,
                subtitle: 'Kemajuan level',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildVaultStatCard(
                icon: Icons.monetization_on_rounded,
                title: 'GOLD COINS',
                value: '${hero.gold}',
                color: AppTheme.gold,
                subtitle: 'Untuk kedai & skill',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildVaultStatCard(
                icon: Icons.local_fire_department_rounded,
                title: 'STREAK HARI',
                value: '${hero.streakDays} Hari',
                color: Colors.deepOrangeAccent,
                subtitle: 'Kedisiplinan runtut',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF111728),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF283652)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.success.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.military_tech_rounded, color: AppTheme.success, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TOTAL MISI DITUNTASKAN',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${hero.totalQuestsCompleted} Misi Kebiasaan Selesai',
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.check_circle_outline_rounded, color: AppTheme.success, size: 22),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVaultStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111728),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF283652)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 10.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsHall(BuildContext context) {
    final achievements = viewModel.achievements;
    final unlockedCount = achievements.where((a) => a.isUnlocked).length;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111728),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF283652)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.emoji_events_rounded, size: 20, color: AppTheme.gold),
                  SizedBox(width: 8),
                  Text(
                    'DEWAN TROFI & PENGHARGAAN',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.gold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.gold.withValues(alpha: 0.4)),
                ),
                child: Text(
                  '$unlockedCount / ${achievements.length} Terbuka',
                  style: const TextStyle(
                    color: AppTheme.gold,
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: achievements.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final ach = achievements[index];
              return _buildAchievementCard(context, ach);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(BuildContext context, AchievementModel ach) {
    final isReadyToClaim = ach.isUnlocked && !ach.isClaimed;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isReadyToClaim
            ? AppTheme.gold.withValues(alpha: 0.12)
            : const Color(0xFF151D30),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isReadyToClaim
              ? AppTheme.gold.withValues(alpha: 0.6)
              : (ach.isClaimed ? const Color(0xFF25344F) : const Color(0xFF1C273C)),
          width: isReadyToClaim ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ach.isUnlocked ? const Color(0xFF1E283F) : Colors.black26,
              border: Border.all(
                color: ach.isUnlocked ? AppTheme.gold.withValues(alpha: 0.5) : Colors.transparent,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              ach.isUnlocked ? ach.icon : '🔒',
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ach.title,
                  style: TextStyle(
                    color: ach.isUnlocked ? AppTheme.textPrimary : AppTheme.textMuted,
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  ach.description,
                  style: TextStyle(
                    color: ach.isUnlocked ? AppTheme.textSecondary : AppTheme.textMuted,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppTheme.expBlue.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '+${ach.rewardExp} EXP',
                        style: const TextStyle(
                          color: AppTheme.expBlue,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppTheme.gold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '+${ach.rewardGold} Gold',
                        style: const TextStyle(
                          color: AppTheme.gold,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isReadyToClaim) ...[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.gold,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
              ),
              onPressed: () {
                HapticFeedback.heavyImpact();
                viewModel.claimAchievement(ach.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color(0xFF1E283F),
                    content: Text(
                      '🏆 Trofi "${ach.title}" berhasil diklaim!',
                      style: const TextStyle(color: AppTheme.gold, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
              child: const Text('Klaim', style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ] else if (ach.isClaimed) ...[
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppTheme.success.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, color: AppTheme.success, size: 20),
            ),
          ] else ...[
            const Icon(Icons.lock_outline_rounded, color: AppTheme.textMuted, size: 20),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeAltarCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B142F), Color(0xFF111728)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.hourglass_top_rounded, size: 20, color: AppTheme.secondary),
              SizedBox(width: 8),
              Text(
                'ALTAR WAKTU (DEMO SIMULATOR)',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Uji logika penalti HP dan reset quest harian secara instan seolah-olah 1 hari sudah berlalu.',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 11.5, height: 1.4),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.fast_forward_rounded, size: 18),
            label: const Text(
              'Simulasikan Hari Baru (+24 Jam)',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            onPressed: () {
              HapticFeedback.vibrate();
              viewModel.simulateNextDay();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('⚡ Simulasi hari baru aktif! Periksa HP & Quest harian.'),
                ),
              );
            },
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
        backgroundColor: const Color(0xFF13192B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF283652)),
        ),
        title: const Text(
          'Ganti Nama Pahlawan',
          style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: 'Nama baru...',
            hintStyle: const TextStyle(color: AppTheme.textMuted),
            filled: true,
            fillColor: const Color(0xFF1B243B),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
            ),
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
