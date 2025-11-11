import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/persona_controller.dart';
import 'persona_form_view.dart';

class PersonaListView extends StatefulWidget {
  const PersonaListView({super.key});

  @override
  State<PersonaListView> createState() => _PersonaListViewState();
}

class _PersonaListViewState extends State<PersonaListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PersonaController>().getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Persona'),
      ),
      body: Consumer<PersonaController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.error != null) {
            return Center(child: Text('Error: ${controller.error}'));
          }

          return ListView.builder(
            itemCount: controller.items.length,
            itemBuilder: (context, index) {
              final item = controller.items[index];
              return ListTile(
                title: Text(item.nombre?.toString() ?? 'Sin nombre'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PersonaFormView(item: item),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        if (item.id != null) {
                          await controller.delete(item.id!);
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PersonaFormView()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
