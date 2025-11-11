import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/membresia_controller.dart';
import 'membresia_form_view.dart';

class MembresiaListView extends StatefulWidget {
  const MembresiaListView({super.key});

  @override
  State<MembresiaListView> createState() => _MembresiaListViewState();
}

class _MembresiaListViewState extends State<MembresiaListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MembresiaController>().getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membresia'),
      ),
      body: Consumer<MembresiaController>(
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
                title: Text(item.Tipo.toString()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MembresiaFormView(item: item),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await controller.delete(item.Idmembresia as int);
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
            MaterialPageRoute(builder: (_) => const MembresiaFormView()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
