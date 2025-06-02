// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';

// // Image picker provider
// final imagePickerProvider =
//     StateNotifierProvider<ImagePickerNotifier, XFile?>((ref) {
//   return ImagePickerNotifier();
// });

// class ImagePickerNotifier extends StateNotifier<XFile?> {
//   ImagePickerNotifier() : super(null);

//   Future<void> fromCamera() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.camera);
//     state = pickedFile;
//   }

//   Future<void> fromGallery() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     state = pickedFile;
//   }

//   void clearImage() {
//     state = null;
//   }
// }

// image_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// Provider for EntryForm
final entryFormImagePickerProvider =
    StateNotifierProvider<EntryFormImagePickerNotifier, XFile?>((ref) {
  return EntryFormImagePickerNotifier();
});

class EntryFormImagePickerNotifier extends StateNotifier<XFile?> {
  EntryFormImagePickerNotifier() : super(null);

  Future<void> fromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    state = pickedFile;
  }

  Future<void> fromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    state = pickedFile;
  }

  void clearImage() {
    state = null;
  }
}

// Provider for ProfileScreen
final profileImagePickerProvider =
    StateNotifierProvider<ProfileImagePickerNotifier, XFile?>((ref) {
  return ProfileImagePickerNotifier();
});

class ProfileImagePickerNotifier extends StateNotifier<XFile?> {
  ProfileImagePickerNotifier() : super(null);

  Future<void> fromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    state = pickedFile;
  }

  Future<void> fromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    state = pickedFile;
  }

  void clearImage() {
    state = null;
  }
}
