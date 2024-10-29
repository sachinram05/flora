import 'dart:io';
import 'dart:math';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flora/models/FloraModel.dart';
import 'package:flora/providers/floraProvider.dart';
import 'package:flora/widgets/userImagePicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddFlora extends ConsumerStatefulWidget {
  const AddFlora({super.key});

  @override
  ConsumerState<AddFlora> createState() => _AddFloraState();
}

class _AddFloraState extends ConsumerState<AddFlora> {
  final _addFloraFormKey = GlobalKey<FormState>();
  var uuid = const Uuid();
  var floraName = '';
  var amount = '';
  var place = '';
  var description = '';
  File? selectedImage;
  var _isUploading = false;

  void onSubmitFlora() async {
    print("selectedImage ${selectedImage}");

    if (selectedImage == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add flora image!')));
      return;
    }

    if (_addFloraFormKey.currentState!.validate()) {
      try {
        setState(() {
          _isUploading = true;
        });
        _addFloraFormKey.currentState!.save();

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('flora_images')
            .child('${Random().nextInt(100000)}flora.jpg');

        await storageRef.putFile(selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();

        final floraData = ref.read(floraProvider);
        final checkStatus = await floraData.addNewFlora(Flora(false,
            id: uuid.v4(), //id generator
            title: floraName,
            desc: description,
            image: imageUrl,
            amount: amount,
            place: place));
        if (checkStatus) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Flora added success!')));
          _addFloraFormKey.currentState!.reset();
          setState(() {
            selectedImage = null;
          });
          setState(() {
            _isUploading = false;
          });
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Flora not added')));
          setState(() {
            _isUploading = false;
          });
        }
      } on FirebaseAuthException catch (error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message ?? 'Flora not added!')));
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add new flora'),
        ),
        body: SingleChildScrollView(
            child: Card(
                margin: const EdgeInsets.all(20),
                child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Column(children: [
                      Form(
                          key: _addFloraFormKey,
                          child: Column(
                            children: [
                              UserImagePicker(
                                onPickImage: (pickedImage) {
                                  selectedImage = pickedImage;
                                },
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    // enabledBorder: const UnderlineInputBorder(
                                    //     borderSide:
                                    //         BorderSide(color: Colors.black87)
                                    //         ),
                                    labelText: 'Flora name',
                                    labelStyle: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .color,
                                    )),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.trim().length < 4) {
                                    return 'Please enter at least 4 characters.';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  floraName = newValue!;
                                },
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Amount',
                                   
                                    labelStyle: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .color,
                                    )),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter valid amount';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  amount = newValue!;
                                },
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Place',
                                  labelStyle: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .color,
                                  ),
                                
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.trim().length < 4) {
                                    return 'Please enter at least 3 characters.';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  place = newValue!;
                                },
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Description',
                                  labelStyle: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .color,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.trim().length < 4) {
                                    return 'Please enter at least 4 characters.';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  description = newValue!;
                                },
                              ),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 30, 8, 20),
                                  width: 200,
                                  child: ElevatedButton(
                                      onPressed: onSubmitFlora,
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer),
                                      child: _isUploading
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.add,
                                                  size: 24,
                                                ),
                                                Text('add')
                                              ],
                                            )))
                            ],
                          ))
                    ])))));
  }
}
