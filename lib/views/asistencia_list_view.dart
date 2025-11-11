import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/asistencia_controller.dart';
import 'asistencia_form_view.dart';

class AsistenciaListView extends StatefulWidget {
  const AsistenciaListView({super.key});

  @override
  State<AsistenciaListView> createState() => _AsistenciaListViewState();
}

class _AsistenciaListViewState extends State<AsistenciaListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AsistenciaController>().getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistencia'),
      ),
      body: Consumer<AsistenciaController>(
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
                title: Text(item.Fecha.toString()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AsistenciaFormView(item: item),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await controller.delete(item.Idasistencia as int);
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
            MaterialPageRoute(builder: (_) => const AsistenciaFormView()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
