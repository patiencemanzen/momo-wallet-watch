import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:telephony/telephony.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  List<ChartSampleData>? chartData;
  late bool isCardView = false;
  final Telephony telephony = Telephony.instance;

  List<SmsMessage> messages = [];
  List<SmsMessage> filteredMessages = [];

  @override
  void initState() {
    chartData = <ChartSampleData>[
      ChartSampleData(x: DateTime(2000), y: 4, secondSeriesYValue: 2.6),
      ChartSampleData(x: DateTime(2001), y: 3.0, secondSeriesYValue: 2.8),
      ChartSampleData(x: DateTime(2002), y: 3.8, secondSeriesYValue: 2.6),
      ChartSampleData(x: DateTime(2003), y: 3.4, secondSeriesYValue: 3),
      ChartSampleData(x: DateTime(2004), y: 3.2, secondSeriesYValue: 3.6),
      ChartSampleData(x: DateTime(2005), y: 3.9, secondSeriesYValue: 3),
    ];
    super.initState();
    fetchMessages();
  }

  void fetchMessages() async {
    List<SmsMessage> smsMessages = await telephony.getInboxSms(
      columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
    );

    // Filter messages right after fetching
    final filtered = smsMessages
        .where((message) =>
            message.address == "M-Money" &&
            message.body != null &&
            message.body!.trim().isNotEmpty)
        .toList();

    setState(() {
      messages = smsMessages; // Keep the original list of messages
      filteredMessages =
          filtered; // Update filteredMessages with the filtered list
    });
  }

  IconData getTransactionIcon(String messageBody) {
    if (messageBody.contains("received") ||
        messageBody.contains("deposit") ||
        messageBody.contains("credited") ||
        messageBody.contains("recieved")) {
      return Icons.arrow_upward; // Upward green arrow icon
    } else if (messageBody.contains("sent") ||
        messageBody.contains("payment") ||
        messageBody.contains("transferred")) {
      return Icons.arrow_downward; // Downward red arrow icon
    } else {
      return Icons.help;
    }
  }

  Color getIconColor(IconData icon) {
    // Assign color based on the icon
    if (icon == Icons.arrow_upward) {
      return Colors.green;
    } else if (icon == Icons.arrow_downward) {
      return Colors.red;
    } else {
      return Colors.grey; // Default color
    }
  }

  List<AreaSeries<ChartSampleData, DateTime>> _getDefaultAreaSeries() {
    return <AreaSeries<ChartSampleData, DateTime>>[
      AreaSeries<ChartSampleData, DateTime>(
        dataSource: chartData,
        opacity: 0.7,
        name: 'Incomes',
        xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
      ),
      AreaSeries<ChartSampleData, DateTime>(
        dataSource: chartData,
        opacity: 0.7,
        name: 'Expenses',
        xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
        yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
      )
    ];
  }

  @override
  void dispose() {
    chartData!.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 0.0,
                  margin: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SfCartesianChart(
                      legend: Legend(isVisible: !isCardView, opacity: 0.7),
                      title: ChartTitle(
                          text:
                              isCardView ? '' : 'Monthly Transaction analysis'),
                      plotAreaBorderWidth: 0,
                      primaryXAxis: DateTimeAxis(
                          dateFormat: DateFormat.y(),
                          interval: 1,
                          intervalType: DateTimeIntervalType.years,
                          majorGridLines: const MajorGridLines(width: 0),
                          edgeLabelPlacement: EdgeLabelPlacement.shift),
                      primaryYAxis: const NumericAxis(
                          labelFormat: '{value}M',
                          interval: 1,
                          axisLine: AxisLine(width: 0),
                          majorTickLines: MajorTickLines(size: 0)),
                      series: _getDefaultAreaSeries(),
                      tooltipBehavior: TooltipBehavior(enable: true),
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: SizedBox(
                    height: 400, // Set a fixed height for the ListView
                    child: ListView.builder(
                      itemCount: filteredMessages.length,
                      itemBuilder: (context, index) {
                        final message = filteredMessages[index];
                        final icon = getTransactionIcon(message.body!);
                        final iconColor = getIconColor(icon);

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                          elevation: 2.0,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: iconColor.withOpacity(
                                  0.2), // Lighten the icon color for the background
                              child: Icon(icon, color: iconColor),
                            ),
                            title: Text(message.body!),
                            subtitle: Text(
                                'Date: ${DateTime.fromMillisecondsSinceEpoch(message.date!)}'),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

///Chart sample data
class ChartSampleData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleData(
      {this.x,
      this.y,
      this.xValue,
      this.yValue,
      this.secondSeriesYValue,
      this.thirdSeriesYValue,
      this.pointColor,
      this.size,
      this.text,
      this.open,
      this.close,
      this.low,
      this.high,
      this.volume});

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num? y;

  /// Holds x value of the datapoint
  final dynamic xValue;

  /// Holds y value of the datapoint
  final num? yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num? secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num? thirdSeriesYValue;

  /// Holds point color of the datapoint
  final Color? pointColor;

  /// Holds size of the datapoint
  final num? size;

  /// Holds datalabel/text value mapper of the datapoint
  final String? text;

  /// Holds open value of the datapoint
  final num? open;

  /// Holds close value of the datapoint
  final num? close;

  /// Holds low value of the datapoint
  final num? low;

  /// Holds high value of the datapoint
  final num? high;

  /// Holds open value of the datapoint
  final num? volume;
}
