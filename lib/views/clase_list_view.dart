import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/clase_controller.dart';
import 'clase_form_view.dart';

class ClaseListView extends StatefulWidget {
  const ClaseListView({super.key});

  @override
  State<ClaseListView> createState() => _ClaseListViewState();
}

class _ClaseListViewState extends State<ClaseListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClaseController>().getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clase'),
      ),
      body: Consumer<ClaseController>(
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
                            builder: (_) => ClaseFormView(item: item),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await controller.delete(item.Idclase as int);
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
            MaterialPageRoute(builder: (_) => const ClaseFormView()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
