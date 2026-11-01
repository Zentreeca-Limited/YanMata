import 'package:url_launcher/url_launcher.dart';

class MapsLauncher {
  Future<bool> open(String value) async {
    final uri = Uri.tryParse(value);
    if (uri == null ||
        uri.scheme != 'https' ||
        !(uri.host == 'google.com' || uri.host.endsWith('.google.com'))) {
      return false;
    }

    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
