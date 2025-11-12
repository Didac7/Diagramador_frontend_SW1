import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// Servicio de IA para analizar diagramas UML usando OpenRouter API
class AiVisionService {
  static const String _apiKey = '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';
  static const String _apiUrl = 'https://openrouter.ai/api/v1/chat/completions';
  
  /// Modelo a usar - GPT-4o-mini es más económico y también tiene buena visión
  static const String _model = 'openai/gpt-4o-mini';

  /// Analiza una imagen de diagrama UML y extrae las entidades
  Future<String> analyzeUmlDiagram(String imagePath) async {
    try {
      debugPrint('🤖 Analizando diagrama UML con IA...');
      
      // Leer la imagen y convertirla a base64
      final imageFile = File(imagePath);
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);
      
      // Detectar el tipo MIME de la imagen
      String mimeType = 'image/jpeg';
      if (imagePath.toLowerCase().endsWith('.png')) {
        mimeType = 'image/png';
      } else if (imagePath.toLowerCase().endsWith('.jpg') || imagePath.toLowerCase().endsWith('.jpeg')) {
        mimeType = 'image/jpeg';
      } else if (imagePath.toLowerCase().endsWith('.webp')) {
        mimeType = 'image/webp';
      }

      // Preparar el prompt para la IA
      final prompt = '''Analiza este diagrama UML de clases y extrae TODAS las entidades (clases) con sus atributos.

Para cada clase encontrada, genera una línea en este formato EXACTO:
NombreClase con atributo1 tipo TipoDato1, atributo2 tipo TipoDato2, atributo3 tipo TipoDato3

REGLAS IMPORTANTES:
1. Usa el nombre EXACTO de la clase tal como aparece en el diagrama (respeta mayúsculas/minúsculas)
2. Para cada atributo, identifica su tipo de dato del diagrama
3. Mapea los tipos de datos así:
   - String, VARCHAR, TEXT, CHAR → String
   - int, INT, INTEGER, NUMBER → int
   - double, DOUBLE, FLOAT, DECIMAL, REAL → double
   - DateTime, DATE, TIMESTAMP → DateTime
   - bool, BOOLEAN → bool
4. Si un atributo no tiene tipo especificado, usa String como default
5. NO incluyas el atributo "id" porque se agrega automáticamente
6. Usa el formato EXACTO: "NombreClase con attr1 tipo Tipo1, attr2 tipo Tipo2"
7. Una línea por cada clase
8. NO agregues explicaciones adicionales, solo las líneas de entidades

Ejemplo de salida esperada:
Persona con nombre tipo String, edad tipo int, email tipo String
Producto con nombre tipo String, precio tipo double, stock tipo int
Cliente con nombre tipo String, telefono tipo String, direccion tipo String

Ahora analiza el diagrama y genera las entidades:''';

      // Crear el request para OpenRouter
      final requestBody = {
        'model': _model,
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'text',
                'text': prompt,
              },
              {
                'type': 'image_url',
                'image_url': {
                  'url': 'data:$mimeType;base64,$base64Image',
                },
              },
            ],
          },
        ],
        'max_tokens': 1500, // Reducido para usar menos créditos
        'temperature': 0.3, // Baja temperatura para respuestas más precisas
      };

      debugPrint('📤 Enviando request a OpenRouter...');

      // Hacer el request
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://github.com/your-repo', // Opcional
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final content = responseData['choices'][0]['message']['content'] as String;
        
        debugPrint('✅ Respuesta de IA recibida:');
        debugPrint(content);
        
        return content.trim();
      } else {
        debugPrint('❌ Error en API: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
        throw Exception('Error en la API de IA: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ Error al analizar imagen con IA: $e');
      rethrow;
    }
  }

  /// Valida que la API key esté configurada
  bool isConfigured() {
    return _apiKey.isNotEmpty && _apiKey != 'YOUR_API_KEY_HERE';
  }
}
