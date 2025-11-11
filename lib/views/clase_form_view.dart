import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/clase.dart';
import '../controllers/clase_controller.dart';

class ClaseFormView extends StatefulWidget {
  final Clase? item;

  const ClaseFormView({super.key, this.item});

  @override
  State<ClaseFormView> createState() => _ClaseFormViewState();
}

class _ClaseFormViewState extends State<ClaseFormView> {
  final _formKey = GlobalKey<FormState>();
  final _NombreController = TextEditingController();
  final _HoraInicioController = TextEditingController();
  final _HoraFinController = TextEditingController();
  final _DiasSemanaController = TextEditingController();
  final _IdentrenadorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _NombreController.text = widget.item!.Nombre.toString();
      _HoraInicioController.text = widget.item!.HoraInicio.toString();
      _HoraFinController.text = widget.item!.HoraFin.toString();
      _DiasSemanaController.text = widget.item!.DiasSemana.toString();
      _IdentrenadorController.text = widget.item!.Identrenador.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Nuevo Clase' : 'Editar Clase'),
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
                controller: _HoraInicioController,
                decoration: const InputDecoration(labelText: 'HoraInicio'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _HoraFinController,
                decoration: const InputDecoration(labelText: 'HoraFin'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _DiasSemanaController,
                decoration: const InputDecoration(labelText: 'DiasSemana'),
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
                    final controller = context.read<ClaseController>();

                    final item = Clase(
                      Idclase: widget.item?.Idclase,
                      Nombre: _NombreController.text,
                      HoraInicio: DateTime.tryParse(_HoraInicioController.text),
                      HoraFin: DateTime.tryParse(_HoraFinController.text),
                      DiasSemana: _DiasSemanaController.text,
                      Identrenador: int.tryParse(_IdentrenadorController.text),
                    );

                    bool success;
                    if (widget.item == null) {
                      success = await controller.create(item);
                    } else {
                      success = await controller.update(widget.item!.Idclase as int, item);
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
