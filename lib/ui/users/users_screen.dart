import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
      key: _scaffoldKey,
      body: NestedScrollView(
        controller: _appBarScrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text('Floating app bar'),
              // Allows the user to reveal the app bar if they begin scrolling back
              // up the list of items.
              floating: true,
              // Display a placeholder widget to visualize the shrinking size.
              flexibleSpace: Placeholder(),
              // Make the initial height of the SliverAppBar larger than normal.
              expandedHeight: 150,
            )
          ];
        },

        body: RefreshIndicator(
          key: _refreshIndicatorKey,

          onRefresh: () => _api.getUserDefault().then((items) => setState(() {
            _users = items;
          })).catchError((error) {
            _showSnackBar(error.toString());
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
                          SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (context, index) => _itemAction(context, index)
                              )
                          )
                        ]
                    )
                )
            ),
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
    _showSnackBar(
        "Removed view with index: $index",
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
        _showSnackBar(error.toString());
      });

      return true;
    }

    return false;
  }

}