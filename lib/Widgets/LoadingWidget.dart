import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
class ApmLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center (
      child: Image(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.7,
        image: CachedNetworkImageProvider(
            "https://media3.giphy.com/media/26gJAzOW1B7EdvWRG/source.gif"),
      ));

  }
}
