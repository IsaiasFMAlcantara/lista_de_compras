import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- Seção de Foto de Perfil ---
            Stack(
              children: [
                Obx(
                  () => CircleAvatar(
                    radius: 60,
                    backgroundImage: controller.profileImageUrl.value.isNotEmpty
                        ? NetworkImage(controller.profileImageUrl.value)
                        : null,
                    child: controller.profileImageUrl.value.isEmpty
                        ? const Icon(Icons.person, size: 60)
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: controller.showImageSourceActionSheet,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- Seção de Informações Pessoais ---
            TextFormField(
              controller: controller.nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.phoneController,
              decoration: const InputDecoration(
                labelText: 'Telefone',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              readOnly: true,
              initialValue: controller.authController.firestoreUser.value?.email,
              decoration: const InputDecoration(
                labelText: 'Email (não editável)',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.black12,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: controller.updateUserProfile,
              child: const Text('Salvar Alterações'),
            ),

            const Divider(height: 40),

            // --- Seção de Alteração de Senha ---
            const Text(
              'Alterar Senha',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Obx(
              () => TextFormField(
                controller: controller.oldPasswordController,
                decoration: InputDecoration(
                  labelText: 'Senha Antiga',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isOldPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: controller.toggleOldPasswordVisibility,
                  ),
                ),
                obscureText: !controller.isOldPasswordVisible.value,
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => TextFormField(
                controller: controller.newPasswordController,
                decoration: InputDecoration(
                  labelText: 'Nova Senha',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isNewPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: controller.toggleNewPasswordVisibility,
                  ),
                ),
                obscureText: !controller.isNewPasswordVisible.value,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: controller.changePassword,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Alterar Senha'),
            ),
          ],
        ),
      ),
    );
  }
}