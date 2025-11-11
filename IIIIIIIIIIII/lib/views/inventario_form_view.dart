import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/inventario.dart';
import '../controllers/inventario_controller.dart';

class InventarioFormView extends StatefulWidget {
  final Inventario? item;

  const InventarioFormView({super.key, this.item});

  @override
  State<InventarioFormView> createState() => _InventarioFormViewState();
}

class _InventarioFormViewState extends State<InventarioFormView> {
  final _formKey = GlobalKey<FormState>();
  final _cantidadController = TextEditingController();
  final _fechaIngresoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _cantidadController.text = widget.item!.cantidad?.toString() ?? '';
      _fechaIngresoController.text = widget.item!.fechaIngreso?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Nuevo Inventario' : 'Editar Inventario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _cantidadController,
                decoration: const InputDecoration(labelText: 'cantidad'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fechaIngresoController,
                decoration: const InputDecoration(labelText: 'fechaIngreso'),
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
                    final controller = context.read<InventarioController>();

                    final item = Inventario(
                      id: widget.item?.id ?? 0,
                      cantidad: int.tryParse(_cantidadController.text) ?? 0,
                      fechaIngreso: DateTime.tryParse(_fechaIngresoController.text) ?? DateTime.now(),
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
