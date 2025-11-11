import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/almacen.dart';
import '../controllers/almacen_controller.dart';

class AlmacenFormView extends StatefulWidget {
  final Almacen? item;

  const AlmacenFormView({super.key, this.item});

  @override
  State<AlmacenFormView> createState() => _AlmacenFormViewState();
}

class _AlmacenFormViewState extends State<AlmacenFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _ubicacionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nombreController.text = widget.item!.nombre?.toString() ?? '';
      _ubicacionController.text = widget.item!.ubicacion?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Nuevo Almacen' : 'Editar Almacen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ubicacionController,
                decoration: const InputDecoration(labelText: 'ubicacion'),
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
                    final controller = context.read<AlmacenController>();

                    final item = Almacen(
                      id: widget.item?.id ?? 0,
                      nombre: _nombreController.text,
                      ubicacion: _ubicacionController.text,
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
