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
    'time': time,
  };

  factory Message.fromMap(Map<String, dynamic> map) => Message(
    senderId: map['senderId'],
    receiverId: map['receiverId'],
    message: map['message'],
    time: map['time'],
  );
}