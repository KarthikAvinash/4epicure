import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import '../globals.dart';
Widget getPieChart(BuildContext context, Map<String, dynamic> dataMap) {
  final doubleDataMap =
      dataMap.map((key, value) => MapEntry(key, value.toDouble()));
  List<Color> colorList = [
    Colors.redAccent,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.yellowAccent,
    Colors.purpleAccent,
    Colors.tealAccent,
  ];

  return Card(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: math.min(
            MediaQuery.of(context).size.width < 600
                ? MediaQuery.of(context).size.width / 2.5
                : 300,
            300,
          ),
          // height: math.min(
          //   MediaQuery.of(context).size.width < 600
          //       ? M
          //       : 300,
          //   300,
          // ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Distribution of Nutrients',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(fontSize: 10),
                ),
              ),
              PieChart(
                dataMap: doubleDataMap.cast<String, double>(),
                animationDuration: const Duration(milliseconds: 1500),
                chartLegendSpacing: 32,
                chartRadius: math.min(
                  MediaQuery.of(context).size.width < 600
                      ? MediaQuery.of(context).size.width / 4
                      : 300,
                  300,
                ),
                colorList: colorList,
                initialAngleInDegree: 0,
                chartType: ChartType.ring,
                centerText: "Nutrients",
                legendOptions: LegendOptions(
                  showLegends: false,
                ),
                chartValuesOptions: ChartValuesOptions(
                  showChartValueBackground: false,
                  showChartValues: false,
                ),
                ringStrokeWidth: 32,
                emptyColor: Colors.grey,
                baseChartColor: Colors.transparent,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Source: 4epicure',
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < doubleDataMap.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2.0,
                    horizontal: 4.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorList[i],
                        ),
                      ),
                      SizedBox(width: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "${doubleDataMap.keys.toList()[i]}: ${doubleDataMap.values.toList()[i]} (${((doubleDataMap.values.toList()[i] / doubleDataMap.values.reduce((a, b) => a + b)) * 100).toStringAsFixed(1)}%)",
                          style: TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}
