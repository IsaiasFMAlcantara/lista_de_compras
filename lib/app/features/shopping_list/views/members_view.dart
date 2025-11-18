import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_compras/app/features/shopping_list/controllers/shopping_list_controller.dart';

class MembersView extends GetView<ShoppingListController> {
  const MembersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Membros'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Formulário para adicionar novo membro ---
            const Text('Adicionar Novo Membro', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.memberEmailController,
              decoration: const InputDecoration(
                labelText: 'E-mail do usuário',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 8),
            Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedPermission.value,
                  items: const [
                    DropdownMenuItem(value: 'viewer', child: Text('Pode Visualizar')),
                    DropdownMenuItem(value: 'editor', child: Text('Pode Editar')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedPermission.value = value;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Permissão',
                    border: OutlineInputBorder(),
                  ),
                )),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : () => controller.addMember(),
                    child: controller.isLoading.value
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
                        : const Text('Adicionar'),
                  )),
            ),
            const Divider(height: 32),

            // --- Lista de membros atuais ---
            const Text('Membros Atuais', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: Obx(() {
                final members = controller.currentList.value?.memberPermissions.entries.toList() ?? [];
                if (members.isEmpty) {
                  return const Center(child: Text('Apenas você é membro desta lista.'));
                }
                return ListView.builder(
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final member = members[index];
                    final isOwner = member.value == 'owner';
                    return ListTile(
                      title: Text(controller.getUserEmail(member.key)), // Reverted to use getUserEmail
                      subtitle: Text(isOwner ? 'Dono' : 'Permissão: ${member.value}'),
                      trailing: isOwner
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                              onPressed: () => controller.removeMember(member.key), // Reverted to pass UID
                            ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}