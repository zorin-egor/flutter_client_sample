import 'package:flutter/material.dart';
import 'package:flutterclientsample/ui/base/constants.dart';

class ImageUser extends StatefulWidget {

  String _url;

  ImageUser(this._url, { Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ImageUserState();

}

class ImageUserState extends State<ImageUser> {

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
            if (loadingProgress == null) {
              return child;
            }

            return Center(
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