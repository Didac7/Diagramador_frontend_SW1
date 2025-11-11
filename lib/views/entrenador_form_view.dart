import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/entrenador.dart';
import '../controllers/entrenador_controller.dart';

class EntrenadorFormView extends StatefulWidget {
  final Entrenador? item;

  const EntrenadorFormView({super.key, this.item});

  @override
  State<EntrenadorFormView> createState() => _EntrenadorFormViewState();
}

class _EntrenadorFormViewState extends State<EntrenadorFormView> {
  final _formKey = GlobalKey<FormState>();
  final _NombreController = TextEditingController();
  final _EdadController = TextEditingController();
  final _GeneroController = TextEditingController();
  final _EspecialidadController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _NombreController.text = widget.item!.Nombre.toString();
      _EdadController.text = widget.item!.Edad.toString();
      _GeneroController.text = widget.item!.Genero.toString();
      _EspecialidadController.text = widget.item!.Especialidad.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Nuevo Entrenador' : 'Editar Entrenador'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _NombreController,
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
                controller: _EdadController,
                decoration: const InputDecoration(labelText: 'Edad'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _GeneroController,
                decoration: const InputDecoration(labelText: 'Genero'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _EspecialidadController,
                decoration: const InputDecoration(labelText: 'Especialidad'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final controller = context.read<EntrenadorController>();

                    final item = Entrenador(
                      Identrenador: widget.item?.Identrenador,
                      Nombre: _NombreController.text,
                      Edad: int.tryParse(_EdadController.text),
                      Genero: _GeneroController.text,
                      Especialidad: _EspecialidadController.text,
                    );

                    bool success;
                    if (widget.item == null) {
                      success = await controller.create(item);
                    } else {
                      success = await controller.update(widget.item!.Identrenador as int, item);
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
