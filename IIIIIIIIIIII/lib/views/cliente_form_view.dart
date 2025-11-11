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
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _emailController.text = widget.item!.email?.toString() ?? '';
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
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'email'),
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
                    final controller = context.read<ClienteController>();

                    final item = Cliente(
                      id: widget.item?.id ?? 0,
                      email: _emailController.text,
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
