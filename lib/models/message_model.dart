import 'package:intl/intl.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime time;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.time,
  });

  Map<String, dynamic> toMap() => {
    'senderId': senderId,
    'receiverId': receiverId,
    'message': message,
    'time': DateFormat('yyyy-MM-dd HH:mm:ss').format(time),
  };

  factory Message.fromMap(Map<String, dynamic> map) => Message(
    senderId: map['senderId'],
    receiverId: map['receiverId'],
    message: map['message'],
    time: DateFormat('yyyy-MM-dd HH:mm:ss').parse(map['time']),
  );
}