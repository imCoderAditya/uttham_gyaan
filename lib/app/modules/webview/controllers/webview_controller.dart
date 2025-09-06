// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class WebviewController extends GetxController {
  var currentUrl = ''.obs;
  var isLoading = true.obs;
  var downloadProgress = 0.0.obs;
  var isDownloading = false.obs;

  InAppWebViewController? webViewController;

  void updateUrl(String url) => currentUrl.value = url;
  void setLoading(bool loading) => isLoading.value = loading;
  void setDownloadProgress(double progress) =>
      downloadProgress.value = progress;
  void setDownloading(bool downloading) => isDownloading.value = downloading;

  /// Request storage permission with handling for Android and iOS
  /// Returns true if permission granted, false otherwise.
  Future<bool> requestStoragePermission() async {
    await openAppSettings();
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }

      if (await Permission.manageExternalStorage.isDenied) {
        final status = await Permission.manageExternalStorage.request();
        if (status.isGranted) return true;
        if (status.isPermanentlyDenied) {
          await openAppSettings();
        }
        return false;
      }
    }

    // For iOS or below Android 11 fallback
    final status = await Permission.storage.status;
    if (status.isGranted) return true;

    final requestStatus = await Permission.storage.request();

    if (requestStatus.isGranted) return true;
    if (requestStatus.isPermanentlyDenied) {
      await openAppSettings();
    }
    return false;
  }

  /// Download file from URL with permission check and progress update
  Future<void> downloadFile(String fileUrl) async {
    if (fileUrl.isEmpty) {
      Get.snackbar('Error', 'No file URL provided');
      return;
    }

    final permissionGranted = await requestStoragePermission();
    if (!permissionGranted) {
      Get.snackbar('Permission Denied', 'Storage permission is required');
      return;
    }

    try {
      setDownloading(true);
      setDownloadProgress(0.0);

      final response = await http.Client().send(
        http.Request('GET', Uri.parse(fileUrl)),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to download file. Status code: ${response.statusCode}',
        );
      }

      // Try to get filename from content-disposition header
      String? fileName;
      final contentDisposition = response.headers['content-disposition'];
      if (contentDisposition != null) {
        final regex = RegExp(r'filename="?([^"]+)"?');
        final match = regex.firstMatch(contentDisposition);
        if (match != null) {
          fileName = match.group(1);
        }
      }

      // Fallback to extracting extension from URL if filename not found
      if (fileName == null || fileName.trim().isEmpty) {
        String extension = '';
        try {
          extension = fileUrl.split('.').last.split('?').first.toLowerCase();
        } catch (_) {
          extension = 'jpg';
        }

        final allowedExt = [
          'jpg',
          'jpeg',
          'png',
          'gif',
          'webp',
          'pdf',
          'mp4',
          'mp3',
          'txt',
          'doc',
          'docx',
          'xls',
          'xlsx',
          'ppt',
          'pptx',
          'zip',
          'rar',
          'csv',
          'json',
          'xml',
        ];

        if (!allowedExt.contains(extension)) {
          extension = 'jpg';
        }

        fileName = 'file_${DateTime.now().millisecondsSinceEpoch}.$extension';
      }

      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        throw Exception('Failed to get storage directory');
      }

      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      final sink = file.openWrite();

      final contentLength = response.contentLength ?? 0;
      int bytesReceived = 0;

      await response.stream
          .listen(
            (List<int> newBytes) {
              bytesReceived += newBytes.length;
              sink.add(newBytes);
              if (contentLength > 0) {
                setDownloadProgress(bytesReceived / contentLength);
              }
            },
            onDone: () async {
              await sink.close();
              setDownloadProgress(1.0);
              Get.snackbar(
                'Success',
                'File downloaded to $filePath',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            onError: (e) async {
              await sink.close();
              if (await file.exists()) {
                await file.delete();
              }
              throw e;
            },
            cancelOnError: true,
          )
          .asFuture();
    } catch (e) {
      Get.snackbar(
        'Download Failed',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setDownloading(false);
      setDownloadProgress(0.0);
    }
  }

  /// Get all images from the current web page loaded in WebView
  Future<List<String>> getAllImages() async {
    try {
      final result = await webViewController?.evaluateJavascript(
        source: '''
        (function() {
          const images = Array.from(document.querySelectorAll('img'));
          return images.map(img => img.src).filter(src => src && src.startsWith('http'));
        })();
      ''',
      );

      if (result is List) {
        return result.cast<String>();
      }
      return [];
    } catch (e) {
      debugPrint('Error getting images: $e');
      return [];
    }
  }

  Future<void> downloadCertificate(String certificateLink) async {
    try {
      final Uri url = Uri.parse(certificateLink);

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        Get.snackbar(
          'Success',
          'Certificate download started',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Could not open certificate link',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to download certificate: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
