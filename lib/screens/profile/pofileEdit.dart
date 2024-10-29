import 'package:flora/providers/authProvider.dart';
import 'package:flora/widgets/userImagePicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileEdit extends ConsumerStatefulWidget {
  const ProfileEdit({super.key});

  @override
  ConsumerState<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends ConsumerState<ProfileEdit> {
  final editUserForm = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();

  var userData;
  var isloading = false;
  var updateLoading = false;
  var selectedImage;
  late String email;

  getUserData() async {
    try {
      setState(() {
        isloading = true;
      });

      final allDetails =
          await ref.read(authDataProvider.notifier).getUserDetails();
      setState(() {
        userData = allDetails;
        setState(() {
          selectedImage = allDetails['image_url'];
          email = allDetails['email'];
          usernameController.text = allDetails['username'];
          mobileController.text = allDetails['mobile'];
          addressController.text = allDetails['address'];
        });
      });
      setState(() {
        isloading = false;
      });

    } catch (error) {
      setState(() {
        isloading = false;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Details access failed!')));
    }
  }

  updateUserData() async {
    try {
      if (usernameController.text == '' ||
          mobileController.text == '' ||
          addressController.text == '') {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter valid details')));
        return;
      }

      setState(() {
        updateLoading = true;
      });

      final allDetails =
          await ref.read(authDataProvider.notifier).updateUserDetails(
                usernameController.text,
                selectedImage,
                addressController.text,
                mobileController.text,
              );

      if (allDetails) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Details updated success!')));
      }
      setState(() {
        updateLoading = false;
      });
      
    } catch (error) {
      setState(() {
        updateLoading = false;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Details update failed!')));
    }
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  void dispose() {
    addressController.dispose();
    usernameController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var content;

    if (isloading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (userData == null) {
      content = const Center(
        child: Text('Details not found,retry'),
      );
    } else {
      content = Card(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Column(
            children: [
              Form(
                  child: Column(children: [
                UserImagePicker(
                  onPickImage: (pickedImage) {
                    selectedImage = pickedImage;
                  },
                  oldImage: selectedImage,
                ),
                Text(email),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(
                          color:
                              Theme.of(context).textTheme.labelMedium!.color)),
                  controller: usernameController,
                  enableSuggestions: false,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Mobile',
                      labelStyle: TextStyle(
                          color:
                              Theme.of(context).textTheme.labelMedium!.color)),
                  controller: mobileController,
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Address',
                      labelStyle: TextStyle(
                          color:
                              Theme.of(context).textTheme.labelMedium!.color)),
                  controller: addressController,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                          style: Theme.of(context).elevatedButtonTheme.style,
                          onPressed: updateUserData,
                          child: updateLoading
                              ? const CircularProgressIndicator()
                              : const Text('Edit'))
                    ])
              ]))
            ],
          ),
        ),
      );
    }
    return content;
  }
}
