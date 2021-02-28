import 'package:flutter/material.dart';
import 'package:flutterclientsample/presentation/widgets/base/constants.dart';

class ProgressImage extends StatefulWidget {

  final String _url;

  ProgressImage(this._url, { Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProgressImageState();

}

class ProgressImageState extends State<ProgressImage> {

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(
          height: DEFAULT_WIDGET_HEIGHT
      ),
      child: Image.network(
          widget._url ?? "",
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
             return loadingProgress == null? child : Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null?
                loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes : null,
              ),
            );
          }
      )
    );
  }

}