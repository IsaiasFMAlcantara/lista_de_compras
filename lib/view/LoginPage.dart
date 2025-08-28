import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_compras/controller/auth_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Obx(() {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- TÍTULO ---
                  Text(
                    controller.isLoginView.value ? 'Login' : 'Cadastro',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // --- CAMPO NOME (APENAS CADASTRO) ---
                  if (!controller.isLoginView.value)
                    TextFormField(
                      controller: controller.nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, digite seu nome.';
                        }
                        return null;
                      },
                    ),
                  const SizedBox(height: 16),

                  // --- CAMPO TELEFONE (APENAS CADASTRO) ---
                  if (!controller.isLoginView.value)
                    TextFormField(
                      controller: controller.phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Telefone',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, digite seu telefone.';
                        }
                        return null;
                      },
                    ),
                  const SizedBox(height: 16),

                  // --- CAMPO EMAIL ---
                  TextFormField(
                    controller: controller.emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite seu e-mail.';
                      }
                      if (!GetUtils.isEmail(value)) {
                        return 'Por favor, digite um e-mail válido.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // --- CAMPO SENHA ---
                  Obx(() {
                    return TextFormField(
                      controller: controller.passwordController,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                      obscureText: !controller.isPasswordVisible.value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, digite sua senha.';
                        }
                        if (value.length < 6) {
                          return 'A senha deve ter no mínimo 6 caracteres.';
                        }
                        return null;
                      },
                    );
                  }),
                  const SizedBox(height: 16),

                  // --- CAMPO CONFIRMAR SENHA (APENAS CADASTRO) ---
                  if (!controller.isLoginView.value)
                    Obx(() {
                      return TextFormField(
                        controller: controller.confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirmar Senha',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                        ),
                        obscureText: !controller.isPasswordVisible.value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, confirme sua senha.';
                          }
                          if (value != controller.passwordController.text) {
                            return 'As senhas não coincidem.';
                          }
                          return null;
                        },
                      );
                    }),
                  const SizedBox(height: 24),

                  // --- BOTÃO PRINCIPAL (LOGIN/CADASTRO) ---
                  Obx(() {
                    return controller.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                if (controller.isLoginView.value) {
                                  controller.login();
                                } else {
                                  controller.signUp();
                                }
                              }
                            },
                            child: Text(controller.isLoginView.value
                                ? 'Entrar'
                                : 'Cadastrar'),
                          );
                  }),
                  const SizedBox(height: 16),

                  // --- BOTÕES SECUNDÁRIOS ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: controller.toggleView,
                        child: Text(
                          controller.isLoginView.value
                              ? 'Não tem uma conta? Cadastre-se'
                              : 'Já tem uma conta? Faça login',
                        ),
                      ),
                    ],
                  ),
                  if (controller.isLoginView.value)
                    TextButton(
                      onPressed: controller.resetPassword,
                      child: const Text('Esqueci minha senha'),
                    ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
