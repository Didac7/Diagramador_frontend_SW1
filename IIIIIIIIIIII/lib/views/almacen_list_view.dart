import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/almacen_controller.dart';
import 'almacen_form_view.dart';

class AlmacenListView extends StatefulWidget {
  const AlmacenListView({super.key});

  @override
  State<AlmacenListView> createState() => _AlmacenListViewState();
}

class _AlmacenListViewState extends State<AlmacenListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AlmacenController>().getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Almacen'),
      ),
      body: Consumer<AlmacenController>(
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
                            builder: (_) => AlmacenFormView(item: item),
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
            MaterialPageRoute(builder: (_) => const AlmacenFormView()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
