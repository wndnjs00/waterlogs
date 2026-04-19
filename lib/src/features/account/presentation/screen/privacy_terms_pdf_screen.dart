import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfx/pdfx.dart';

/// 회원가입에서 제공하는 개인정보 처리방침 및 이용약관 PDF 뷰어.
class PrivacyTermsPdfScreen extends StatefulWidget {
  const PrivacyTermsPdfScreen({super.key});

  static const assetPath = 'assets/legal/privacy_and_terms.pdf';

  @override
  State<PrivacyTermsPdfScreen> createState() => _PrivacyTermsPdfScreenState();
}

class _PrivacyTermsPdfScreenState extends State<PrivacyTermsPdfScreen> {
  late final PdfControllerPinch _controller;

  @override
  void initState() {
    super.initState();
    // openAsset 대신 번들 바이트 로드: Android 에셋 미포함·iOS 중첩 경로 이슈 회피.
    final bytesFuture = rootBundle
        .load(PrivacyTermsPdfScreen.assetPath)
        .then((bd) => bd.buffer.asUint8List());
    _controller = PdfControllerPinch(
      document: PdfDocument.openData(bytesFuture),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          '개인정보 처리방침 및 이용약관',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: PdfViewPinch(
        controller: _controller,
        builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
          options: const DefaultBuilderOptions(),
          documentLoaderBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
          pageLoaderBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
          errorBuilder: (_, error) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                '문서를 불러올 수 없습니다.\n$error',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
