import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/venta_controller.dart';
import 'venta_form_view.dart';

class VentaListView extends StatefulWidget {
  const VentaListView({super.key});

  @override
  State<VentaListView> createState() => _VentaListViewState();
}

class _VentaListViewState extends State<VentaListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VentaController>().getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Venta'),
      ),
      body: Consumer<VentaController>(
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
                title: Text(item.fecha?.toString() ?? 'Sin nombre'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VentaFormView(item: item),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        if (item.idVenta != null) {
                          await controller.delete(item.idVenta!);
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
            MaterialPageRoute(builder: (_) => const VentaFormView()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
