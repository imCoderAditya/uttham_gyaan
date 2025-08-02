// ignore_for_file: depend_on_referenced_packages

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

void changeLanguage(Locale locale) {
  final box = GetStorage();
  box.write('languageCode', locale.languageCode);
  box.write('countryCode', locale.countryCode ?? '');

  Get.updateLocale(locale);
}

Locale? getSavedLocale() {
  final box = GetStorage();
  final langCode = box.read('languageCode');
  final countryCode = box.read('countryCode');

  if (langCode != null && countryCode != null) {
    return Locale(langCode, countryCode);
  }
  return null;
}

Future<Color> getDominantColorFromUrl(String imageUrl) async {
  try {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode != 200) {
      throw Exception('Image load failed with status: ${response.statusCode}');
    }

    final Uint8List bytes = response.bodyBytes;
    final ui.Image image = decodeImageFromList(bytes) as ui.Image;

    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) return Colors.grey;

    final Uint8List pixels = byteData.buffer.asUint8List();

    // Ensure we have enough pixels
    if (pixels.length < 4) return Colors.grey;

    // Use a map to count color frequency for true dominant color
    Map<int, int> colorCount = {};

    // Sample every 16th pixel (4 bytes per pixel × 4) for better performance
    final sampleRate = 16;

    for (int i = 0; i < pixels.length - 3; i += sampleRate) {
      final r = pixels[i];
      final g = pixels[i + 1];
      final b = pixels[i + 2];

      // Skip nearly transparent pixels
      if (pixels[i + 3] < 128) continue;

      // Group similar colors (reduce precision to avoid too many unique colors)
      final simplifiedColor = ((r ~/ 16) << 16) | ((g ~/ 16) << 8) | (b ~/ 16);
      colorCount[simplifiedColor] = (colorCount[simplifiedColor] ?? 0) + 1;
    }

    if (colorCount.isEmpty) return Colors.grey;

    // Find the most frequent color
    final dominantColor = colorCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    // Convert back to full RGB values
    final r = ((dominantColor >> 16) & 0xFF) * 16;
    final g = ((dominantColor >> 8) & 0xFF) * 16;
    final b = (dominantColor & 0xFF) * 16;

    return Color.fromARGB(255, r, g, b);
  } catch (e) {
    debugPrint('Error in getDominantColorFromUrl: $e');
    return Colors.grey;
  }
}

// Alternative: Simple average method (your original approach, improved)
Future<Color> getAverageColorFromUrl(String imageUrl) async {
  try {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode != 200) {
      throw Exception('Image load failed with status: ${response.statusCode}');
    }

    final Uint8List bytes = response.bodyBytes;
    final ui.Image image = decodeImageFromList(bytes) as ui.Image;

    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) return Colors.grey;

    final Uint8List pixels = byteData.buffer.asUint8List();

    if (pixels.length < 4) return Colors.grey;

    int r = 0, g = 0, b = 0, count = 0;

    // Sample every 16th pixel for better performance
    for (int i = 0; i < pixels.length - 3; i += 16) {
      // Skip nearly transparent pixels
      if (pixels[i + 3] < 128) continue;

      r += pixels[i];
      g += pixels[i + 1];
      b += pixels[i + 2];
      count++;
    }

    if (count == 0) return Colors.grey;

    return Color.fromARGB(255, r ~/ count, g ~/ count, b ~/ count);
  } catch (e) {
    debugPrint('Error in getAverageColorFromUrl: $e');
    return Colors.grey;
  }
}

String extractVideoId(String url) {
  final RegExp regExp = RegExp(r'(?:v=|\/)([0-9A-Za-z_-]{11})', caseSensitive: false, multiLine: false);
  final match = regExp.firstMatch(url);
  return match != null ? match.group(1)! : '';
}

