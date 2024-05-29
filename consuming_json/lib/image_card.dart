import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ImageCard {
  final int id;
  final String title;
  final String imageUrl;

  const ImageCard(
      {required this.id, required this.title, required this.imageUrl});

  factory ImageCard.fromJson(Map<String, dynamic> json) {
    return ImageCard(
        id: json['id'], title: json['title'], imageUrl: json['url']);
  }
}

class ApiService {
  static Future<List<ImageCard>> fetchData() async {
    final Uri serviceUri =
        Uri.parse('https://jsonplaceholder.typicode.com/photos');
    final response = await http.get(serviceUri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((item) => ImageCard.fromJson(item)).toList();
    } else {
      throw NetworkImageLoadException(
          statusCode: response.statusCode, uri: serviceUri);
    }
  }
}
