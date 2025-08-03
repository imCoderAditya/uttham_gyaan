import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_styles.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String uid;

  const WebViewScreen({super.key, required this.url, required this.uid});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  bool loading = true;

  late InAppWebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.headerGradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'Payment'.tr,
          style: AppTextStyles.headlineMedium().copyWith(color: AppColors.white, fontSize: 20.sp),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  useShouldOverrideUrlLoading: true,
                  javaScriptEnabled: true,
                  javaScriptCanOpenWindowsAutomatically: true,
                ),
                android: AndroidInAppWebViewOptions(useWideViewPort: false, domStorageEnabled: true),
                ios: IOSInAppWebViewOptions(allowsInlineMediaPlayback: true, enableViewportScale: true),
              ),
              initialUrlRequest: URLRequest(url: WebUri.uri(Uri(path: widget.url))),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                final uri = navigationAction.request.url;
                if (uri != null) {
                  // Detect thankyou route

                  // Handle UPI payment URLs

                  // Detect failure URLs
                }
                return NavigationActionPolicy.ALLOW;
              },
              onLoadStart: (controller, url) {
                setState(() => loading = true);
              },
              onLoadStop: (controller, url) async {
                setState(() => loading = false);
                if (url != null) {
                  if (url.toString().contains("RegistrationPay.aspx") && url.toString().contains("customer_id")) {
                  } else if (url.toString().contains("failure") || url.toString().contains("order_status=failure")) {}
                }
              },
              onProgressChanged: (controller, progress) {
                if (progress == 100) {
                  setState(() => loading = false);
                }
              },
            ),
            if (loading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
