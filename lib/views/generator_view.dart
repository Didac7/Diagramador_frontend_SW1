import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../controllers/generator_controller.dart';
import '../models/entity_model.dart';

class GeneratorView extends StatefulWidget {
  const GeneratorView({super.key});

  @override
  State<GeneratorView> createState() => _GeneratorViewState();
}

class _GeneratorViewState extends State<GeneratorView> {
  final _projectNameController = TextEditingController();
  final _baseUrlController = TextEditingController(text: 'http://localhost:8080/api');
  final _outputPathController = TextEditingController();
  final _textPromptController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Escuchar cambios en los campos para actualizar el estado del botón
    _projectNameController.addListener(() => setState(() {}));
    _outputPathController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter MVC Generator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<GeneratorController>(
        builder: (context, controller, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildInputSection(controller),
                const SizedBox(height: 24),
                if (controller.entities.isNotEmpty) ...[
                  _buildEntitiesPreview(controller),
                  const SizedBox(height: 24),
                  _buildProjectConfigSection(controller),
                ],
                const SizedBox(height: 16),
                _buildStatusSection(controller),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.code, size: 64, color: Colors.blue[700]),
            const SizedBox(height: 16),
            const Text(
              'Generador de Frontend Flutter MVC',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Sube tu diagrama, SQL o describe tu sistema',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection(GeneratorController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '📥 Entrada del Sistema',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Botón para imagen
            ElevatedButton.icon(
              onPressed: controller.isProcessing ? null : () => _pickImage(controller),
              icon: const Icon(Icons.image),
              label: const Text('🤖 Subir Imagen (Diagrama UML con IA)'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 8),
            
            // Botón para cámara
            ElevatedButton.icon(
              onPressed: controller.isProcessing ? null : () => _takePhoto(controller),
              icon: const Icon(Icons.camera_alt),
              label: const Text('📷 Tomar Foto (Analizar con IA)'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 8),
            
            // Botón para archivo SQL
            ElevatedButton.icon(
              onPressed: controller.isProcessing ? null : () => _pickSqlFile(controller),
              icon: const Icon(Icons.file_upload),
              label: const Text('📝 Subir Script SQL'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 16),
            
            const Divider(),
            const SizedBox(height: 16),
            
            // Campo de texto para prompt
            const Text('🎙️ O describe el sistema con texto:'),
            const SizedBox(height: 8),
            TextField(
              controller: _textPromptController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ej: Sistema con Usuario (nombre, email, password) y Producto (nombre, precio, stock)',
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: controller.isProcessing
                  ? null
                  : () {
                      final prompt = _textPromptController.text;
                      if (prompt.isNotEmpty) {
                        controller.processTextPrompt(prompt);
                      }
                    },
              child: const Text('Procesar Prompt'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntitiesPreview(GeneratorController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '📊 Entidades Detectadas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '${controller.entities.length} entidades',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...controller.entities.map((entity) => _buildEntityCard(entity)),
          ],
        ),
      ),
    );
  }

  Widget _buildEntityCard(EntityModel entity) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      child: ExpansionTile(
        backgroundColor: Colors.blue[50],
        collapsedBackgroundColor: Colors.white,
        title: Text(
          entity.className,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          '${entity.attributes.length} atributos',
          style: const TextStyle(color: Colors.black54),
        ),
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Atributos:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                ...entity.attributes.map((attr) => Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 4),
                  child: Row(
                    children: [
                      Icon(
                        attr.isPrimaryKey ? Icons.key : Icons.label,
                        size: 16,
                        color: attr.isPrimaryKey ? Colors.amber[700] : Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${attr.name}: ${attr.dartType}',
                        style: const TextStyle(color: Colors.black87),
                      ),
                      if (!attr.isNullable)
                        const Text(
                          ' (requerido)',
                          style: TextStyle(fontSize: 12, color: Colors.red),
                        ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectConfigSection(GeneratorController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '⚙️ Configuración del Proyecto',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _projectNameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Proyecto',
                border: OutlineInputBorder(),
                hintText: 'mi_proyecto_flutter',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _baseUrlController,
              decoration: const InputDecoration(
                labelText: 'URL del Backend (Spring Boot)',
                border: OutlineInputBorder(),
                hintText: 'http://localhost:8080/api',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _outputPathController,
                    decoration: const InputDecoration(
                      labelText: 'Ruta de Salida',
                      border: OutlineInputBorder(),
                      hintText: 'Ejemplo: C:/Users/HP/Documents/mis_proyectos',
                      helperText: 'Escribe la ruta o usa el botón (solo funciona en desktop)',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _pickOutputDirectory,
                  icon: const Icon(Icons.folder_open),
                  label: const Text('Explorar'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: controller.isProcessing || _projectNameController.text.isEmpty || _outputPathController.text.isEmpty
                  ? null
                  : () {
                      controller.generateProject(
                        projectName: _projectNameController.text,
                        baseUrl: _baseUrlController.text,
                        outputPath: _outputPathController.text,
                      );
                    },
              icon: const Icon(Icons.rocket_launch),
              label: const Text('🚀 GENERAR PROYECTO FLUTTER'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection(GeneratorController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                if (controller.isProcessing)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                if (controller.isProcessing) const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    controller.statusMessage,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            if (controller.isProcessing) ...[
              const SizedBox(height: 12),
              LinearProgressIndicator(value: controller.progress),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(GeneratorController controller) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      await controller.processImage(image.path);
    }
  }

  Future<void> _takePhoto(GeneratorController controller) async {
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    
    if (photo != null) {
      await controller.processImage(photo.path);
    }
  }

  Future<void> _pickSqlFile(GeneratorController controller) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['sql'],
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      final String sqlContent = String.fromCharCodes(result.files.single.bytes!);
      await controller.processSqlContent(sqlContent);
    }
  }

  Future<void> _pickOutputDirectory() async {
    try {
      final result = await FilePicker.platform.getDirectoryPath();
      
      if (result != null) {
        setState(() {
          _outputPathController.text = result;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠️ Error al seleccionar carpeta. Escribe la ruta manualmente.'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _baseUrlController.dispose();
    _outputPathController.dispose();
    _textPromptController.dispose();
    super.dispose();
  }
}
