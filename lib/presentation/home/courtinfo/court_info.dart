import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class CourtInfoScreen extends StatefulWidget {
  final List<String> imageUrls;
  

  CourtInfoScreen(
      {required this.imageUrls});

  @override
  _CourtInfoScreenState createState() => _CourtInfoScreenState();
}

class _CourtInfoScreenState extends State<CourtInfoScreen> {
  int _currentPage = 0;
  bool _isCarouselPaused = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Demo'),
        ),
        body: ImageSlideshow(
          height: 450,
          indicatorColor: Colors.blue,
          onPageChanged: (value) {
            debugPrint('Page changed: $value');
          },
          autoPlayInterval: 3000,
          isLoop: true,
          children: widget.imageUrls.map((imageUrl) {
            return CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
            );
          }).toList(),
        ),
      ),
    );
  }
}
    
    
    