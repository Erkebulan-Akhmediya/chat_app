class Chat {
  final List participantsId;
  final List messages;

  Chat({
    required this.participantsId,
    required this.messages,
  }) {
    participantsId.sort();
  }

  Map<String, dynamic> toMap() => {
    'participantsId': participantsId,
    'messages': messages,
  };
}