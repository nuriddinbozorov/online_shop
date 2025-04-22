import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcReaderScreen extends StatefulWidget {
  const NfcReaderScreen({super.key});

  @override
  State<NfcReaderScreen> createState() => _NfcReaderScreenState();
}

class _NfcReaderScreenState extends State<NfcReaderScreen> {
  String? tagId;

  @override
  void initState() {
    super.initState();
    _startNfc();
  }

  void _startNfc() async {
    bool isAvailable = await NfcManager.instance.isAvailable();

    if (!isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ushbu qurilmada NFC mavjud emas")),
      );
      return;
    }

    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        final idBytes = tag.data["ndef"]?["identifier"] ?? tag.data['id'];
        final id = idBytes.toString();
        setState(() {
          tagId = id;
        });
        NfcManager.instance.stopSession();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("NFC o‘qish")),
      body: Center(
        child:
            tagId == null
                ? Text("Tegga yaqinlashtiring...")
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Teg aniqlandi!", style: TextStyle(fontSize: 20)),
                    SizedBox(height: 10),
                    Text("ID: $tagId", style: TextStyle(fontSize: 16)),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() => tagId = null);
                        _startNfc();
                      },
                      child: Text("Qayta o‘qish"),
                    ),
                  ],
                ),
      ),
    );
  }
}
