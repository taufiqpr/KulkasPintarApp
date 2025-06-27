import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/history_login_controller.dart';
import 'package:intl/intl.dart';

class LoginHistoryChartView extends StatelessWidget {
  const LoginHistoryChartView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HistoryLoginController>();

    final successLogins =
        controller.loginHistory.where((e) => e['status'] == 'success').toList();

    final Map<String, int> loginPerDate = {};
    for (var item in successLogins) {
      final rawTimestamp = item['timestamp'];
      final date = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(rawTimestamp).toLocal());
      loginPerDate[date] = (loginPerDate[date] ?? 0) + 1;
    }

    final sortedKeys = loginPerDate.keys.toList()..sort();
    final maxY = (loginPerDate.values.isNotEmpty)
        ? loginPerDate.values.reduce((a, b) => a > b ? a : b) + 2
        : 5;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Success Chart"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: loginPerDate.isEmpty
            ? const Center(child: Text("Belum ada data login sukses."))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        maxY: maxY.toDouble(),
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.blueGrey,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final date = sortedKeys[group.x.toInt()];
                              return BarTooltipItem(
                                "${DateFormat('MMM dd').format(DateTime.parse(date))}\n"
                                "${rod.toY.toInt()} login",
                                const TextStyle(color: Colors.white),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 36,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index % 2 == 0 &&
                                    index >= 0 &&
                                    index < sortedKeys.length) {
                                  final date = sortedKeys[index];
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(
                                      DateFormat('MM/dd')
                                          .format(DateTime.parse(date)),
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 32,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(fontSize: 10),
                                );
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: FlGridData(
                          show: true,
                          horizontalInterval: 1,
                          drawVerticalLine: false,
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: List.generate(sortedKeys.length, (index) {
                          final date = sortedKeys[index];
                          final count = loginPerDate[date] ?? 0;
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: count.toDouble(),
                                width: 18,
                                color: Colors.teal[400],
                                borderRadius: BorderRadius.circular(4),
                                backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  toY: maxY.toDouble(),
                                  color: Colors.grey.shade200,
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
