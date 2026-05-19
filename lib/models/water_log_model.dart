import 'package:hive/hive.dart';

part 'water_log_model.g.dart';

@HiveType(typeId: 1)
class WaterLogModel extends HiveObject {
  @HiveField(0)
  double amount; // litre cinsinden

  @HiveField(1)
  DateTime timestamp;

  @HiveField(2)
  String type; // 'glass', 'bottle', 'custom'

  WaterLogModel({
    required this.amount,
    required this.timestamp,
    this.type = 'glass',
  });
}