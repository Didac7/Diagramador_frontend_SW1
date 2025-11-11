import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/producto.dart';
import '../controllers/producto_controller.dart';

class ProductoFormView extends StatefulWidget {
  final Producto? item;

  const ProductoFormView({super.key, this.item});

  @override
  State<ProductoFormView> createState() => _ProductoFormViewState();
}

class _ProductoFormViewState extends State<ProductoFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _precioController = TextEditingController();
  final _stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nombreController.text = widget.item!.nombre?.toString() ?? '';
      _precioController.text = widget.item!.precio?.toString() ?? '';
      _stockController.text = widget.item!.stock?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Nuevo Producto' : 'Editar Producto'),
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
                controller: _precioController,
                decoration: const InputDecoration(labelText: 'precio'),
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
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'stock'),
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
                    final controller = context.read<ProductoController>();

                    final item = Producto(
                      id: widget.item?.id ?? 0,
                      nombre: _nombreController.text,
                      precio: double.tryParse(_precioController.text) ?? 0.0,
                      stock: int.tryParse(_stockController.text) ?? 0,
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
