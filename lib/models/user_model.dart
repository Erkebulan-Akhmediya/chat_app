class ChatUser {
  final String id;
  final String username;
  final String email;
  final String password;

  ChatUser({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, String> toMap() => {
    'username': username,
    'email': email,
    'password': password,
  };
}