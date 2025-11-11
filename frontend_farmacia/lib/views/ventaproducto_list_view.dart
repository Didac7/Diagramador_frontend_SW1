import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/ventaproducto_controller.dart';
import 'ventaproducto_form_view.dart';

class VentaproductoListView extends StatefulWidget {
  const VentaproductoListView({super.key});

  @override
  State<VentaproductoListView> createState() => _VentaproductoListViewState();
}

class _VentaproductoListViewState extends State<VentaproductoListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VentaproductoController>().getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ventaproducto'),
      ),
      body: Consumer<VentaproductoController>(
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
                title: Text(item.ventaId?.toString() ?? 'Sin nombre'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VentaproductoFormView(item: item),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        if (item.ventaId != null) {
                          await controller.delete(item.ventaId!);
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
            MaterialPageRoute(builder: (_) => const VentaproductoFormView()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
