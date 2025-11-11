import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/proveedor.dart';
import '../controllers/proveedor_controller.dart';

class ProveedorFormView extends StatefulWidget {
  final Proveedor? item;

  const ProveedorFormView({super.key, this.item});

  @override
  State<ProveedorFormView> createState() => _ProveedorFormViewState();
}

class _ProveedorFormViewState extends State<ProveedorFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nitController = TextEditingController();
  final _direccionController = TextEditingController();
  final _nrotelefonoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nitController.text = widget.item!.nit?.toString() ?? '';
      _direccionController.text = widget.item!.direccion?.toString() ?? '';
      _nrotelefonoController.text = widget.item!.nrotelefono?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Nuevo Proveedor' : 'Editar Proveedor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nitController,
                decoration: const InputDecoration(labelText: 'nit'),
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
                controller: _direccionController,
                decoration: const InputDecoration(labelText: 'direccion'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nrotelefonoController,
                decoration: const InputDecoration(labelText: 'nrotelefono'),
                keyboardType: TextInputType.number,
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
                    final controller = context.read<ProveedorController>();

                    final item = Proveedor(
                      id: widget.item?.id ?? 0,
                      nit: int.tryParse(_nitController.text) ?? 0,
                      direccion: _direccionController.text,
                      nrotelefono: int.tryParse(_nrotelefonoController.text) ?? 0,
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
