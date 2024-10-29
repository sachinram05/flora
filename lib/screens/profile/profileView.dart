import 'package:flora/providers/authProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({
    super.key,
  });

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  var userData;
  var isloading = false;

  getUserData() async {
    try {
      setState(() {
        isloading = true;
      });
      final allDetails =
          await ref.read(authDataProvider.notifier).getUserDetails();
      setState(() {
        userData = allDetails;
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

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (isloading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }else if(userData == null){
      content = const Center(
        child:
           Text('Details not found'),
        
      );
    } else {
      content = Column(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Theme.of(context).appBarTheme.foregroundColor,
              shape: BoxShape.circle),
          child: ClipOval(
            child: SizedBox.fromSize(
              size: const Size.fromRadius(140),
              child: Image.network(userData['image_url'], fit: BoxFit.cover),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
            child: Text(userData['username'],
                style: Theme.of(context).textTheme.titleLarge)),
        const SizedBox(
          height: 10,
        ),
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
            child: Text(userData['email'],
                style: Theme.of(context).textTheme.titleLarge)),
        const SizedBox(
          height: 10,
        ),
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
            child: Text(userData['mobile'],
                style: Theme.of(context).textTheme.titleLarge)),
        const SizedBox(
          height: 10,
        ),
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
            child: Text(userData['address'],
                style: Theme.of(context).textTheme.titleLarge))
      ]);
    }

    return content;
  }
}
