import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/membresia.dart';
import '../controllers/membresia_controller.dart';

class MembresiaFormView extends StatefulWidget {
  final Membresia? item;

  const MembresiaFormView({super.key, this.item});

  @override
  State<MembresiaFormView> createState() => _MembresiaFormViewState();
}

class _MembresiaFormViewState extends State<MembresiaFormView> {
  final _formKey = GlobalKey<FormState>();
  final _TipoController = TextEditingController();
  final _MontoController = TextEditingController();
  final _DuracionController = TextEditingController();
  final _IdclienteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _TipoController.text = widget.item!.Tipo.toString();
      _MontoController.text = widget.item!.Monto.toString();
      _DuracionController.text = widget.item!.Duracion.toString();
      _IdclienteController.text = widget.item!.Idcliente.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Nuevo Membresia' : 'Editar Membresia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _TipoController,
                decoration: const InputDecoration(labelText: 'Tipo'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _MontoController,
                decoration: const InputDecoration(labelText: 'Monto'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _DuracionController,
                decoration: const InputDecoration(labelText: 'Duracion'),
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
                    final controller = context.read<MembresiaController>();

                    final item = Membresia(
                      Idmembresia: widget.item?.Idmembresia,
                      Tipo: _TipoController.text,
                      Monto: double.tryParse(_MontoController.text),
                      Duracion: _DuracionController.text,
                      Idcliente: int.tryParse(_IdclienteController.text),
                    );

                    bool success;
                    if (widget.item == null) {
                      success = await controller.create(item);
                    } else {
                      success = await controller.update(widget.item!.Idmembresia as int, item);
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
