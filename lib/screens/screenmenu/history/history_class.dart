// lib/models/history_item.dart

class HistoryItem {
  final String date;
  final String job;
  final double amount;

  HistoryItem({
    required this.date,
    required this.job,
    required this.amount,
  });
  DateTime get dateTime => DateTime.parse(date); 
}