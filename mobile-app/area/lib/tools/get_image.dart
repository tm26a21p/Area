import 'package:flutter/material.dart';

Image getImage(String url, BoxFit fit) {
  return Image.network(
    url,
    fit: fit,
    loadingBuilder:
        (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
      if (loadingProgress == null) return child;
      return Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null,
        ),
      );
    },
    errorBuilder: (context, error, stackTrace) {
      return Image.asset(
        "assets/img/error_image_not_found.png",
      );
    },
  );
}
