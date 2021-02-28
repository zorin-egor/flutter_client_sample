import 'dart:core';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterclientsample/data/api/api_github.dart';
import 'package:flutterclientsample/data/api/models/user.dart';
import 'package:flutterclientsample/presentation/widgets/base/animation_route.dart';
import 'package:flutterclientsample/presentation/widgets/base/constants.dart';
import 'package:flutterclientsample/presentation/screens/details/details_screen.dart';
import 'package:flutterclientsample/presentation/screens/users/users_item.dart';
import 'package:dio/dio.dart';

class UsersScreen extends StatefulWidget {

  static final String ROUTE = "UsersScreen";

  @override
  _UsersScreenState createState() => _UsersScreenState();

}

class _UsersScreenState extends State<UsersScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  ScrollController _appBarScrollController;

  final ApiGithub _api = ApiGithub(Dio());
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark
      ),

      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: isAndroid(context)? false : true,

          body: NestedScrollView(
            controller: _appBarScrollController,

            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => <Widget>[
              SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    snap: true,
                    floating: true,
                    flexibleSpace: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                          top: DEFAULT_WIDGET_MARGIN_MEDIUM + MediaQuery.of(context).viewInsets.top,
                          left: DEFAULT_WIDGET_MARGIN_MEDIUM,
                          right: DEFAULT_WIDGET_MARGIN_MEDIUM,
                          bottom: DEFAULT_WIDGET_MARGIN_MEDIUM
                        ),
                        child: Image.asset("assets/github_appbar.png")
                    ),
                    expandedHeight: 150,
                  )
              )
            ],

            body: RefreshIndicator(
                key: _refreshIndicatorKey,

                onRefresh: () => _api.getUsers(0).then((items) => setState(() {
                  _users = items;
                })).catchError((error) {
                  _showFlushbar(error.toString());

//                  setState(() {
//                    _users = [
//                      User(id: "1", nodeId: "1", login: "1", url: "1", avatarUrl: "1"),
//                      User(id: "2", nodeId: "1", login: "1", url: "1", avatarUrl: "1"),
//                      User(id: "1", nodeId: "1", login: "1", url: "1", avatarUrl: "1"),
//                      User(id: "1", nodeId: "1", login: "1", url: "1", avatarUrl: "1")
//                    ];
//                  });
                }),

                child: _getListWidget(context)
            )

          )
        )
      )
    );
  }

  Widget _getListWidget(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) => _listScrollListener(notification: notification),

      child: Center(
          child: ConstrainedBox(
              constraints: isTablet(context)? BoxConstraints(
                  minWidth: DEFAULT_WIDGET_WIDTH,
                  maxWidth: DEFAULT_WIDGET_WIDTH
              ) : BoxConstraints(),

              child: ListView.builder(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) => _getItemWidget(context, index)
              )

          )
      ),
    );
  }

  Widget _getItemWidget(BuildContext context, int index) {
    debugPrint("User screen widget item index: $index");

    // Get already downloaded users
    if (index < (_users?.length ?? -1)) {
      final item = _users[index];
      if (item != null) {
        return Dismissible(
            key: UniqueKey(),
            background: Container(color: Colors.red),
            onDismissed: (direction) => _removeItem(index),
              child: UserItem(
                  item: item,
                  index: index,
                  itemTap: () => Navigator.push(context, animateRoute(widget: DetailsScreen(item))),
                  itemLongPress: () => setState(() => _removeItem(index)),
                  itemVisibility: (lastVisible) {
                    debugPrint("User screen first visible: $lastVisible");
                    _lastVisibleItem = lastVisible;
                  }
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
          mainButtonText ?? "",
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
      _api.getUsers(0).then((items) => setState(() {
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