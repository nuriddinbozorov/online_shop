import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcListenerScreen extends StatefulWidget {
  @override
  _NfcListenerScreenState createState() => _NfcListenerScreenState();
}

class _NfcListenerScreenState extends State<NfcListenerScreen> {
  String status = 'Telefonni yaqinlashtiring...';

  @override
  void initState() {
    super.initState();
    startNfcSession();
  }

  void startNfcSession() {
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        final ndef = Ndef.from(tag);
        if (ndef == null || ndef.cachedMessage == null) {
          setState(() => status = 'NFC xabari topilmadi');
          return;
        }

        final recordText = ndef.cachedMessage!.records.first.payload;
        final payload = String.fromCharCodes(
          recordText.skip(3),
        ); // Skip encoding info
        final parts = payload.split(':');

        if (parts.length != 2) {
          setState(() => status = 'Noto‘g‘ri formatdagi ma\'lumot');
          return;
        }

        final code = parts[0];
        final amount = int.tryParse(parts[1]) ?? 0;

        setState(
          () => status = 'Kod: $code\nSummasi: $amount so‘m\nTekshirilmoqda...',
        );

        await processPayment(code, amount);
      },
    );
  }

  Future<void> processPayment(String code, int amount) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => status = 'Foydalanuvchi aniqlanmadi');
      return;
    }

    final paymentRef = FirebaseFirestore.instance
        .collection('pendingPayments')
        .doc(code);
    final paymentSnap = await paymentRef.get();

    if (!paymentSnap.exists || paymentSnap['status'] != 'pending') {
      setState(() => status = 'To‘lov allaqachon bajarilgan yoki topilmadi');
      return;
    }

    final cardRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('card')
        .doc('main');
    final cardSnap = await cardRef.get();

    if (!cardSnap.exists || cardSnap['balance'] < amount) {
      setState(() => status = 'Hisobda mablag‘ yetarli emas');
      return;
    }

    await FirebaseFirestore.instance.runTransaction((tx) async {
      tx.update(cardRef, {'balance': cardSnap['balance'] - amount});
      tx.update(paymentRef, {'status': 'completed'});
    });

    setState(() => status = 'To‘lov muvaffaqiyatli yakunlandi!');
    await NfcManager.instance.stopSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NFC orqali to‘lov'),
        backgroundColor: Colors.blue[800],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            status,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
