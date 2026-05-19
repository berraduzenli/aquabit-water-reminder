import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  double weight;

  @HiveField(1)
  double dailyGoal;

  @HiveField(2)
  int reminderInterval;

  @HiveField(3)
  String gender; // 'male' veya 'female'

  @HiveField(4)
  int wakeHour;

  @HiveField(5)
  int sleepHour;

  UserModel({
    required this.weight,
    required this.dailyGoal,
    this.reminderInterval = 60,
    this.gender = 'female',
    this.wakeHour = 8,
    this.sleepHour = 22,
  });

  static double calculateDailyGoal(double weight, String gender) {
    double multiplier = gender == 'male' ? 40 : 35;
    return (weight * multiplier) / 1000;
  }
}
