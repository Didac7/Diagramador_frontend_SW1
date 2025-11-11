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
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nombreController.text = widget.item!.nombre?.toString() ?? '';
      _telefonoController.text = widget.item!.telefono?.toString() ?? '';
      _emailController.text = widget.item!.email?.toString() ?? '';
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
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefonoController,
                decoration: const InputDecoration(labelText: 'Telefono'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final controller = context.read<ProveedorController>();

                    final item = Proveedor(
                      idProveedor: widget.item?.idProveedor,
                      nombre: _nombreController.text,
                      telefono: _telefonoController.text.isEmpty ? null : _telefonoController.text,
                      email: _emailController.text.isEmpty ? null : _emailController.text,
                    );

                    bool success;
                    if (widget.item == null) {
                      success = await controller.create(item);
                    } else {
                      success = await controller.update(widget.item!.idProveedor ?? 0, item);
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
