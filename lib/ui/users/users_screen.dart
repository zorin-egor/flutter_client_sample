import 'dart:core';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterclientsample/api/api.dart';
import 'package:flutterclientsample/data/user.dart';
import 'package:flutterclientsample/ui/base/animation.dart';
import 'package:flutterclientsample/ui/base/constants.dart';
import 'package:flutterclientsample/ui/details/details_screen.dart';
import 'package:flutterclientsample/ui/users/users_item.dart';


class UsersScreen extends StatefulWidget {

  static final String ROUTE = "UsersScreen";

  @override
  _UsersScreenState createState() => _UsersScreenState();

}

class _UsersScreenState extends State<UsersScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  ScrollController _appBarScrollController;

  final Api _api = Api();
  List<User> _users;
  int _lastVisibleItem = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    _appBarScrollController = ScrollController()..addListener(_appBarScrollListener);
  }

  @override
  void dispose() {
    _appBarScrollController.removeListener(_appBarScrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: isAndroid(context)? false : true,
      key: _scaffoldKey,
      body: SafeArea(
        top: false,
        child: NestedScrollView(
            controller: _appBarScrollController,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => <Widget>[
              SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    snap: true,
                    floating: true,
                    primary: true,
                    flexibleSpace: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                          top: DEFAULT_WIDGET_MARGIN_MEDIUM + MediaQuery.of(context).viewInsets.top,
                          left: DEFAULT_WIDGET_MARGIN_MEDIUM,
                          right: DEFAULT_WIDGET_MARGIN_MEDIUM,
                          bottom: DEFAULT_WIDGET_MARGIN_MEDIUM,
                        ),
                        child: Image.asset("assets/github_appbar.png")
                    ),
                    expandedHeight: 150,
                  )
              )
            ],

            body: RefreshIndicator(
                key: _refreshIndicatorKey,

                onRefresh: () => _api.getUserDefault().then((items) => setState(() {
                  _users = items;
                })).catchError((error) {
                  _showFlushbar(error.toString());

//                  setState(() {
//                    _users = [
//                      User(id: "1", nodeId: "1", login: "1", url: "1", avatarUrl: "1"),
//                      User(id: "2", nodeId: "2", login: "2", url: "2", avatarUrl: "2"),
//                      User(id: "3", nodeId: "3", login: "3", url: "3", avatarUrl: "3"),
//                      User(id: "4", nodeId: "4", login: "4", url: "4", avatarUrl: "4"),
//                      User(id: "5", nodeId: "5", login: "5", url: "5", avatarUrl: "5")
//                    ];
//                  });
                }),

                child: NotificationListener<ScrollUpdateNotification>(
                  onNotification: (notification) => _listScrollListener(notification: notification),
                  child: Center(
                      child: ConstrainedBox(
                          constraints: isTablet(context)? BoxConstraints(
                              minWidth: DEFAULT_WIDGET_WIDTH,
                              maxWidth: DEFAULT_WIDGET_WIDTH
                          ) : BoxConstraints(),
                          child: CustomScrollView(
                              slivers: [
                                SliverPadding(
                                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                  sliver: SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                          (context, index) => _itemAction(context, index)
                                      )
                                  )
                                )
                              ]
                          )
                      )
                  ),
                )

            )
        )
      )
    );
  }

  Widget _itemAction(BuildContext context, int index) {
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
                onLongPress: () => setState(() => _removeItem(index)),
                onTap: () => Navigator.push(context, animateRoute(widget: DetailsScreen(item)))
            )
        );
      }
    }

    // Nothing add to list
    return index == (_users?.length ?? -1) && (_users?.isNotEmpty ?? false)? Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      margin: EdgeInsets.all(DEFAULT_WIDGET_MARGIN_MEDIUM),
      child: CircularProgressIndicator(),
    ) : null;
  }

  void _removeItem(int index) {
    final item = _users.removeAt(index);
    _showFlushbar(
        "Removed view with index: $index",
        mainButtonFunc: () => setState(() => _users.insert(index, item)),
        mainButtonText: "UNDO"
    );
  }

  void _showFlushbar(String message, { Function mainButtonFunc, String mainButtonText }) {
    Flushbar(
      message: message,
      maxWidth: isTablet(_scaffoldKey.currentState.context)? DEFAULT_WIDGET_WIDTH : double.infinity,
      isDismissible: true,
      duration: Duration(seconds: 2),
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: EdgeInsets.all(5.0),
      borderRadius: 5.0,
      mainButton: FlatButton(
        onPressed: () {
          mainButtonFunc();
        },
        child: Text(
          mainButtonText,
          style: TextStyle(color: Colors.blueAccent),
        ),
      )
    ).show(_scaffoldKey.currentState.context);
  }

  void _appBarScrollListener() {
    // Stub
  }

  bool _listScrollListener({ @required ScrollUpdateNotification notification, int thresholds = 5 }) {
    final isDown = notification.scrollDelta > 0;
    final isEdge = _lastVisibleItem + thresholds > _users.length;

    if (isDown && isEdge) {
      debugPrint("User screen _lastVisibleItem: $_lastVisibleItem");
      _api.getUsersJson().then((items) => setState(() {
          _users.addAll(items);
        }
      )).catchError((error) {
        _showFlushbar(error.toString());
      });
      return true;
    }

    return false;
  }

}