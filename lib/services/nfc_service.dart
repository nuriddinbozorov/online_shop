import 'package:nfc_manager/nfc_manager.dart';

class NfcService {
  static Future<String?> readTag() async {
    if (!await NfcManager.instance.isAvailable()) {
      return null;
    }

    String? tagId;

    await NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        tagId = tag.data.toString(); // Yoki kerakli qiymatni aniqlang
        await NfcManager.instance.stopSession();
      },
    );

    return tagId;
  }
}
