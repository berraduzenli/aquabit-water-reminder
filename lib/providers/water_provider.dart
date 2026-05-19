import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/water_log_model.dart';
import '../services/hive_service.dart';

class WaterProvider extends ChangeNotifier {
  UserModel? _user;
  List<WaterLogModel> _todayLogs = [];
  int _currentIndex = 0;

  UserModel? get user => _user;
  List<WaterLogModel> get todayLogs => _todayLogs;
  int get currentIndex => _currentIndex;

  double get todayTotal => HiveService.getTodayTotal();
  double get dailyGoal => _user?.dailyGoal ?? 2.0;
  double get progress =>
      dailyGoal <= 0 ? 0 : (todayTotal / dailyGoal).clamp(0.0, 1.0);
  bool get goalReached => todayTotal >= dailyGoal;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void loadData() {
    _user = HiveService.getUser();
    _todayLogs = HiveService.getTodayLogs();
    notifyListeners();
  }

  Future<void> saveUser({
    required double weight,
    required String gender,
    required int wakeHour,
    required int sleepHour,
  }) async {
    final goal = UserModel.calculateDailyGoal(weight, gender);

    final user = UserModel(
      weight: weight,
      dailyGoal: goal,
      gender: gender,
      wakeHour: wakeHour,
      sleepHour: sleepHour,
    );

    await HiveService.saveUser(user);
    _user = user;
    notifyListeners();
  }

  Future<void> updateUserSettings({
    required double weight,
    required String gender,
    required int wakeHour,
    required int sleepHour,
    double? customDailyGoal,
  }) async {
    final goal =
        customDailyGoal ?? UserModel.calculateDailyGoal(weight, gender);

    final updatedUser = UserModel(
      weight: weight,
      dailyGoal: goal,
      gender: gender,
      wakeHour: wakeHour,
      sleepHour: sleepHour,
    );

    await HiveService.saveUser(updatedUser);
    _user = updatedUser;
    notifyListeners();
  }

  Future<void> updateDailyGoal(double newGoal) async {
    if (_user == null) return;

    final updatedUser = UserModel(
      weight: _user!.weight,
      dailyGoal: newGoal,
      gender: _user!.gender,
      wakeHour: _user!.wakeHour,
      sleepHour: _user!.sleepHour,
    );

    await HiveService.saveUser(updatedUser);
    _user = updatedUser;
    notifyListeners();
  }

  Future<void> addWater(double amount, String type) async {
    final log = WaterLogModel(
      amount: amount,
      timestamp: DateTime.now(),
      type: type,
    );

    await HiveService.addWaterLog(log);
    _todayLogs = HiveService.getTodayLogs();
    notifyListeners();
  }

  Future<void> removeLastLog() async {
    if (_todayLogs.isEmpty) return;

    final last = _todayLogs.last;
    await last.delete();

    _todayLogs = HiveService.getTodayLogs();
    notifyListeners();
  }

  int getStreak() {
    int streak = 0;
    DateTime day = DateTime.now();

    while (true) {
      final logs = HiveService.getLogsForDay(day);
      final total = logs.fold(0.0, (sum, log) => sum + log.amount);

      if (total >= dailyGoal) {
        streak++;
        day = day.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  List<double> getWeeklyData() {
    List<double> data = [];

    for (int i = 6; i >= 0; i--) {
      final day = DateTime.now().subtract(Duration(days: i));
      final logs = HiveService.getLogsForDay(day);
      final total = logs.fold(0.0, (sum, log) => sum + log.amount);
      data.add(total);
    }

    return data;
  }
}
