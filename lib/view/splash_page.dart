import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    // A lógica de redirecionamento é tratada pelo AuthController.
    // A SplashPage apenas exibe um indicador de carregamento enquanto
    // o estado de autenticação é verificado.
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}