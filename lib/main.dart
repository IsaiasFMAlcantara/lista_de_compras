import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:lista_compras/app/features/auth/controllers/auth_controller.dart';
import 'package:lista_compras/app/routes/app_pages.dart';
import 'package:lista_compras/app/routes/app_routes.dart';
import 'package:lista_compras/app/bindings/initial_binding.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';
import 'package:lista_compras/app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializa a formatação de datas para o locale 'pt_BR'
  await initializeDateFormatting('pt_BR', null); // Chamada para inicialização

  // Inicializa o AuthController permanentemente para que ele possa reagir às
  // mudanças de autenticação imediatamente.
  Get.put(AuthController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Compras',
      theme: AppTheme.themeData,
      initialBinding: InitialBinding(),
      // A rota inicial é sempre a de autenticação.
      // O AuthController irá redirecionar para a home se o usuário já estiver logado.
      initialRoute: Routes.auth,
      getPages: AppPages.routes,
    );
  }
}
