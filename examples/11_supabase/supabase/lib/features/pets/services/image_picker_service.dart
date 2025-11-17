import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

/// Service for picking images across different platforms
/// - Mobile (iOS/Android): Uses image_picker with camera/gallery options
/// - Desktop (Windows/macOS/Linux): Uses file_picker for file selection
class ImagePickerService {
  final ImagePicker _imagePicker = ImagePicker();

  /// Pick an image file with platform-specific implementation
  /// Returns null if user cancels or if an error occurs
  Future<File?> pickImage() async {
    try {
      // Desktop platforms: Use file_picker
      if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        return await _pickImageDesktop();
      }

      // Mobile platforms: Use image_picker with source selection
      return await _pickImageMobile();
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  /// Desktop implementation using file_picker
  Future<File?> _pickImageDesktop() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) return null;

    final path = result.files.first.path;
    return path != null ? File(path) : null;
  }

  /// Mobile implementation using image_picker
  /// Defaults to gallery (camera option can be added if needed)
  Future<File?> _pickImageMobile() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    return pickedFile != null ? File(pickedFile.path) : null;
  }
}
