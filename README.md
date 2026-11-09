<p align="center">
  <img src="assets/images/app_logo.png" width="120" height="120" alt="HabitQuest Logo" style="border-radius: 50%;" />
</p>

# HabitQuest ⚔️ – Gamified RPG Habit & Routine Tracker

[![Flutter](https://img.shields.io/badge/Flutter-3.44+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?logo=android&logoColor=white)](https://www.android.com/)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20MVVM-8B5CF6)](#arsitektur-aplikasi)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> Ubah rutinitas harian dan kebiasaanmu menjadi petualangan epik ala game RPG! Selesaikan misi, kumpulkan EXP & Gold, naikkan level pahlawanmu, dan hindari hukuman jika bolong!

---

## ✨ Fitur Utama

### 1. ⚔️ Quest & Habit Management
* **Tingkat Kesulitan Quest:** Setiap misi memiliki reward dan konsekuensi berbeda:
  * 🟢 **Mudah:** `+20 EXP`, `+8 Gold`, penalty `-8 HP`
  * 🔵 **Sedang:** `+45 EXP`, `+18 Gold`, penalty `-15 HP`
  * 🟣 **Sulit:** `+80 EXP`, `+35 Gold`, penalty `-25 HP`
  * 🔥 **Epik:** `+150 EXP`, `+70 Gold`, penalty `-40 HP`
* **Filter Interaktif:** Filter antara Semua, Pending, dan Selesai.
* **Streak Counter:** Catat rekor berapa hari berturut-turut kamu konsisten menyelesaikan setiap misi.

### 2. 🛡️ Hero Progression & Game Mechanics
* **Sistem Level & EXP:** Kumpulkan EXP untuk naik level. Saat level naik, HP pulih penuh dan dapat bonus koin emas.
* **4 Kelas Pahlawan dengan Pasif Berbeda:**
  * ⚔️ **Warrior:** Pertahanan kokoh (+25 Base HP).
  * 🧙‍♂️ **Mage:** Penguasa ilmu & fokus (+10% Bonus EXP setiap quest).
  * 🗡️ **Rogue:** Ahli strategi (+15% Bonus Gold setiap quest).
  * 🛡️ **Paladin:** Pelindung disiplin (-20% pengurangan damage penalty).
* **Konsekuensi Nyata (Daily Rollover):** Jika kamu melewatkan quest kemarin, pahlawanmu akan terkena serangan damage HP. Jika HP habis sampai 0, pahlawan akan pingsan dan kehilangan sebagian Gold!

### 3. 🍺 Kedai Hadiah (Tavern / Self-Reward Shop)
* Gunakan Gold yang kamu dapatkan dengan susah payah untuk membeli hadiah dunia nyata:
  * 🧪 **Ramuan HP (+40 Darah):** Pulihkan darahmu setelah lelah beraktivitas.
  * ☕ **Beli Kopi / Minuman Favorit (40 Gold)**
  * 🎬 **Nonton 1 Episode Series / Anime (50 Gold)**
  * 🎮 **Main Game Bebas 1 Jam (75 Gold)**
* Tambahkan hadiah buatanmu sendiri secara bebas lengkap dengan pilihan emoji!

### 4. 📜 Catatan Petualangan (Adventure Battle Log)
* Timeline riwayat aktivitas yang mencatat setiap quest yang diselesaikan, kenaikan level, konsumsi ramuan, dan serangan damage.

---

## 🏛️ Arsitektur Aplikasi

Proyek ini menerapkan arsitektur **Clean Layered MVVM** yang terstruktur rapi:

```text
lib/
├── core/
│   └── theme/
│       └── app_theme.dart          # Tema Dark Fantasy Material 3
├── data/
│   ├── models/
│   │   ├── hero_model.dart         # Model Hero & Kelas Pahlawan
│   │   ├── quest_model.dart        # Model Misi & Tingkat Kesulitan
│   │   ├── reward_model.dart       # Model Hadiah Kedai
│   │   └── activity_log_model.dart # Model Log Aktivitas
│   ├── services/
│   │   └── storage_service.dart    # Wrapper SharedPreferences offline
│   └── repositories/
│       └── game_repository.dart    # Single source of truth & seed data
├── ui/
│   ├── view_models/
│   │   └── game_view_model.dart    # Business & game logic (ChangeNotifier)
│   ├── widgets/
│   │   ├── hero_header_card.dart   # Bar HP, EXP, Level, Gold & Streak
│   │   ├── quest_card.dart         # Kartu interaktif quest
│   │   ├── reward_card.dart        # Kartu item kedai
│   │   ├── add_quest_dialog.dart   # Dialog tambah misi
│   │   └── add_reward_dialog.dart  # Dialog tambah self-reward
│   └── screens/
│       ├── main_navigation_screen.dart
│       ├── quest_list_screen.dart
│       ├── hero_screen.dart
│       ├── tavern_shop_screen.dart
│       └── battle_log_screen.dart
└── main.dart                       # Entrypoint aplikasi
```

---

## 🚀 Cara Menjalankan Proyek

### Prasyarat
* [Flutter SDK](https://flutter.dev/docs/get-started/install) (v3.22.0 atau lebih baru)
* [Android Studio](https://developer.android.com/studio) / VS Code / Antigravity
* Perangkat Android fisik atau Emulator

### Langkah-langkah:
1. Clone repositori ini:
   ```bash
   git clone https://github.com/<username>/habit_quest.git
   cd habit_quest
   ```
2. Pasang dependencies:
   ```bash
   flutter pub get
   ```
3. Jalankan pengujian (Unit Tests):
   ```bash
   flutter test
   ```
4. Jalankan aplikasi di HP / Emulator:
   ```bash
   flutter run
   ```
5. Build file APK siap install:
   ```bash
   flutter build apk --release
   ```
   *(File APK akan berada di `build/app/outputs/flutter-apk/app-release.apk`)*

---

## 🧪 Pengujian (Testing)
Aplikasi ini dilengkapi unit test yang menguji integritas mekanisme game:
* Status awal Hero (Level, HP, Gold).
* Perhitungan EXP, Gold, dan Streak saat menyelesaikan quest.
* Validasi transaksi pembelian di kedai.
* Formula kenaikan level dan scaling batas EXP.

Jalankan pengujian dengan perintah:
```bash
flutter test
```

---

## 📜 Lisensi
Didistribusikan di bawah lisensi MIT. Lihat file `LICENSE` untuk informasi lebih lanjut.
