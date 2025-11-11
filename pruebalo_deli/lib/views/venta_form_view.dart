import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/venta.dart';
import '../controllers/venta_controller.dart';

class VentaFormView extends StatefulWidget {
  final Venta? item;

  const VentaFormView({super.key, this.item});

  @override
  State<VentaFormView> createState() => _VentaFormViewState();
}

class _VentaFormViewState extends State<VentaFormView> {
  final _formKey = GlobalKey<FormState>();
  final _fechaController = TextEditingController();
  final _totalController = TextEditingController();
  final _clienteIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _fechaController.text = widget.item!.fecha?.toString() ?? '';
      _totalController.text = widget.item!.total?.toString() ?? '';
      _clienteIdController.text = widget.item!.clienteId?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Nuevo Venta' : 'Editar Venta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _fechaController,
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
                controller: _totalController,
                decoration: const InputDecoration(labelText: 'Total'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _clienteIdController,
                decoration: const InputDecoration(labelText: 'ClienteId'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final controller = context.read<VentaController>();

                    final item = Venta(
                      idVenta: widget.item?.idVenta,
                      fecha: DateTime.tryParse(_fechaController.text) ?? DateTime.now(),
                      total: double.tryParse(_totalController.text) ?? 0.0,
                      clienteId: int.tryParse(_clienteIdController.text),
                    );

                    bool success;
                    if (widget.item == null) {
                      success = await controller.create(item);
                    } else {
                      success = await controller.update(widget.item!.idVenta ?? 0, item);
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
