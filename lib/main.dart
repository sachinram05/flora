import 'package:firebase_auth/firebase_auth.dart';
import 'package:flora/screens/SplashScreen.dart';
import 'package:flora/screens/auth/auth.dart';
import 'package:flora/screens/flora/floralist.dart';
import 'package:flora/theme/mainTheme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations(([
        DeviceOrientation.portraitUp
  ])).then((fn){
    runApp(const ProviderScope(child: MyApp()));
  }
    
  );
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flora',
      theme: theme,
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplaceScreen();//loading
            }

            if (snapshot.hasData) {
              return const HomeScreen();
            }
            return const AuthScreen();
          }),
    );
  }
}
