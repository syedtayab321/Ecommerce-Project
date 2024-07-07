import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController {
  var imagedata = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imagedata.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick image: $e");
    }
  }
}
