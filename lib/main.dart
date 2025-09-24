import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_compras/bindings.dart';
import 'firebase_options.dart';
import 'routers.dart';
import 'theme.dart'; // Import the theme file
import 'package:firebase_messaging/firebase_messaging.dart'; // Import Firebase Messaging

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Request permission for notifications
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    
    // TODO: Save this token to the user's document in Firestore
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    
  } else {
    
  }

  // Handle foreground messages (optional, but good for testing)
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    
    

    if (message.notification != null) {
      
    }
  });

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes().define(),
      initialBinding: InitialBinding(), // Add this line
      theme: lightTheme, // Use the light theme
      darkTheme: darkTheme, // Use the dark theme
      themeMode: ThemeMode.system, // Automatically switch based on system settings
    ),
  );
}
