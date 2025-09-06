// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/modules/webview/controllers/webview_controller.dart';

class WebviewView extends StatefulWidget {
  final String? url;
  final String? title;

  const WebviewView({super.key, this.url, this.title});

  @override
  State<WebviewView> createState() => _EnhancedWebviewViewState();
}

class _EnhancedWebviewViewState extends State<WebviewView>
    with TickerProviderStateMixin {
  late AnimationController _downloadButtonController;
  late AnimationController _progressController;
  late AnimationController _heartController;
  late Animation<double> _downloadButtonAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _heartAnimation;

  @override
  void initState() {
    super.initState();
    
    _downloadButtonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _downloadButtonAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _downloadButtonController,
      curve: Curves.elasticOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _heartAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _heartController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _downloadButtonController.dispose();
    _progressController.dispose();
    _heartController.dispose();
    super.dispose();
  }

  void _playHeartAnimation() {
    _heartController.forward().then((_) {
      _heartController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final WebviewController controller = Get.put(WebviewController());
    final GlobalKey webViewKey = GlobalKey();

    InAppWebViewSettings settings = InAppWebViewSettings(
      userAgent:
          "Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36",
      javaScriptEnabled: true,
      supportZoom: false,
      initialScale: 6,
      useWideViewPort: true,
      loadWithOverviewMode: true,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      clearCache: false,
    );

    PullToRefreshController? pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(
              color: const Color(0xFF6C63FF),
              backgroundColor: Colors.white,
            ),
            onRefresh: () async {
              controller.webViewController?.reload();
            },
          );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6C63FF),
              Color(0xFF9C88FF),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar with Glassmorphism Effect
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Back Button with Animation
                    GestureDetector(
                      onTap: () {
                        _downloadButtonController.forward().then((_) {
                          _downloadButtonController.reverse();
                          Get.back();
                        });
                      },
                      child: AnimatedBuilder(
                        animation: _downloadButtonAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _downloadButtonAnimation.value,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Title with Shimmer Effect
                    Expanded(
                      child: Text(
                        widget.title ?? "Certificate Viewer",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Love/Heart Animation Button
                    GestureDetector(
                      onTap: _playHeartAnimation,
                      child: AnimatedBuilder(
                        animation: _heartAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _heartAnimation.value,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(width: 8),
                    
                    // Download Button with Animation
                    Obx(() {
                      return GestureDetector(
                        onTap: controller.isDownloading.value
                            ? null
                            : () {
                                _downloadButtonController.forward().then((_) {
                                  _downloadButtonController.reverse();
                                  controller.downloadCertificate(widget.url ?? "");
                                });
                              },
                        child: AnimatedBuilder(
                          animation: _downloadButtonAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _downloadButtonAnimation.value,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: controller.isDownloading.value
                                      ? Colors.orange.withOpacity(0.2)
                                      : Colors.green.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: controller.isDownloading.value
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          value: controller.downloadProgress.value,
                                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                                          backgroundColor: Colors.orange.withOpacity(0.3),
                                        ),
                                      )
                                    : const Icon(
                                        Icons.file_download_outlined,
                                        color: Colors.green,
                                        size: 20,
                                      ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
              
              // WebView Container with Rounded Corners
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Obx(() {
                      return Stack(
                        children: [
                          InAppWebView(
                            key: webViewKey,
                            initialUrlRequest: widget.url != null && widget.url!.isNotEmpty
                                ? URLRequest(url: WebUri(widget.url!))
                                : null,
                            initialSettings: settings,
                            pullToRefreshController: pullToRefreshController,
                            onWebViewCreated: (webController) {
                              controller.webViewController = webController;
                            },
                            onLoadStart: (webController, url) {
                              controller.setLoading(true);
                              controller.updateUrl(url?.toString() ?? '');
                            },
                            onLoadStop: (webController, url) async {
                              controller.setLoading(false);
                              pullToRefreshController?.endRefreshing();
                              controller.updateUrl(url?.toString() ?? '');

                              // Add JS handler for download requests from page JS
                              webController.addJavaScriptHandler(
                                handlerName: 'downloadImage',
                                callback: (args) {
                                  if (args.isNotEmpty) {
                                    final imageUrl = args[0].toString();
                                    controller.downloadFile(imageUrl);
                                  }
                                },
                              );
                            },
                            onLoadError: (controller, url, code, message) {
                              debugPrint("❌ onLoadError [$code]: $message");
                              _showErrorSnackbar(message);
                            },
                            onLoadHttpError: (controller, url, statusCode, description) {
                              debugPrint("❌ HTTP Error [$statusCode]: $description");
                              _showErrorSnackbar(description);
                            },
                            onConsoleMessage: (controller, consoleMessage) {
                              debugPrint("🧪 Console: ${consoleMessage.message}");
                            },
                          ),

                          // Enhanced Loading Overlay
                          if (controller.isLoading.value)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.95),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF6C63FF).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: const CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(0xFF6C63FF),
                                        ),
                                        strokeWidth: 3,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Loading Certificate...',
                                      style: TextStyle(
                                        color: Color(0xFF6C63FF),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      
      // Floating Download Progress
      floatingActionButton: Obx(() {
        return controller.isDownloading.value
            ? AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 0.8 + (0.2 * _progressAnimation.value),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFF9C88FF)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6C63FF).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.cloud_download_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${(controller.downloadProgress.value * 100).toInt()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: 40,
                            child: LinearProgressIndicator(
                              value: controller.downloadProgress.value,
                              backgroundColor: Colors.white.withOpacity(0.3),
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                              minHeight: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : const SizedBox.shrink();
      }),
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Oops!',
      message,
      backgroundColor: Colors.red.withOpacity(0.9),
      colorText: Colors.white,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      snackPosition: SnackPosition.TOP,
    );
  }

  void _showDownloadOptions(
    BuildContext context,
    WebviewController controller,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Download Options',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 20),
            
            _buildOptionTile(
              icon: Icons.download_for_offline,
              title: 'Download Certificate',
              subtitle: 'Save certificate to your device',
              color: const Color(0xFF6C63FF),
              onTap: () async {
                Navigator.pop(context);
                controller.downloadCertificate(widget.url ?? "");
              },
            ),
            
            const SizedBox(height: 12),
            
            _buildOptionTile(
              icon: Icons.collections,
              title: 'Download All Images',
              subtitle: 'Save all images from this page',
              color: const Color(0xFF38B2AC),
              onTap: () async {
                Navigator.pop(context);
                final images = await controller.getAllImages();
                if (images.isNotEmpty) {
                  for (final imageUrl in images) {
                    await controller.downloadFile(imageUrl);
                    await Future.delayed(const Duration(milliseconds: 500));
                  }
                } else {
                  Get.snackbar(
                    'No Images Found',
                    'No images available on this page',
                    backgroundColor: Colors.orange.withOpacity(0.9),
                    colorText: Colors.white,
                    icon: const Icon(Icons.info_outline, color: Colors.white),
                  );
                }
              },
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}