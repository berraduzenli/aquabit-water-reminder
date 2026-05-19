// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      weight: fields[0] as double,
      dailyGoal: fields[1] as double,
      reminderInterval: fields[2] as int,
      gender: fields[3] as String,
      wakeHour: fields[4] as int,
      sleepHour: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.weight)
      ..writeByte(1)
      ..write(obj.dailyGoal)
      ..writeByte(2)
      ..write(obj.reminderInterval)
      ..writeByte(3)
      ..write(obj.gender)
      ..writeByte(4)
      ..write(obj.wakeHour)
      ..writeByte(5)
      ..write(obj.sleepHour);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
