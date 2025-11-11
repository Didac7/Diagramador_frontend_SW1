import 'views/cliente_list_view.dart';
import 'views/entrenador_list_view.dart';
import 'views/rutina_list_view.dart';
import 'views/clase_list_view.dart';
import 'views/membresia_list_view.dart';
import 'views/asistencia_list_view.dart';
import 'views/generator_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/cliente_controller.dart';
import 'controllers/entrenador_controller.dart';
import 'controllers/rutina_controller.dart';
import 'controllers/clase_controller.dart';
import 'controllers/membresia_controller.dart';
import 'controllers/asistencia_controller.dart';
import 'controllers/generator_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GeneratorController()),
        ChangeNotifierProvider(create: (_) => ClienteController()),
        ChangeNotifierProvider(create: (_) => EntrenadorController()),
        ChangeNotifierProvider(create: (_) => RutinaController()),
        ChangeNotifierProvider(create: (_) => ClaseController()),
        ChangeNotifierProvider(create: (_) => MembresiaController()),
        ChangeNotifierProvider(create: (_) => AsistenciaController()),
      ],
      child: MaterialApp(
        title: 'Flutter MVC Generator',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const GeneratorView(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('gym')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.code, color: Colors.blue),
            title: const Text('🚀 Generador de Código'),
            subtitle: const Text('Crear nuevo proyecto desde SQL'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const GeneratorView(),
                ),
              );
            },
          ),
          const Divider(),
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
            title: Text('Entrenador'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EntrenadorListView(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Rutina'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RutinaListView(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Clase'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ClaseListView(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Membresia'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MembresiaListView(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Asistencia'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AsistenciaListView(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
