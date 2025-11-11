import 'views/proveedor_list_view.dart';
import 'views/cliente_list_view.dart';
import 'views/producto_list_view.dart';
import 'views/venta_list_view.dart';
import 'views/ventaproducto_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/proveedor_controller.dart';
import 'controllers/cliente_controller.dart';
import 'controllers/producto_controller.dart';
import 'controllers/venta_controller.dart';
import 'controllers/ventaproducto_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProveedorController()),
        ChangeNotifierProvider(create: (_) => ClienteController()),
        ChangeNotifierProvider(create: (_) => ProductoController()),
        ChangeNotifierProvider(create: (_) => VentaController()),
        ChangeNotifierProvider(create: (_) => VentaproductoController()),
      ],
      child: MaterialApp(
        title: 'frontend_farmacia',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('frontend_farmacia')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Proveedor'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProveedorListView(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Cliente'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ClienteListView(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Producto'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProductoListView(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Venta'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const VentaListView(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Ventaproducto'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const VentaproductoListView(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
