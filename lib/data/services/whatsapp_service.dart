import 'package:url_launcher/url_launcher.dart';
import '../../core/app_constants.dart';

class WhatsAppService {
  Future<void> launchWhatsApp({
    String? modelName,
    bool isGeneral = false,
  }) async {
    const String phoneNumber = AppConstants.whatsAppNumber;
    String message = isGeneral
        ? "Hola, solicito información general."
        : (modelName != null
              ? "Hola, me interesa el modelo: *$modelName*"
              : AppConstants.whatsAppMessage);

    final String url =
        "https://api.whatsapp.com/send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}";

    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      final String fallback =
          "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}";
      await launchUrl(Uri.parse(fallback), mode: LaunchMode.platformDefault);
    }
  }
}
