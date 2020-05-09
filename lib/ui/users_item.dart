import 'package:flutter/material.dart';
import 'package:flutterclientsample/data/user.dart';
import 'package:visibility_detector/visibility_detector.dart';

class UserItem extends StatefulWidget {

  static const double ITEM_IMAGE_HEIGHT = 400.0;

  final Function(int lastVisible) _visibility;
  final User _item;
  final int _index;

  UserItem(this._item, this._index, this._visibility, { Key key }) : super(key: key);

  @override
  _UserItemState createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('${widget._item.id}:${widget._item.login}'),
      onVisibilityChanged: (info) {
        debugPrint("User item widget visibility: ${info.key} - ${info.visibleFraction}%");
        if (info.visibleFraction >= 0.95) {
          widget._visibility(widget._index);
        }
      },
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: UserItem.ITEM_IMAGE_HEIGHT,
                  maxHeight: UserItem.ITEM_IMAGE_HEIGHT
              ),
              child: Image.network(
                  widget._item.avatarUrl,
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
            ),

            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  Text(
                      "${widget._item.id} - ",
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 22,
                          fontWeight: FontWeight.bold
                      )
                  ),

                  Text(
                      widget._item.login,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      )
                  )
                ]
              ),
            )

          ]
        )
      )
    );
  }

}