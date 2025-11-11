import 'views/persona_list_view.dart';
import 'views/proveedor_list_view.dart';
import 'views/vendedor_list_view.dart';
import 'views/cliente_list_view.dart';
import 'views/producto_list_view.dart';
import 'views/almacen_list_view.dart';
import 'views/inventario_list_view.dart';
import 'views/arch_inventario_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/persona_controller.dart';
import 'controllers/proveedor_controller.dart';
import 'controllers/vendedor_controller.dart';
import 'controllers/cliente_controller.dart';
import 'controllers/producto_controller.dart';
import 'controllers/almacen_controller.dart';
import 'controllers/inventario_controller.dart';
import 'controllers/arch_inventario_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PersonaController()),
        ChangeNotifierProvider(create: (_) => ProveedorController()),
        ChangeNotifierProvider(create: (_) => VendedorController()),
        ChangeNotifierProvider(create: (_) => ClienteController()),
        ChangeNotifierProvider(create: (_) => ProductoController()),
        ChangeNotifierProvider(create: (_) => AlmacenController()),
        ChangeNotifierProvider(create: (_) => InventarioController()),
        ChangeNotifierProvider(create: (_) => ArchInventarioController()),
      ],
      child: MaterialApp(
        title: 'proyecto_Generado',
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
      appBar: AppBar(title: const Text('proyecto_Generado')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Persona'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PersonaListView(),
                ),
              );
            },
          ),
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
            title: Text('Vendedor'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const VendedorListView(),
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
            title: Text('Almacen'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AlmacenListView(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Inventario'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const InventarioListView(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('ArchInventario'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ArchInventarioListView(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
