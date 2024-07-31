import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
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
  Map<String, Map<String, double>> groupedAmounts = {};
  List<SmsMessage> messages = [];
  List<SmsMessage> filteredMessages = [];

  late bool isCardView = false;
  final Telephony telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await fetchMessages();

    for (var message in filteredMessages) {
      DateTime date = parseDate(message.body!);
      String monthKey = '${date.year}-${date.month.toString().padLeft(2, '0')}';

      if (!groupedAmounts.containsKey(monthKey)) {
        groupedAmounts[monthKey] = {'sent': 0.0, 'received': 0.0};
      }

      groupedAmounts[monthKey]!['sent'] =
          groupedAmounts[monthKey]!['sent']! + extractSentAmount(message.body!);
      groupedAmounts[monthKey]!['received'] =
          groupedAmounts[monthKey]!['received']! +
              extractReceivedAmount(message.body!);
    }

    chartData = prepareChartData(groupedAmounts);
  }

  Future<void> fetchMessages() async {
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
        name: 'Sent Amount',
        xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
      ),
      AreaSeries<ChartSampleData, DateTime>(
        dataSource: chartData,
        opacity: 0.7,
        name: 'Received Amount',
        xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
        yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
      )
    ];
  }

  double extractSentAmount(String message) {
    final match = RegExp(r'(\d+) RWF transferred').firstMatch(message);
    if (match != null) {
      return double.parse(match.group(1)!);
    }
    return 0.0;
  }

  double extractReceivedAmount(String message) {
    final match = RegExp(r'You have received (\d+) RWF').firstMatch(message);
    if (match != null) {
      return double.parse(match.group(1)!);
    }
    return 0.0;
  }

  DateTime parseDate(String message) {
    final match =
        RegExp(r'at (\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})').firstMatch(message);
    if (match != null) {
      return DateTime.parse(match.group(1)!);
    }
    return DateTime.now();
  }

  @override
  void dispose() {
    chartData!.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Intergrated \nBudget 2024",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                  ),
                  ProfileImageCard(
                    imageSrc:
                        'https://plus.unsplash.com/premium_photo-1683121366070-5ceb7e007a97?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D',
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: const Color.fromARGB(255, 213, 213, 213),
                    width: 1.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Card(
                elevation: 0.0,
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SfCartesianChart(
                    legend: const Legend(isVisible: true, opacity: 0.7),
                    title:
                        const ChartTitle(text: 'Monthly Transaction Analysis'),
                    plotAreaBorderWidth: 0,
                    primaryXAxis: const CategoryAxis(
                      majorGridLines: MajorGridLines(width: 0),
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                    ),
                    primaryYAxis: const NumericAxis(
                      labelFormat: '{value}',
                      axisLine: AxisLine(width: 1),
                      majorTickLines: MajorTickLines(size: 1),
                    ),
                    series: _getDefaultAreaSeries(),
                    tooltipBehavior: TooltipBehavior(enable: true),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: const Color.fromARGB(255, 213, 213, 213),
                    width: 1.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
              child: SizedBox(
                height: 400, // Set a fixed height for the ListView
                child: ListView.builder(
                  itemCount: filteredMessages.length,
                  itemBuilder: (context, index) {
                    final message = filteredMessages[index];
                    final icon = getTransactionIcon(message.body!);
                    final iconColor = getIconColor(icon);

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: const Color.fromARGB(255, 213, 213, 213),
                            width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Card(
                        color: Colors.transparent,
                        elevation: 0.0,
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
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<ChartSampleData> prepareChartData(
    Map<String, Map<String, double>> groupedAmounts) {
  List<ChartSampleData> chartSamples = [];

  groupedAmounts.forEach((month, amounts) {
    List<String> parts = month.split('-');

    int year = int.parse(parts[0]);
    int monthInt = int.parse(parts[1]);

    chartSamples.add(ChartSampleData(
      x: DateTime(year, monthInt),
      y: amounts['sent']!,
      secondSeriesYValue: amounts['received']!,
    ));
  });

  return chartSamples;
}

class TransactionData {
  final String month;
  final double sent;
  final double received;

  TransactionData(this.month, this.sent, this.received);
}

class Message {
  final String body;

  Message({required this.body});
}

class ProfileImageCard extends StatelessWidget {
  final String imageSrc;
  const ProfileImageCard({super.key, required this.imageSrc});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: NetworkImage(imageSrc), fit: BoxFit.cover)),
    );
  }
}

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
