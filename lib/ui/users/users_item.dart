import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterclientsample/data/user.dart';
import 'package:flutterclientsample/ui/base/constants.dart';
import 'package:flutterclientsample/ui/base/image_user.dart';
import 'package:visibility_detector/visibility_detector.dart';

class UserItem extends StatefulWidget {

  static const double ITEM_IMAGE_HEIGHT = 400.0;

  final Function(int lastVisible) _itemVisibility;
  final GestureTapCallback _itemTap;
  final GestureLongPressCallback _itemLongPress;
  final User _item;
  final int _index;

  UserItem({
    Key key,
    User item,
    int index,
    Function(int lastVisiblity) itemVisibility,
    GestureTapCallback itemTap,
    GestureLongPressCallback itemLongPress
  }) : _item = item,
       _index = index,
       _itemVisibility = itemVisibility,
       _itemTap = itemTap,
       _itemLongPress = itemLongPress,
       super(key: key);

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
          widget._itemVisibility(widget._index);
        }
      },

      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        margin: EdgeInsets.all(DEFAULT_WIDGET_MARGIN_MEDIUM),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DEFAULT_WIDGET_MARGIN_MEDIUM),
        ),

        child: Stack(
          children: <Widget>[
            _getMainWidget(context),
            Positioned.fill(
              child: _getRippleWidget()
            )
          ]
        )
      )
    );
  }

  Widget _getMainWidget(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          // User avatar
          ImageUser(
              widget._item.avatarUrl
          ),

          // User id - login
          Container(
            margin: EdgeInsets.only(
                top: DEFAULT_WIDGET_MARGIN_MEDIUM,
                bottom: DEFAULT_WIDGET_MARGIN_MEDIUM
            ),

            child: Row(
                mainAxisSize: MainAxisSize.max,
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
    );
  }

  Widget _getRippleWidget() {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        splashColor: Color.fromARGB(40, 0, 0, 255),
        highlightColor: Colors.transparent,
        onTap: () => widget._itemTap(),
        onLongPress: () => widget._itemLongPress()
      )
    );
  }

}