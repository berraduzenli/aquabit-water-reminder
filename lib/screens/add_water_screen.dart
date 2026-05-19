import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/water_provider.dart';

class AddWaterScreen extends StatefulWidget {
  const AddWaterScreen({super.key});

  @override
  State<AddWaterScreen> createState() => _AddWaterScreenState();
}

class _AddWaterScreenState extends State<AddWaterScreen> {
  final TextEditingController _controller = TextEditingController();
  String _unit = 'ml';
  int _selectedAmount = 250;

  final List<Map<String, dynamic>> _quickAmounts = [
    {'label': '☕', 'name': 'Küçük Bardak', 'amount': 150},
    {'label': '🥛', 'name': 'Bardak', 'amount': 250},
    {'label': '🍶', 'name': 'Büyük Bardak', 'amount': 350},
    {'label': '🧴', 'name': 'Küçük Şişe', 'amount': 330},
    {'label': '🍼', 'name': 'Şişe', 'amount': 500},
    {'label': '🫙', 'name': 'Büyük Şişe', 'amount': 1000},
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Su Ekle 💧',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
              ),
            ),
            const SizedBox(height: 24),

            // Özel miktar
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Özel Miktar',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D47A1),
                          fontSize: 16)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                            hintText: '0',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      // ml / L seçici
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F8FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: ['ml', 'L'].map((unit) {
                            final selected = _unit == unit;
                            return GestureDetector(
                              onTap: () => setState(() => _unit = unit),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? const Color(0xFF2196F3)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  unit,
                                  style: TextStyle(
                                    color:
                                        selected ? Colors.white : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                      'Özel bir miktar girerek su tüketiminizi kaydedin.',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Hızlı seçim
            const Text('Hızlı Seçim',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1),
                    fontSize: 16)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _quickAmounts.map((item) {
                final selected = _selectedAmount == item['amount'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAmount = item['amount'];
                      _controller.text = item['amount'].toString();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF2196F3) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFF2196F3)
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(item['label'],
                            style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 6),
                        Text(
                          '${item['amount']}ml',
                          style: TextStyle(
                            color: selected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const Spacer(),

            // Su Ekle butonu
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  final text = _controller.text.trim();
                  if (text.isEmpty) return;
                  double amount = double.tryParse(text) ?? 0;
                  if (_unit == 'ml') amount = amount / 1000;
                  if (amount <= 0) return;
                  context.read<WaterProvider>().addWater(amount, 'custom');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '${_unit == 'ml' ? text : (amount * 1000).toInt()} ml eklendi! 💧'),
                      backgroundColor: const Color(0xFF2196F3),
                    ),
                  );
                  _controller.clear();
                },
                icon: const Icon(Icons.water_drop),
                label: const Text('Su Ekle',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
