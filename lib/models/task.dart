class Task {
  String? id;
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;
  int priority; // 1=Low, 2=Medium, 3=High
  String userId;
  DateTime createdAt;
  String? imageUrl;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    this.priority = 2,
    required this.userId,
    DateTime? createdAt,
    this.imageUrl,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
      'priority': priority,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }

  // Create from Firestore document
  factory Task.fromMap(String id, Map<String, dynamic> map) {
    return Task(
      id: id,
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      isCompleted: map['isCompleted'],
      priority: map['priority'],
      userId: map['userId'],
      createdAt: DateTime.parse(map['createdAt']),
      imageUrl: map['imageUrl'],
    );
  }

  String get priorityText {
    switch (priority) {
      case 1: return 'Low';
      case 2: return 'Medium';
      case 3: return 'High';
      default: return 'Medium';
    }
  }

  Color get priorityColor {
    switch (priority) {
      case 1: return Colors.green;
      case 2: return Colors.orange;
      case 3: return Colors.red;
      default: return Colors.grey;
    }
  }
}