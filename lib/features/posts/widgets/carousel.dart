import 'package:adhikar/common/widgets/fullscreen_image_viewer.dart';
import 'package:adhikar/theme/image_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselImage extends StatefulWidget {
  final List<String> imageLinks;
  const CarouselImage({super.key, required this.imageLinks});

  @override
  State<CarouselImage> createState() => _CarouselImageState();
}

class _CarouselImageState extends State<CarouselImage> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            SizedBox(height: 5),
            CarouselSlider(
              items: widget.imageLinks.map((link) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        spreadRadius: 2,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FullscreenImageViewer(
                      imageUrl: link,
                      child: CachedNetworkImage(
                        imageUrl: link,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Image.asset(
                          ImageTheme.defaultAdhikarLogo,
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          ImageTheme.defaultAdhikarLogo,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                viewportFraction: 0.8,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
            ),
            SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.imageLinks.asMap().entries.map((e) {
                return Container(
                  width: 4,
                  height: 4,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(
                      _current == e.key ? 0.9 : 0.4,
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 10),
          ],
        ),
      ],
    );
  }
}
