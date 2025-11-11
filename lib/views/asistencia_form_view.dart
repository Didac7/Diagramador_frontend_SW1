import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/asistencia.dart';
import '../controllers/asistencia_controller.dart';

class AsistenciaFormView extends StatefulWidget {
  final Asistencia? item;

  const AsistenciaFormView({super.key, this.item});

  @override
  State<AsistenciaFormView> createState() => _AsistenciaFormViewState();
}

class _AsistenciaFormViewState extends State<AsistenciaFormView> {
  final _formKey = GlobalKey<FormState>();
  final _FechaController = TextEditingController();
  final _EstadoController = TextEditingController();
  final _IdclienteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _FechaController.text = widget.item!.Fecha.toString();
      _EstadoController.text = widget.item!.Estado.toString();
      _IdclienteController.text = widget.item!.Idcliente.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Nuevo Asistencia' : 'Editar Asistencia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _FechaController,
                decoration: const InputDecoration(labelText: 'Fecha'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _EstadoController,
                decoration: const InputDecoration(labelText: 'Estado'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _IdclienteController,
                decoration: const InputDecoration(labelText: 'Idcliente'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final controller = context.read<AsistenciaController>();

                    final item = Asistencia(
                      Idasistencia: widget.item?.Idasistencia,
                      Fecha: DateTime.tryParse(_FechaController.text) ?? DateTime.now(),
                      Estado: _EstadoController.text,
                      Idcliente: int.tryParse(_IdclienteController.text),
                    );

                    bool success;
                    if (widget.item == null) {
                      success = await controller.create(item);
                    } else {
                      success = await controller.update(widget.item!.Idasistencia as int, item);
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
