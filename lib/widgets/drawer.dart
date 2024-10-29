import 'package:firebase_auth/firebase_auth.dart';
import 'package:flora/main.dart';
import 'package:flora/screens/flora/favFloras.dart';
import 'package:flora/screens/flora/floralist.dart';
import 'package:flora/screens/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FloraDrawer extends ConsumerStatefulWidget {
  const FloraDrawer({super.key});

  @override
  ConsumerState<FloraDrawer> createState() => _FloraDrawerState();
}

class _FloraDrawerState extends ConsumerState<FloraDrawer> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return SafeArea(
      child: Drawer(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_channel_rounded,
                      size: MediaQuery.of(context).size.height * 0.1,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    Text(
                      '${user.email}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Divider(
                      height: 10,
                      thickness: 0.8,
                      indent: 50,
                      endIndent: 50,
                      color: Theme.of(context).appBarTheme.backgroundColor,
                    ),
                  ],
                ))),
            ListTile(
              leading: Icon(
                Icons.person,
                color: Theme.of(context).iconTheme.color,
              ),
              title: Text(
                ' My Profile ',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Profile()));
              },
            ),
            ListTile(
              leading: Icon(Icons.home_filled,
                  color: Theme.of(context).iconTheme.color),
              title: Text(
                'Home',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite_sharp,
                  color: Theme.of(context).iconTheme.color),
              title: Text(
                'Favorite Floras',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Favfloras()));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout,
                  weight: 600, color: Theme.of(context).iconTheme.color),
              title: Text(
                'Logout',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MyApp()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
