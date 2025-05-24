// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';

// class ImagePickerNotifier extends StateNotifier<XFile?> {
//   //The image is initially null not choosen by user soo the XFile? can be null
//   ImagePickerNotifier() : super(null); //Initial value here
//   final ImagePicker imagePicker = ImagePicker();

//   Future<void> fromGallery() async {
//     final XFile? image =
//         await imagePicker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       state = image;
//     }
//   }

//   Future<void> fromCamera() async {
//     final XFile? image =
//         await imagePicker.pickImage(source: ImageSource.camera);
//     if (image != null) {
//       state = image;
//     }
//   }

//   void clearImage() {
//     state = null;
//   }
// }

// final imagePickerProvider = StateNotifierProvider<ImagePickerNotifier, XFile?>(
//     (ref) => ImagePickerNotifier());

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// Image picker provider
final imagePickerProvider =
    StateNotifierProvider<ImagePickerNotifier, XFile?>((ref) {
  return ImagePickerNotifier();
});

class ImagePickerNotifier extends StateNotifier<XFile?> {
  ImagePickerNotifier() : super(null);

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
