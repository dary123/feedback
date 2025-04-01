import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImagePickerGrid extends StatefulWidget {
  final int maxImages;
  final double imageWidth;
  final double imageHeight;
  final BoxDecoration? imageContainerDecoration;
  final Function(int, File?)? onImageChanged;

  const ImagePickerGrid({
    Key? key,
    this.maxImages = 3,
    this.imageWidth = 100,
    this.imageHeight = 100,
    this.imageContainerDecoration,
    this.onImageChanged,
  }) : super(key: key);

  @override
  _ImagePickerGridState createState() => _ImagePickerGridState();
}

class _ImagePickerGridState extends State<ImagePickerGrid> {
  late List<File?> _selectedImages;

  @override
  void initState() {
    super.initState();
    _selectedImages = List.generate(widget.maxImages, (_) => null);
  }

  Future<File?> compressImage(File imageFile) async {
    var result = await FlutterImageCompress.compressWithFile(
      imageFile.path,
      quality: 80,
      rotate: 0,
    );

    if (result == null) return null;

    final compressedFile = File(imageFile.path)..writeAsBytesSync(result);
    return compressedFile;
  }

  Future<void> _pickImage(int index) async {
    try {
      final pickedFile =
      await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File file = File(pickedFile.path);
        File? compressed = await compressImage(file);
        setState(() {
          _selectedImages[index] = compressed ?? file;
        });
        if (widget.onImageChanged != null) {
          widget.onImageChanged!(index, _selectedImages[index]);
        }
      }
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages[index] = null;
    });
    if (widget.onImageChanged != null) {
      widget.onImageChanged!(index, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(widget.maxImages, (index) {
        return _selectedImages[index] == null
            ? GestureDetector(
          onTap: () => _pickImage(index),
          child: Container(
            width: widget.imageWidth,
            height: widget.imageHeight,
            decoration: widget.imageContainerDecoration ??
                BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF01101B),
                  ),
                ),
            child: const Icon(
              Icons.add_a_photo,
              color: Color(0xFF01101B),
              size: 40,
            ),
          ),
        )
            : Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                _selectedImages[index]!,
                width: widget.imageWidth,
                height: widget.imageHeight,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => _removeImage(index),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
