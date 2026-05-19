import 'package:flutter/material.dart';
import '../services/hive_service.dart';
import '../models/water_log_model.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final allLogs = HiveService.waterLogBox.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    // Günlere göre grupla
    final Map<String, List<WaterLogModel>> grouped = {};
    for (final log in allLogs) {
      final key =
          '${log.timestamp.day.toString().padLeft(2, '0')}.${log.timestamp.month.toString().padLeft(2, '0')}.${log.timestamp.year}';
      grouped.putIfAbsent(key, () => []).add(log);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        title: const Text('Geçmiş', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: grouped.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.water_drop_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Henüz kayıt yok', style: TextStyle(color: Colors.grey, fontSize: 18)),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: grouped.entries.map((entry) {
                final dayTotal = entry.value.fold(0.0, (sum, log) => sum + log.amount);
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ExpansionTile(
                    title: Text(
                      entry.key,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
                    ),
                    subtitle: Text(
                      'Toplam: ${dayTotal.toStringAsFixed(2)} L',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    leading: const Icon(Icons.calendar_today, color: Color(0xFF2196F3)),
                    children: entry.value.map((log) {
                      return ListTile(
                        leading: const Icon(Icons.water_drop, color: Color(0xFF2196F3)),
                        title: Text('${(log.amount * 1000).toInt()} ml'),
                        trailing: Text(
                          '${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            ),
    );
  }
}