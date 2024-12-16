import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  final String title;
  final String? description;
  final VoidCallback? onTap;
  final VoidCallback? onEdit; // Callback for Edit
  final VoidCallback? onDelete; // Callback for Delete

  const ExerciseTile({
    Key? key,
    required this.title,
    this.description,
    this.onTap,
    this.onEdit,
    this.onDelete,
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
              // Left side: Title and description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title, // Title of the exercise
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description ?? 'No description', // Description or fallback
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              // Right side: PopupMenuButton for options
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit' && onEdit != null) {
                    onEdit!(); // Trigger Edit callback
                  } else if (value == 'delete' && onDelete != null) {
                    onDelete!(); // Trigger Delete callback
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit, color: Colors.blue),
                      title: Text('Edit'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete, color: Colors.red),
                      title: Text('Delete'),
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
