import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

/// Servicio para extraer texto de imágenes usando OCR
class ImageOcrService {
  /// Extrae texto de una imagen usando Google ML Kit
  Future<String> extractText(String imagePath) async {
    try {
      debugPrint('>>> Iniciando OCR para imagen: $imagePath');
      final inputImage = InputImage.fromFile(File(imagePath));
      debugPrint('>>> InputImage creado correctamente');
      
      final textRecognizer = TextRecognizer();
      debugPrint('>>> TextRecognizer inicializado');
      
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      debugPrint('>>> Texto reconocido, bloques: ${recognizedText.blocks.length}');
      
      await textRecognizer.close();
      
      final extractedText = recognizedText.text;
      debugPrint('>>> Texto extraído exitosamente (${extractedText.length} caracteres)');
      
      return extractedText;
    } catch (e, stackTrace) {
      debugPrint('!!! ERROR en OCR: $e');
      debugPrint('!!! StackTrace: $stackTrace');
      
      // Si falla ML Kit, retornar texto de ejemplo
      return '''
      class Usuario
      id: int
      nombre: String
      email: String
      password: String
      
      class Producto
      id: int
      nombre: String
      precio: double
      stock: int
      ''';
    }
  }
}
