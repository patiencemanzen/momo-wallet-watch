import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final Telephony telephony = Telephony.instance;

  List<SmsMessage> messages = [];
  List<SmsMessage> filteredMessages = [];

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

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M-Money Transactions'),
      ),
      body: ListView.builder(
        itemCount: filteredMessages.length,
        itemBuilder: (context, index) {
          final message = filteredMessages[index];
          final icon = getTransactionIcon(message.body!);
          final iconColor = getIconColor(icon);

          return Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: iconColor.withOpacity(
                      0.2), // Lighten the icon color for the background
                  child: Icon(icon, color: iconColor),
                ),
                title: Text(message.body!),
                subtitle: Text(
                    'Date: ${DateTime.fromMillisecondsSinceEpoch(message.date!)}'),
              ),
              const Divider(), // Add a divider below each ListTile
            ],
          );
        },
      ),
    );
  }
}
