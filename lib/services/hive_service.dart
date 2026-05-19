import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';
import '../models/water_log_model.dart';

class HiveService {
  static const String userBoxName = 'userBox';
  static const String waterLogBoxName = 'waterLogBox';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(WaterLogModelAdapter());
    await Hive.openBox<UserModel>(userBoxName);
    await Hive.openBox<WaterLogModel>(waterLogBoxName);
  }

  static Box<UserModel> get userBox => Hive.box<UserModel>(userBoxName);
  static Box<WaterLogModel> get waterLogBox =>
      Hive.box<WaterLogModel>(waterLogBoxName);

  static UserModel? getUser() => userBox.get('user');

  static Future<void> saveUser(UserModel user) async {
    await userBox.put('user', user);
  }

  static Future<void> addWaterLog(WaterLogModel log) async {
    await waterLogBox.add(log);
  }

  static List<WaterLogModel> getTodayLogs() {
    return getLogsForDay(DateTime.now());
  }

  static List<WaterLogModel> getLogsForDay(DateTime day) {
    return waterLogBox.values.where((log) {
      return log.timestamp.year == day.year &&
          log.timestamp.month == day.month &&
          log.timestamp.day == day.day;
    }).toList();
  }

  static double getTodayTotal() {
    return getTodayLogs().fold(0, (sum, log) => sum + log.amount);
  }
}
