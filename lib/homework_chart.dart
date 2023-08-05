import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notion_api/item_model.dart';
import 'package:flutter_notion_api/main.dart';

class HomeworkChart extends StatelessWidget {
  final List<Item> items;

  const HomeworkChart({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homework = <String, int>{};

    // Update homework map
    items.forEach((item) =>
        homework.update(item.subject, (value) => value + 1, ifAbsent: () => 1));
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        padding: EdgeInsets.all(16.0),
        height: 360.0,
        child: Column(
          children: [
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: homework
                      .map((subject, quantity) => MapEntry(
                            subject,
                            PieChartSectionData(
                              color: getSubjectColor(subject),
                              radius: 100.0,
                              title: quantity.toString(),
                              value: quantity.toDouble(),
                            ),
                          ))
                      .values
                      .toList(),
                  sectionsSpace: 0,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Wrap(
              spacing: 10.0,
              runSpacing: 8.0,
              children: homework.keys
                  .map((subject) => _Indicator(
                        color: getSubjectColor(subject),
                        text: subject,
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  final Color color;
  final String text;
  const _Indicator({Key? key, required this.color, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Small square telling the color
        Container(height: 16.0, width: 16.0, color: color),
        // Space between color and text
        SizedBox(width: 4.0),
        // Text telling the subject
        Text(text, style: TextStyle(fontWeight: FontWeight.w500))
      ],
    );
  }
}
