import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/repo/repository.dart';

class PreviewPage extends StatefulWidget {
  String imageUrl;
  int imageId;
  PreviewPage({super.key, required this.imageId, required this.imageUrl});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  Repository repo = Repository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: widget.imageUrl,
        height: double.infinity,
        width: double.infinity,
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: const Color.fromARGB(255, 194, 193, 193),
        foregroundColor: Colors.white,
        onPressed: () {
          repo.downloadImage(
            imageUrl: widget.imageUrl,
            imageId: widget.imageId,
            context: context,
          );
        },
        child: Icon(Icons.download),
      ),
    );
  }
}
