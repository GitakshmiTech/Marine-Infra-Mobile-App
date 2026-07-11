import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class MockFileResult {
  final String name;
  final String path;
  final String size;
  final String extension;

  MockFileResult({
    required this.name,
    required this.path,
    required this.size,
    required this.extension,
  });
}

class MockMediaPicker {
  static final ImagePicker _imagePicker = ImagePicker();

  static Future<MockFileResult?> showFilePicker(
    BuildContext context, {
    List<String>? allowedExtensions,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final sizeInKb = (file.size / 1024).toStringAsFixed(1);
        final sizeStr = file.size > 1024 * 1024
            ? '${(file.size / (1024 * 1024)).toStringAsFixed(1)} MB'
            : '$sizeInKb KB';
        return MockFileResult(
          name: file.name,
          path: file.path ?? '',
          size: sizeStr,
          extension: file.extension ?? '',
        );
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open file manager: $e')),
      );
    }
    return null;
  }

  static Future<MockFileResult?> showCamera(BuildContext context) async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (photo != null) {
        final length = await photo.length();
        final sizeInKb = (length / 1024).toStringAsFixed(1);
        final sizeStr = length > 1024 * 1024
            ? '${(length / (1024 * 1024)).toStringAsFixed(1)} MB'
            : '$sizeInKb KB';
        return MockFileResult(
          name: photo.name,
          path: photo.path,
          size: sizeStr,
          extension: photo.name.split('.').last,
        );
      }
    } catch (e) {
      debugPrint('Error capturing photo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open camera: $e')),
      );
    }
    return null;
  }
}
