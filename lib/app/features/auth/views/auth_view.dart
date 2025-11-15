import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_compras/app/features/auth/controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50), // Espaçamento superior
                Image.asset(
                  'assets/images/logo.png',
                  height: 150, // Ajuste o tamanho conforme necessário
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.help_outline,
                      size: 150,
                      color: Get.theme.colorScheme.primary,
                    );
                  },
                ),
                const SizedBox(height: 30), // Espaçamento entre a imagem e o formulário
                Text(
                  controller.isLogin.value ? 'Bem-vindo de volta!' : 'Crie sua conta',
                  style: Get.textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: controller.emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: controller.passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                Obx(
                  () => !controller.isLogin.value
                      ? TextFormField(
                          controller: controller.nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nome',
                            border: OutlineInputBorder(),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: 12),
                Obx(
                  () => !controller.isLogin.value
                      ? TextFormField(
                          controller: controller.phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Telefone',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                        )
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: controller.submit,
                  child: Obx(() =>
                      Text(controller.isLogin.value ? 'Entrar' : 'Cadastrar')),
                ),
                TextButton(
                  onPressed: () {
                    controller.isLogin.value = !controller.isLogin.value;
                  },
                  child: Obx(() => Text(controller.isLogin.value
                      ? 'Criar uma conta'
                      : 'Já tenho uma conta')),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

