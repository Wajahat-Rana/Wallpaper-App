import 'dart:convert';
import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:wallpaper_app/model/model.dart';
import 'package:http/http.dart' as http;

class Repository {
  final String apiKey =
      "";
  final String baseUrl = "https://api.pexels.com/v1/";

  Future<List<Images>> getImagesList({required int? pageNumber}) async {
    String url = "";

    if (pageNumber == null) {
      url = "${baseUrl}curated?per_page=80";
    } else {
      url = "${baseUrl}curated?per_page=80&page=$pageNumber";
    }

    List<Images> imagesList = [];
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': apiKey},
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final jsonData = json.decode(response.body);
        for (final json in jsonData["photos"] as Iterable) {
          final image = Images.fromJson(json);
          imagesList.add(image);
        }
      }
    } catch (_) {}
    return imagesList;
  }

  Future<Images> getImageById({required int id}) async {
    final url = "${baseUrl}photos/$id";

    Images image = Images.emptyConstructor();
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': apiKey},
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final jsonData = json.decode(response.body);
        image = Images.fromJson(jsonData);
      }
    } catch (_) {}
    return image;
  }

  Future<List<Images>> getImagesBySearchQuery({
    required String searchQuery,
    required int pageNumber, // Added pageNumber parameter
  }) async {
    final url =
        "${baseUrl}search?query=$searchQuery&per_page=80&page=$pageNumber"; // Use pageNumber

    List<Images> imagesList = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': apiKey},
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final jsonData = json.decode(response.body);
        for (final json in jsonData["photos"] as Iterable) {
          final image = Images.fromJson(json);
          imagesList.add(image);
        }
      }
    } catch (_) {}
    return imagesList;
  }

  Future<void> downloadImage({
    required String imageUrl,
    required int imageId,
    required BuildContext context,
  }) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final bytes = response.bodyBytes;
        final directory = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOAD,
        );

        final file = File("$directory/$imageId.png");
        file.writeAsBytes(bytes);

        MediaScanner.loadMedia(path: file.path);

        if (context.mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("File's been saved at ${file.path}"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (_) {}
  }
}
