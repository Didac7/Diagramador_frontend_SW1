import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/arch_inventario.dart';
import '../controllers/arch_inventario_controller.dart';

class ArchInventarioFormView extends StatefulWidget {
  final ArchInventario? item;

  const ArchInventarioFormView({super.key, this.item});

  @override
  State<ArchInventarioFormView> createState() => _ArchInventarioFormViewState();
}

class _ArchInventarioFormViewState extends State<ArchInventarioFormView> {
  final _formKey = GlobalKey<FormState>();
  final _descripcionController = TextEditingController();
  final _fechaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _descripcionController.text = widget.item!.descripcion?.toString() ?? '';
      _fechaController.text = widget.item!.fecha?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Nuevo ArchInventario' : 'Editar ArchInventario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'descripcion'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fechaController,
                decoration: const InputDecoration(labelText: 'fecha'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final controller = context.read<ArchInventarioController>();

                    final item = ArchInventario(
                      id: widget.item?.id ?? 0,
                      descripcion: _descripcionController.text,
                      fecha: DateTime.tryParse(_fechaController.text) ?? DateTime.now(),
                    );

                    bool success;
                    if (widget.item == null) {
                      success = await controller.create(item);
                    } else {
                      success = await controller.update(widget.item!.id ?? 0, item);
                    }

                    if (success && mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
