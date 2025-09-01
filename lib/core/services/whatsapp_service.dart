import 'package:url_launcher/url_launcher.dart';

class WhatsAppService {
  static Future<void> send(String phone, String message) async {
    final uri = Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent(message)}');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) throw 'Unable to open WhatsApp';
  }
}
