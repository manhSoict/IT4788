import 'package:flutter/material.dart';

class RequestCard extends StatelessWidget {
  final String date;
  final String sender;
  final VoidCallback? onTap;
  final VoidCallback? onAccept; // Callback for Accept
  final VoidCallback? onReject; // Callback for Reject

  const RequestCard({
    Key? key,
    required this.date,
    required this.sender,
    this.onTap,
    this.onAccept,
    this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side: Date and sender details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date, // Date of the request
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      sender, // Sender of the request
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              // Right side: PopupMenuButton for options (Accept and Reject)
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'accept' && onAccept != null) {
                    onAccept!(); // Trigger Accept callback
                  } else if (value == 'reject' && onReject != null) {
                    onReject!(); // Trigger Reject callback
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'accept',
                    child: ListTile(
                      leading: Icon(Icons.check, color: Colors.green),
                      title: Text('Accept'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'reject',
                    child: ListTile(
                      leading: Icon(Icons.close, color: Colors.red),
                      title: Text('Reject'),
                    ),
                  ),
                ],
                icon: const Icon(Icons.more_vert, color: Colors.black54), // 3-dot menu icon
              ),
            ],
          ),
        ),
      ),
    );
  }
}
