import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/vendedor.dart';
import '../controllers/vendedor_controller.dart';

class VendedorFormView extends StatefulWidget {
  final Vendedor? item;

  const VendedorFormView({super.key, this.item});

  @override
  State<VendedorFormView> createState() => _VendedorFormViewState();
}

class _VendedorFormViewState extends State<VendedorFormView> {
  final _formKey = GlobalKey<FormState>();
  final _salarioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _salarioController.text = widget.item!.salario?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Nuevo Vendedor' : 'Editar Vendedor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _salarioController,
                decoration: const InputDecoration(labelText: 'salario'),
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
                    final controller = context.read<VendedorController>();

                    final item = Vendedor(
                      id: widget.item?.id ?? 0,
                      salario: double.tryParse(_salarioController.text) ?? 0.0,
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
