// SPDX-License-Identifier: MIT
// Copyright (c) 2022 Allan Pereira <https://github.com/allanpereira99>

import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class IHttpService {
  Future<Map<String, dynamic>> get(Uri url);
}

class HttpService implements IHttpService {
  final http.Client httpCliente = http.Client();
  @override
  Future<Map<String, dynamic>> get(Uri url) async {
    final response = await httpCliente.get(url);
    final json = jsonDecode(response.body);
    return json;
  }
}
