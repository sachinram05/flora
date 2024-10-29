import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flora/screens/profile/pofileEdit.dart';
import 'package:flora/screens/profile/profileView.dart';
import 'package:flutter/material.dart';

final userDetail = FirebaseAuth.instance.currentUser;
final userUID = userDetail?.uid;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var editMode = false;
  var userEmail = '';
  var userAddress = '';
  var userMobile = '';
  var userUsername = '';
  var userImage = '';
  var isloading = false;

  void getProfileDetails() async {
    try {
      setState(() {
        isloading = true;
      });
      if (userUID != null) {
        var userDetails = await FirebaseFirestore.instance
            .collection('users')
            .doc(userUID)
            .get();
        if (userDetails.exists) {
          Map<String, dynamic>? data = userDetails.data();
          setState(() {
            userEmail = data?['email'];
            userMobile = data?['mobile'];
            userAddress = data?['address'];
            userUsername = data?['username'];
            userImage = data?['image_url'];
          });
          setState(() {
            isloading = false;
          });
        } else {
          setState(() {
            isloading = false;
          });
           ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('user details not found!')));
        }
      } else {
        setState(() {
          isloading = false;
        });
          ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('user not found!'))); 
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'User data not loaded!')));
      setState(() {
        isloading = false;
      });
    }
  }

  void updateProfileDetails() async {
    try {
       await FirebaseFirestore.instance 
          .collection('users')
          .doc(userUID)
          .update({
        'username': userUsername,
        // 'email': enteredEmail,
        'image_url': userImage,
        'address': userAddress,
        'mobile': userMobile,
      });
    } catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('User data not updated!')));
    }
  }

  @override
  void initState() {
    getProfileDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: isloading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      editMode
                          ? Container(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      editMode = false;
                                    });
                                  },
                                  icon: const Icon(Icons.cancel_rounded)))
                          : Container(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      editMode = true;
                                    });
                                  },
                                  icon: const Icon(Icons.edit))),
                      editMode ? const ProfileEdit() : const ProfileView(),
                    ],
                  )));
  }
}
