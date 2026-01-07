import 'package:delta_dai_bim_web/core/constants/app_constans.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppService {
  // Esta es la función que Flutter dice que no encuentra
  Future<void> launchWhatsApp({
    String? modelName,
    bool isGeneral = false,
  }) async {
    const String phoneNumber = AppConstants.whatsAppNumber;
    String message = "";

    if (modelName != null) {
      message =
          "Hola Delta Dai BIM, me interesa información del modelo: *$modelName*";
    } else if (isGeneral) {
      message =
          "Hola Delta Dai BIM, me gustaría solicitar una cotización general.";
    } else {
      message = AppConstants.whatsAppMessage;
    }

    final String url =
        "https://api.whatsapp.com/send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}";

    try {
      final Uri uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("Error al abrir WhatsApp: $e");
      // Fallback para web/móvil si falla el primero
      final String fallbackUrl =
          "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}";
      await launchUrl(Uri.parse(fallbackUrl), mode: LaunchMode.platformDefault);
    }
  }
}
