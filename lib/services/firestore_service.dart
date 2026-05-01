import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get tasks collection reference for a user
  CollectionReference _getTasksCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('tasks');
  }

  // Create task
  Future<void> addTask(String userId, Task task) async {
    await _getTasksCollection(userId).add(task.toMap());
  }

  // Get all tasks (real-time stream)
  Stream<List<Task>> getTasks(String userId) {
    return _getTasksCollection(userId)
        .orderBy('dueDate', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Task.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  // Update task
  Future<void> updateTask(String userId, Task task) async {
    await _getTasksCollection(userId).doc(task.id).update(task.toMap());
  }

  // Delete task
  Future<void> deleteTask(String userId, String taskId) async {
    await _getTasksCollection(userId).doc(taskId).delete();
  }

  // Toggle completion
  Future<void> toggleComplete(String userId, Task task) async {
    await _getTasksCollection(userId).doc(task.id).update({
      'isCompleted': !task.isCompleted,
    });
  }

  // Get single task
  Future<Task?> getTask(String userId, String taskId) async {
    final doc = await _getTasksCollection(userId).doc(taskId).get();
    if (doc.exists) {
      return Task.fromMap(doc.id, doc.data()!);
    }
    return null;
  }

  // Delete all completed tasks
  Future<void> deleteCompletedTasks(String userId) async {
    final tasks = await _getTasksCollection(userId)
        .where('isCompleted', isEqualTo: true)
        .get();

    for (var doc in tasks.docs) {
      await doc.reference.delete();
    }
  }
}