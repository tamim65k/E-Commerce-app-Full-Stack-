import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:amazon_clone/features/admin/model/sales.dart';

class AnalyticsChart extends StatelessWidget {
  final List<Sales> sales;

  const AnalyticsChart({
    Key? key,
    required this.sales,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxY = 0;
    for (var sale in sales) {
      if (sale.earning > maxY) {
        maxY = sale.earning.toDouble();
      }
    }
    maxY *= 1.2;
    if (maxY == 0) {
      maxY = 100;
    }

    return BarChart(
      BarChartData(
        maxY: maxY,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getBottomTitles,
              reservedSize: 38,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        gridData: FlGridData(
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
        ),
        barGroups: sales
            .asMap()
            .entries
            .map((entry) {
              int index = entry.key;
              Sales saleData = entry.value;
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: saleData.earning.toDouble(),
                    color: Colors.amber,
                    width: 22,
                    borderRadius: BorderRadius.zero,
                  ),
                ],
              );
            })
            .toList(),
      ),
    );
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black54,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    Widget text;
    if (value.toInt() < sales.length) {
      text = Text(sales[value.toInt()].label, style: style);
    } else {
      text = const Text('', style: style);
    }

    return SideTitleWidget(
      meta: meta, // FIX: Pass the 'meta' parameter
      space: 16,
      child: text,
    );
  }
}