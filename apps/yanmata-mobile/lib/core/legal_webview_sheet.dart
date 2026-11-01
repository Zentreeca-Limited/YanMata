import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yanmata/core/api.dart';
import 'package:yanmata/core/theme.dart';

class LegalWebViewSheet extends StatefulWidget {
  const LegalWebViewSheet({super.key, required this.title, required this.url});

  final String title;
  final String url;

  static String get webOrigin {
    final uri = Uri.parse(Api.base);
    final portSuffix = uri.hasPort ? ':${uri.port}' : '';
    return '${uri.scheme}://${uri.host}$portSuffix';
  }

  static Future<void> showTerms(BuildContext context, {String? title}) {
    return show(
      context,
      title: title ?? 'Terms of Service',
      url: '$webOrigin/terms-of-use',
    );
  }

  static Future<void> showPrivacy(BuildContext context, {String? title}) {
    return show(
      context,
      title: title ?? 'Privacy Policy',
      url: '$webOrigin/privacy-policy',
    );
  }

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String url,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: isDark ? Palette.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => FractionallySizedBox(
        heightFactor: 0.75,
        child: LegalWebViewSheet(title: title, url: url),
      ),
    );
  }

  @override
  State<LegalWebViewSheet> createState() => _LegalWebViewSheetState();
}

class _LegalWebViewSheetState extends State<LegalWebViewSheet> {
  WebViewController? _controller;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    try {
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) {
              if (mounted) {
                setState(() {
                  _isLoading = true;
                  _hasError = false;
                });
              }
            },
            onPageFinished: (_) {
              if (mounted) {
                setState(() => _isLoading = false);
              }
            },
            onWebResourceError: (_) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                  _hasError = true;
                });
              }
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.url));
      _controller = controller;
    } catch (_) {
      // Fallback for test environments where platform WebView is not registered
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = isDark ? Palette.darkText : Palette.ink;
    final muted = isDark ? Palette.darkMuted : Palette.slate;
    final accent = Theme.of(context).colorScheme.primary;

    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: muted.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 12, 10),
          child: Row(
            children: [
              Icon(Icons.shield_outlined, size: 18, color: accent),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontFamily: 'Fraunces',
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: text,
                      ),
                    ),
                    Text(
                      widget.url,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11, color: muted),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Open in browser',
                icon: Icon(Icons.open_in_new, size: 18, color: muted),
                onPressed: () {
                  launchUrl(
                    Uri.parse(widget.url),
                    mode: LaunchMode.externalApplication,
                  );
                },
              ),
              IconButton(
                tooltip: 'Close',
                icon: Icon(Icons.close, size: 20, color: text),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          color: isDark ? Palette.darkBorder : const Color(0xFFE9E2E9),
        ),
        if (_isLoading)
          LinearProgressIndicator(
            minHeight: 2,
            color: accent,
            backgroundColor: Colors.transparent,
          ),
        Expanded(
          child: _controller != null && !_hasError
              ? ClipRRect(
                  child: WebViewWidget(
                    controller: _controller!,
                    gestureRecognizers: {
                      Factory<VerticalDragGestureRecognizer>(
                        VerticalDragGestureRecognizer.new,
                      ),
                    },
                  ),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.public, size: 40, color: accent),
                        const SizedBox(height: 12),
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontFamily: 'Fraunces',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: text,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.url,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12.5, color: muted),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: () {
                            if (_controller != null) {
                              setState(() {
                                _hasError = false;
                                _isLoading = true;
                              });
                              _controller!.reload();
                            } else {
                              launchUrl(
                                Uri.parse(widget.url),
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          },
                          icon: const Icon(Icons.refresh, size: 16),
                          label: const Text('Reload page'),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
