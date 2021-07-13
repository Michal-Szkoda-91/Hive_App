import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wireless_hive/models/hive.dart';

class ChartCard extends StatefulWidget {
  const ChartCard({
    @required this.hive,
  });

  final HiveModel hive;

  @override
  _ChartCardState createState() => _ChartCardState();
}

class _ChartCardState extends State<ChartCard> {
  var _isInit = true;
  bool _dataLoaded = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<HiveListModel>(context)
          .getDetectorDataToHive(widget.hive.hiveId)
          .then((_) {
        _dataLoaded = true;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: !_dataLoaded
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildContainer(
                  context,
                  'Temperatura w ulu: ',
                  widget.hive.tempInside,
                  widget.hive.tempInsideDate,
                  '°C',
                ),
                buildContainer(context, 'Wilgotność: ', widget.hive.humidity,
                    widget.hive.humidityDate, '%'),
                buildContainer(
                  context,
                  'Waga: ',
                  widget.hive.weight,
                  widget.hive.weightDate,
                  'kg',
                ),
                buildContainer(
                  context,
                  'Temperatura na zewnątrz: ',
                  widget.hive.tempOutside,
                  widget.hive.tempOutsideDate,
                  '°C',
                ),
              ],
            ),
    );
  }

  Card buildContainer(BuildContext context, String title,
      List<double> listValue, List<double> listTime, String unity) {
    return Card(
      child: Container(
        width: double.infinity,
        color: Colors.orange[100],
        height: 350,
        child: Column(
          children: [
            Text(
              title + ' ${listValue[9]} ' + unity,
              style: Theme.of(context).textTheme.headline2,
            ),
            Expanded(
              child: LineChart(
                chartData(listValue, listTime),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData chartData(List<double> listValue, List<double> listTime) {
    double max = listValue.reduce((curr, next) => curr > next ? curr : next);
    double min = listValue.reduce((curr, next) => curr < next ? curr : next);
    return LineChartData(
      titlesData: FlTitlesData(
        leftTitles: SideTitles(
          showTitles: true,
          reservedSize: 25,
        ),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 3,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 1,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: listTime[0] - 1,
      maxX: listTime[9] + 1,
      maxY: max + 0.5,
      minY: min - 0.5,
      lineBarsData: linesBarData1(listValue, listTime),
    );
  }

  List<LineChartBarData> linesBarData1(List listValue, List listTime) {
    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: [
        FlSpot(listTime[0], listValue[0]),
        FlSpot(listTime[1], listValue[1]),
        FlSpot(listTime[2], listValue[2]),
        FlSpot(listTime[3], listValue[3]),
        FlSpot(listTime[4], listValue[4]),
        FlSpot(listTime[5], listValue[5]),
        FlSpot(listTime[6], listValue[6]),
        FlSpot(listTime[7], listValue[7]),
        FlSpot(listTime[8], listValue[8]),
        FlSpot(listTime[9], listValue[9]),
      ],
      isCurved: true,
      colors: [Colors.orange],
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return [lineChartBarData1];
  }
}
