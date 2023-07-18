class Chat {
  final String id;
  final List<String> participantsId;
  final List<String> messages;

  Chat({
    required this.id,
    required this.participantsId,
    required this.messages,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'participantsId': participantsId,
    'messages': messages,
  };
}