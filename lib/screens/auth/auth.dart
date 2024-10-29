//LOGIN

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flora/widgets/userImagePicker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final authForm = GlobalKey<FormState>();

  var isLogin = true;
  var enteredEmail = '';
  var enteredUsername = '';
  var enteredPassword = '';
  var enteredMobile = '';
  var enteredAddress = '';
  File? selectedImage;
  var _isUploading = false;

  void onSubmit() async {
    if (selectedImage == null && !isLogin) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('please add profile image!')));
      return;
    }

    final isValid = authForm.currentState!.validate();

    if (!isValid || !isLogin && selectedImage == null) {
      return;
    }

    authForm.currentState!.save();
    try {
      setState(() {
        _isUploading = true;
      });
      if (isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: enteredEmail, password: enteredPassword);
        print(userCredentials);
        setState(() {
          _isUploading = false;
        });
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: enteredEmail, password: enteredPassword);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');

        await storageRef.putFile(selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid) //for creating unique id manually
            .set({
          'username': enteredUsername,
          'email': enteredEmail,
          'image_url': imageUrl,
          'address': enteredAddress,
          'mobile': enteredMobile,
        });
        setState(() {
          _isUploading = false;
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message??'email already in use')));
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Authentication failed!')));
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_channel_rounded,
                size: 100,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              Text(
                'Flora',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              Card(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Form(
                      key: authForm,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!isLogin)
                            UserImagePicker(
                              onPickImage: (pickedImage) {
                                selectedImage = pickedImage;
                              },
                              oldImage:
                                  'https://static.thenounproject.com/png/1161010-200.png',
                            ),
                          if (!isLogin)
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Username'),
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length < 4) {
                                  return 'Please enter at least 4 characters.';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                enteredUsername = newValue!;
                              },
                            ),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Email Address'),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address.';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              enteredEmail = newValue!;
                            },
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Password must be at least 6 characters.';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              enteredPassword = newValue!;
                            },
                          ),
                          if (!isLogin)
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Mobile'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length != 10) {
                                  return 'Please enter valid phone number.';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                enteredMobile = newValue!;
                              },
                            ),
                          if (!isLogin)
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Address'),
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length < 3) {
                                  return 'Please enter valid Address.';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                enteredAddress = newValue!;
                              },
                            ),
                          const SizedBox(
                            height: 12,
                          ),
                          if (_isUploading) const CircularProgressIndicator(),
                          if (!_isUploading)
                            ElevatedButton(
                                onPressed: onSubmit,
                                style:
                                    Theme.of(context).elevatedButtonTheme.style,
                                child: Text(isLogin ? 'Login' : 'Signup')),
                          if (!_isUploading)
                            TextButton(
                                style: Theme.of(context).textButtonTheme.style,
                                onPressed: () {
                                  setState(() {
                                    isLogin = !isLogin;
                                  });
                                },
                                child: Text(isLogin
                                    ? 'Create an account'
                                    : 'I already have an account'))
                        ],
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
