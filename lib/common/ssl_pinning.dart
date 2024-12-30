import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:crypto/crypto.dart';

Future<SecurityContext> get globalContext async {
  final sslCert = await rootBundle.load('certificates/certificates_fake.pem');
  SecurityContext securityContext = SecurityContext.defaultContext;
  securityContext.setTrustedCertificatesBytes(sslCert.buffer.asUint8List());
  return securityContext;
}

Future<IOClient> get getIOClient async {
  final sslCert = await rootBundle.load('certificates/certificates_fake.pem');
  HttpClient client = HttpClient(context: await globalContext);
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) {
    return cert.pem == String.fromCharCodes(sslCert.buffer.asUint8List());
  };
  return IOClient(client);
}

class Shared {
  static Future<http.Client> createLEClient() async {
    final sslCert = await rootBundle.load('certificates/certificates_fake.pem');
    final trustedFingerprint =
        sha256.convert(sslCert.buffer.asUint8List()).toString();

    HttpClient client = HttpClient();
    client.badCertificateCallback = (X509Certificate cert, String host, int port) {
      final serverFingerprint = sha256.convert(cert.der).toString();
      return serverFingerprint == trustedFingerprint;
    };
    return IOClient(client);
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
