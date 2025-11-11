import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/rutina.dart';
import '../controllers/rutina_controller.dart';

class RutinaFormView extends StatefulWidget {
  final Rutina? item;

  const RutinaFormView({super.key, this.item});

  @override
  State<RutinaFormView> createState() => _RutinaFormViewState();
}

class _RutinaFormViewState extends State<RutinaFormView> {
  final _formKey = GlobalKey<FormState>();
  final _NombreController = TextEditingController();
  final _DescripcionController = TextEditingController();
  final _DuracionController = TextEditingController();
  final _IdentrenadorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _NombreController.text = widget.item!.Nombre.toString();
      _DescripcionController.text = widget.item!.Descripcion.toString();
      _DuracionController.text = widget.item!.Duracion.toString();
      _IdentrenadorController.text = widget.item!.Identrenador.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Nuevo Rutina' : 'Editar Rutina'),
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
                controller: _DescripcionController,
                decoration: const InputDecoration(labelText: 'Descripcion'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _DuracionController,
                decoration: const InputDecoration(labelText: 'Duracion'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _IdentrenadorController,
                decoration: const InputDecoration(labelText: 'Identrenador'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final controller = context.read<RutinaController>();

                    final item = Rutina(
                      Idrutina: widget.item?.Idrutina,
                      Nombre: _NombreController.text,
                      Descripcion: _DescripcionController.text,
                      Duracion: _DuracionController.text,
                      Identrenador: int.tryParse(_IdentrenadorController.text),
                    );

                    bool success;
                    if (widget.item == null) {
                      success = await controller.create(item);
                    } else {
                      success = await controller.update(widget.item!.Idrutina as int, item);
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
