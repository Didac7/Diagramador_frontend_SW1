import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/persona.dart';
import '../controllers/persona_controller.dart';

class PersonaFormView extends StatefulWidget {
  final Persona? item;

  const PersonaFormView({super.key, this.item});

  @override
  State<PersonaFormView> createState() => _PersonaFormViewState();
}

class _PersonaFormViewState extends State<PersonaFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _ciController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nombreController.text = widget.item!.nombre?.toString() ?? '';
      _ciController.text = widget.item!.ci?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Nuevo Persona' : 'Editar Persona'),
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
                controller: _ciController,
                decoration: const InputDecoration(labelText: 'ci'),
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
                    final controller = context.read<PersonaController>();

                    final item = Persona(
                      id: widget.item?.id ?? 0,
                      nombre: _nombreController.text,
                      ci: int.tryParse(_ciController.text) ?? 0,
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
