import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  Future<XFile?> pickImageFromGallery() async {
    final picker = ImagePicker();
    final status = await Permission.storage.request();
    if (!status.isGranted) return null;
    return await picker.pickImage(source: ImageSource.gallery);
  }

  Future<XFile?> takePhoto() async {
    final picker = ImagePicker();
    final status = await Permission.camera.request();
    if (!status.isGranted) return null;
    return await picker.pickImage(source: ImageSource.camera);
  }

  Future<String?> uploadProfileImage(String userId, XFile imageFile) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('users/$userId/profile/$fileName');

      await ref.putFile(File(imageFile.path));
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      print('Error deleting image: $e');
    }
  }
}