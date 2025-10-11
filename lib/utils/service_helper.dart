import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

Exception errorHandler(Response response, String context) {
  final res = jsonDecode(response.body);
  final detail = res['detail'] ?? 'Unknown error';
  debugPrint('$context error ${response.statusCode}: ${detail.toString()}');
  return Exception(detail.toString());
}