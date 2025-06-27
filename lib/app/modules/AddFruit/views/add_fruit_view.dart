import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fridgeeye/app/modules/home/controllers/home_controller.dart';

class AddFruitView extends StatefulWidget {
  @override
  State<AddFruitView> createState() => _AddFruitViewState();
}

class _AddFruitViewState extends State<AddFruitView> {
  final controller = Get.find<HomeController>();
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Tambah Buah"),
        backgroundColor: const Color(0xFF3AA39F),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nama Buah',
                prefixIcon: const Icon(Icons.local_offer_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                    dateController.text =
                        DateFormat('yyyy-MM-dd').format(picked);
                  });
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: 'Tanggal Pembelian',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3AA39F),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty || selectedDate == null) return;

                final image = getFruitImage(name);

                // Cukup kirim ke backend, backend yang hitung semuanya
                await controller.addFruitToBackend({
                  'name': name.toLowerCase(),
                  'image': image,
                  'purchaseDate': selectedDate!.toIso8601String(),
                });

                Get.back();
              },
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }

  String getFruitImage(String name) {
    final nameLower = name.toLowerCase();
    if (nameLower.contains('apel')) return 'assets/images/apel.png';
    if (nameLower.contains('tomat')) return 'assets/images/tomat.png';
    if (nameLower.contains('wortel')) return 'assets/images/wortel.png';
    if (nameLower.contains('pisang')) return 'assets/images/pisang.png';
    if (nameLower.contains('semangka')) return 'assets/images/semangka.png';
    return 'assets/images/default.png';
  }
}
