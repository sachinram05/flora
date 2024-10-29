import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker({
    super.key,
    required this.onPickImage,
    this.oldImage,
  });
  var oldImage;
  final void Function(File pickedImage) onPickImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? pickedImageFile;

  void pickImage() async {
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxWidth: 150);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      pickedImageFile = File(pickedImage.path);
    });

    widget.onPickImage(pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          foregroundImage: pickedImageFile != null
              ? FileImage(pickedImageFile!)
              : widget.oldImage != null
                  ? NetworkImage(widget.oldImage)
                  : null,
        ),
        TextButton.icon(
            onPressed: pickImage,
            icon: Icon(
              Icons.image,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            label: Text(
              'Add Image',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
            ))
      ],
    );
  }
}
