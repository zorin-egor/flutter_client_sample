import 'package:clientfluttersample/data/user.dart';
import 'package:flutter/material.dart';

class UserItem extends StatefulWidget {

  final User _item;

  UserItem(this._item, { Key key }) : super(key: key);

  @override
  _UserItemState createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Image.network(
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
          ),
          Row(children: <Widget>[
            Text(
                "${widget._item.id} - "
            ),
            Text(
                widget._item.login
            )
          ])
        ]
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: EdgeInsets.all(10),
    );
  }

}