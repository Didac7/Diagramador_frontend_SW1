import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ventaproducto.dart';
import '../controllers/ventaproducto_controller.dart';

class VentaproductoFormView extends StatefulWidget {
  final Ventaproducto? item;

  const VentaproductoFormView({super.key, this.item});

  @override
  State<VentaproductoFormView> createState() => _VentaproductoFormViewState();
}

class _VentaproductoFormViewState extends State<VentaproductoFormView> {
  final _formKey = GlobalKey<FormState>();
  final _ventaIdController = TextEditingController();
  final _productoIdController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _subtotalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _ventaIdController.text = widget.item!.ventaId?.toString() ?? '';
      _productoIdController.text = widget.item!.productoId?.toString() ?? '';
      _cantidadController.text = widget.item!.cantidad?.toString() ?? '';
      _subtotalController.text = widget.item!.subtotal?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Nuevo Ventaproducto' : 'Editar Ventaproducto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _ventaIdController,
                decoration: const InputDecoration(labelText: 'VentaId'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _productoIdController,
                decoration: const InputDecoration(labelText: 'ProductoId'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cantidadController,
                decoration: const InputDecoration(labelText: 'Cantidad'),
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
                controller: _subtotalController,
                decoration: const InputDecoration(labelText: 'Subtotal'),
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
                    final controller = context.read<VentaproductoController>();

                    final item = Ventaproducto(
                      ventaId: int.tryParse(_ventaIdController.text),
                      productoId: int.tryParse(_productoIdController.text),
                      cantidad: int.tryParse(_cantidadController.text) ?? 0,
                      subtotal: double.tryParse(_subtotalController.text) ?? 0.0,
                    );

                    bool success;
                    if (widget.item == null) {
                      success = await controller.create(item);
                    } else {
                      success = await controller.update(widget.item!.ventaId ?? 0, item);
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
