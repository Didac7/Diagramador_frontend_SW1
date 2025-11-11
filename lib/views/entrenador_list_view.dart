import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/entrenador_controller.dart';
import 'entrenador_form_view.dart';

class EntrenadorListView extends StatefulWidget {
  const EntrenadorListView({super.key});

  @override
  State<EntrenadorListView> createState() => _EntrenadorListViewState();
}

class _EntrenadorListViewState extends State<EntrenadorListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EntrenadorController>().getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrenador'),
      ),
      body: Consumer<EntrenadorController>(
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
                title: Text(item.Nombre.toString()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EntrenadorFormView(item: item),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await controller.delete(item.Identrenador as int);
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
            MaterialPageRoute(builder: (_) => const EntrenadorFormView()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
