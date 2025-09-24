import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_compras/controller/members_controller.dart';
import 'package:lista_compras/model/shopping_list_model.dart';
import 'package:lista_compras/model/user_model.dart';
import 'package:lista_compras/view/widgets/custom_app_bar.dart';

class MembersPage extends StatelessWidget {
  const MembersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ShoppingListModel list = Get.arguments as ShoppingListModel;
    final MembersController controller = Get.put(MembersController());

    return Scaffold(
      appBar: const CustomAppBar(title: 'Membros da Lista'),
      body: GetBuilder<MembersController>(
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInviteSection(controller, list),
                const SizedBox(height: 24),
                Text('Membros Atuais', style: Theme.of(context).textTheme.titleLarge),
                const Divider(),
                Expanded(
                  child: _buildMembersList(controller, list),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInviteSection(MembersController controller, ShoppingListModel list) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller.emailController,
            decoration: const InputDecoration(
              labelText: 'E-mail do usuário',
              hintText: 'convidar@email.com',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        const SizedBox(width: 8),
        Obx(() {
          return controller.isLoading.value
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () => controller.inviteUser(list),
                  child: const Text('Convidar'),
                );
        }),
      ],
    );
  }

  Widget _buildMembersList(MembersController controller, ShoppingListModel list) {
    return FutureBuilder<List<UserModel>>(
      future: controller.getMembersDetails(list),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar membros.'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhum membro nesta lista.'));
        }

        final members = snapshot.data!;

        return ListView.builder(
          itemCount: members.length,
          itemBuilder: (context, index) {
            final member = members[index];
            final permission = list.members[member.id] ?? 'N/A';

            return Card(
              child: ListTile(
                title: Text(member.name),
                subtitle: Text(member.email),
                trailing: Text(
                  permission,
                  style: TextStyle(
                    color: permission == 'owner' ? Colors.blue : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // TODO: Add option to remove member or change permission
              ),
            );
          },
        );
      },
    );
  }
}