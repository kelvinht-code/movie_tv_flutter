import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

Future<SecurityContext> get globalContext async {
  final sslCert = await rootBundle.load('certificates/certificates.pem');
  SecurityContext securityContext = SecurityContext.defaultContext;
  securityContext.setTrustedCertificatesBytes(sslCert.buffer.asUint8List());
  print('Loaded certificate: ${sslCert.buffer.asUint8List().length} bytes');
  return securityContext;
}

Future<IOClient> get getIOClient async {
  final sslCert = await rootBundle.load('certificates/certificates.pem');
  HttpClient client = HttpClient(context: await globalContext);
  client.badCertificateCallback = (X509Certificate cert, String host, int port) {
    return cert.pem == String.fromCharCodes(sslCert.buffer.asUint8List());
  };
  return IOClient(client);
}
class Shared {
  static Future<http.Client> createLEClient() async {
    return await getIOClient;
  }
}

class HttpSSLPinning {
  static Future<http.Client> get _instance async =>
      _clientInstance ??= await Shared.createLEClient();
  static http.Client? _clientInstance;
  static http.Client get client => _clientInstance ?? http.Client();
  static Future<void> init() async {
    _clientInstance = await _instance;
  }
}