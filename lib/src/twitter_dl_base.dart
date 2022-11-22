// SPDX-License-Identifier: MIT
// Copyright (c) 2022 Allan Pereira <https://github.com/allanpereira99>

import 'dart:async';
import 'repositories/http_interface.dart';

class Twitter {
  final IHttpService _service = HttpService();
  Future<Map<String, dynamic>> get(String url) async {
    final String api = "https://tweetpik.com/api/tweets/";

    try {
      final RegExp regExp = RegExp(r'(\d{1,})');
      final String? id = regExp.stringMatch(url);
      final Map<String, dynamic> json =
          await _service.get(Uri.parse("$api$id"));

      final String type = json['media'][0]['type'];
      final Map<String, dynamic> data = {
        "found": true,
        "tweet_user": {
          "name": json["name"],
          "username": json["username"],
          "text": json["text"],
        },
        "type": type,
        "download": []
      };

      if (type == 'photo') {
        data["download"].add(json["media"][0]["url"]);
        return data;
      } else {
        final Map<String, dynamic> json =
            await _service.get(Uri.parse("$api$id/video"));
        final List variants = json['variants'];

        if (type == 'video') {
          for (var i in variants) {
            data['download'].add({
              'witdh': i['url'].split('/')[7].split('x')[0],
              'height': i['url'].split('/')[7].split('x')[1],
              'dimension': i['url'].split('/')[7],
              'url': i['url']
            });
          }
        } else if (type == 'animated_gif') {
          data['download'].add({'url': variants[0]['url']});
        }
      }

      return data;
    } catch (e) {
      return <String, dynamic>{
        'found': false,
        'error': 404,
        'message': 'media not found',
      };
    }
  }
}
