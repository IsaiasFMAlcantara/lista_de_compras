import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:lista_compras/app/features/auth/controllers/auth_controller.dart';
import 'package:lista_compras/app/routes/app_pages.dart';
import 'package:lista_compras/app/routes/app_routes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializa o AuthController permanentemente
  Get.put(AuthController(), permanent: true);

  final initialRoute = await _getInitialRoute();

  runApp(MyApp(initialRoute: initialRoute));
}

Future<String> _getInitialRoute() async {
  // Aguarda um momento para o stream de autenticação emitir o primeiro valor
  await Future.delayed(const Duration(milliseconds: 500));
  return FirebaseAuth.instance.currentUser != null ? Routes.HOME : Routes.AUTH;
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Compras',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    );
  }
}
