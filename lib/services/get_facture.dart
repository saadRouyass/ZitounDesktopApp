import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:zitoun/pages/notifs/presets.dart';
import 'package:zitoun/pages/notifs/system_notif.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

final serverUrl = dotenv.env['URL']??'http://localhost:3000';

Future<void> downloadPdf(
  BuildContext context,
  String date,
  String clientName,
  String clientAddress,
  List<Map<String, dynamic>> items,
  double subtotal,
  String taxTotal,
  double totalTTC,
) async {
  try {
    SysNotif.showWidget(
        context, 'Votre Facture est en cours de traitement', Colors.orange, Icons.timer);

    // ----------------- URL -----------------
    final url = Uri.parse('$serverUrl/get-pdf');

    // ----------------- Body -----------------
    final body = jsonEncode({
      "documentNumber": 1,
      "date": date,
      "clientName": clientName,
      "clientAddress": clientAddress,
      "items": items,
      "subtotal": subtotal,
      "taxTotal": double.parse(taxTotal),
      "totalTTC": totalTTC,
    });

    // ----------------- POST request -----------------
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      // ----------------- Save PDF -----------------
      final bytes = response.bodyBytes;
      final dir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final filePath = '${dir.path}/facture_$timestamp.pdf';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      // ----------------- Open PDF in browser -----------------
      final pdfUri = Uri.file(filePath);
      if (!await launchUrl(pdfUri)) {
        // fallback if browser fails, open default viewer
        if (Platform.isWindows) {
          await Process.run('explorer.exe', [filePath]);
        } else if (Platform.isMacOS) {
          await Process.run('open', [filePath]);
        } else if (Platform.isLinux) {
          await Process.run('xdg-open', [filePath]);
        }
      }

      if (kDebugMode) {
        SysNotif.showWidget(
            context, 'Facture téléchargée avec succès', presets['success']!, Icons.check_circle);
      }
    } else {
      if (kDebugMode) {
        print('Failed to download PDF. Status: ${response.statusCode}');
        SysNotif.showWidget(
            context, 'Erreur, veuillez ressayer', presets['failed']!, Icons.error_outline);
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error downloading PDF: $e');
      SysNotif.showWidget(
          context, 'Erreur, veuillez ressayer', presets['failed']!, Icons.error_outline);
    }
  }
}
