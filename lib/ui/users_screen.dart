import 'dart:core';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterclientsample/api/api.dart';
import 'package:flutterclientsample/data/user.dart';
import 'package:flutterclientsample/ui/users_item.dart';

class UsersScreen extends StatefulWidget {

  @override
  UsersScreenState createState() {
    return UsersScreenState();
  }
}

class UsersScreenState extends State<UsersScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  ScrollController _scrollController;

  final Api _api = Api();
  List<User> _users;
  int _lastVisibleItem = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.shortestSide >= 600 || kIsWeb;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text("Toolbar title"),
      ),
      body: Center(
          child: RefreshIndicator(
            key: _refreshIndicatorKey,

            onRefresh: () => _api.getUserDefault().then((items) => setState(() {
              _users = items;
            })).catchError((error) {
              _showSnackBar(error.toString());
            }),

            child: ConstrainedBox(
              constraints: isWideScreen? BoxConstraints(minWidth: 400, maxWidth: 400) : BoxConstraints(),
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                itemBuilder: (context, index) {
                  debugPrint("User screen widget item index: $index");

                  // Get already downloaded users
                  if (index < (_users?.length ?? -1)) {
                    final item = _users[index];
                    if (item != null) {
                      return Dismissible(
                          key: UniqueKey(),
                          background: Container(color: Colors.red),
                          onDismissed: (direction) => _removeItem(index),
                          child: GestureDetector(
                              child: UserItem(item, index, (lastVisible) {
                                debugPrint("User screen first visible: $lastVisible");
                                _lastVisibleItem = lastVisible;
                              }),
                              onLongPress: () => setState(() => _removeItem(index))
                          )
                      );
                    }
                  }

                  // Nothing add to list
                  return index == (_users?.length ?? -1) && (_users?.isNotEmpty ?? false)? Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(10.0),
                    child: CircularProgressIndicator(),
                  ) : null;
                }
              )
            )

          )
        )
    );
  }

  void _removeItem(int index) {
    final item = _users.removeAt(index);
    _showSnackBar(
        "Removed view with index: ${index}",
        actionSnackBar: SnackBarAction(
            label: "UNDO",
            onPressed: () => setState(() => _users.insert(index, item))
        )
    );
  }

  void _showSnackBar(String message, { SnackBarAction actionSnackBar }) {
    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
            content: Text(message),
            action: actionSnackBar
        )
    );
  }

  void _scrollListener({ int thresholds = 5 }) {
//    debugPrint("User screen _scrollListener(${_scrollController.position.maxScrollExtent}, "
//        "${_scrollController.position.pixels}, "
//        "${_scrollController.position.minScrollExtent}, "
//        "${_scrollController.position.atEdge})");

    final isRevers = _scrollController.position.userScrollDirection == ScrollDirection.reverse;

    if (isRevers && _lastVisibleItem + thresholds > _users.length) {
      debugPrint("User screen _lastVisibleItem: $_lastVisibleItem");
      _api.getUsersJson().then((items) => setState(() {
          _users.addAll(items);
        }
      )).catchError((error) {
        _showSnackBar(error.toString());
      });
    }
  }

}