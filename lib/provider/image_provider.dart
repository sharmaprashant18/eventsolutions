import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerNotifier extends StateNotifier<XFile?> {
  //The image is initially null not choosen by user soo the XFile? can be null
  ImagePickerNotifier() : super(null); //Initial value here
  final ImagePicker imagePicker = ImagePicker();

  Future<void> fromGallery() async {
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      state = image;
    }
  }

  Future<void> fromCamera() async {
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      state = image;
    }
  }

  void clearImage() {
    state = null;
  }
}

final imagePickerProvider = StateNotifierProvider<ImagePickerNotifier, XFile?>(
    (ref) => ImagePickerNotifier());
