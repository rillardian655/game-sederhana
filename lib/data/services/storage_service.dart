import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _heroKey = 'habit_quest_hero';
  static const String _questsKey = 'habit_quest_quests';
  static const String _rewardsKey = 'habit_quest_rewards';
  static const String _logsKey = 'habit_quest_logs';
  static const String _achievementsKey = 'habit_quest_achievements';
  static const String _bossesKey = 'habit_quest_bosses';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // Hero
  Map<String, dynamic>? getHero() {
    final raw = _prefs.getString(_heroKey);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<bool> saveHero(Map<String, dynamic> data) async {
    return _prefs.setString(_heroKey, jsonEncode(data));
  }

  // Quests
  List<Map<String, dynamic>> getQuests() {
    final raw = _prefs.getString(_questsKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  Future<bool> saveQuests(List<Map<String, dynamic>> data) async {
    return _prefs.setString(_questsKey, jsonEncode(data));
  }

  // Rewards
  List<Map<String, dynamic>> getRewards() {
    final raw = _prefs.getString(_rewardsKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  Future<bool> saveRewards(List<Map<String, dynamic>> data) async {
    return _prefs.setString(_rewardsKey, jsonEncode(data));
  }

  // Logs
  List<Map<String, dynamic>> getLogs() {
    final raw = _prefs.getString(_logsKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  Future<bool> saveLogs(List<Map<String, dynamic>> data) async {
    return _prefs.setString(_logsKey, jsonEncode(data));
  }

  // Achievements
  List<Map<String, dynamic>> getAchievements() {
    final raw = _prefs.getString(_achievementsKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  Future<bool> saveAchievements(List<Map<String, dynamic>> data) async {
    return _prefs.setString(_achievementsKey, jsonEncode(data));
  }

  // Bosses
  List<Map<String, dynamic>> getBosses() {
    final raw = _prefs.getString(_bossesKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  Future<bool> saveBosses(List<Map<String, dynamic>> data) async {
    return _prefs.setString(_bossesKey, jsonEncode(data));
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}

