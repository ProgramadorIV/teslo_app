import 'package:image_picker/image_picker.dart';

import 'camera_gallery_service.dart';

class CameraGalleryServiceImpl extends CameraGalleryService {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Future<List<String>> selectMultiplePhotos() async {
    final List<XFile> photos = await _imagePicker.pickMultiImage(
      imageQuality: 100,
    );

    List<String> photosPaths = [];

    for (final photo in photos) {
      photosPaths.add(photo.path);
    }

    return photosPaths;
  }

  @override
  Future<String?> selectPhoto() async {
    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (photo == null) return null;

    return photo.path;
  }

  @override
  Future<String?> takePhoto() async {
    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (photo == null) return null;

    return photo.path;
  }
}
