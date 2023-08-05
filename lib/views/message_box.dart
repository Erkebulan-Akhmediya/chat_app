import 'package:flutter/material.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({
    super.key,
    required this.alignment,
    required this.text,
    required this.date,
  });

  final Alignment alignment;
  final String text;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: alignment == Alignment.topLeft ?
        CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Colors.blue,
            ),
            padding: const EdgeInsets.all(20.0),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Text('${date.hour}:${date.minute}'),
        ],
      ),
    );
  }
}