import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cliente.dart';
import '../controllers/cliente_controller.dart';

class ClienteFormView extends StatefulWidget {
  final Cliente? item;

  const ClienteFormView({super.key, this.item});

  @override
  State<ClienteFormView> createState() => _ClienteFormViewState();
}

class _ClienteFormViewState extends State<ClienteFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _edadController = TextEditingController();
  final _generoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nombreController.text = widget.item!.nombre ?? '';
      _edadController.text = widget.item!.edad?.toString() ?? '';
      _generoController.text = widget.item!.genero ?? '';
      _telefonoController.text = widget.item!.telefono ?? '';
      _emailController.text = widget.item!.email ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Nuevo Cliente' : 'Editar Cliente'),
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
                controller: _edadController,
                decoration: const InputDecoration(labelText: 'Edad'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _generoController,
                decoration: const InputDecoration(labelText: 'Genero'),
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
                    final controller = context.read<ClienteController>();

                    final item = Cliente(
                      idCliente: widget.item?.idCliente,
                      nombre: _nombreController.text,
                      edad: int.tryParse(_edadController.text),
                      genero: _generoController.text,
                      telefono: _telefonoController.text,
                      email: _emailController.text,
                    );

                    bool success;
                    if (widget.item == null) {
                      success = await controller.create(item);
                    } else {
                      success = await controller.update(widget.item!.idCliente!, item);
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
