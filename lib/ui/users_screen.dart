import 'package:clientfluttersample/api/api.dart';
import 'package:clientfluttersample/data/user.dart';
import 'package:clientfluttersample/ui/users_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class UsersScreen extends StatefulWidget {

  @override
  UsersScreenState createState() {
    return UsersScreenState();
  }
}

class UsersScreenState extends State<UsersScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final Api _api = Api();
  List<User> _users = List();
  ScrollController _scrollController;

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
          child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            itemBuilder: (context, index) {

              // Get already downloaded users
              if (index < _users.length) {
                final item = _users[index];
                if (item != null) {
                  return Dismissible(
                      key: UniqueKey(),
                      background: Container(color: Colors.red),
                      onDismissed: (direction) => _removeItem(index),
                      child: GestureDetector(
                          child: UserItem(item),
                          onLongPress: () => setState(() => _removeItem(index))
                      )
                  );
                }
              }

              // Nothing add to list
              return null;
            }
          )
        ),
      )
    );
  }

  void _removeItem(int index) {
    final item = _users.removeAt(index);
    _showSnackBar(
        "Removed view with index: ${index + 1}",
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
    final itemHeight = _scrollController.position.maxScrollExtent / _users.length;
    final int position = _scrollController.position.pixels ~/ itemHeight;
    final isRevers = _scrollController.position.userScrollDirection == ScrollDirection.reverse;

    print("_scrollListener(${_scrollController.position.maxScrollExtent}, "
        "${_scrollController.position.pixels}, "
        "${_scrollController.position.minScrollExtent})");

    if (isRevers && position + thresholds > _users.length) {
//      _api.getUsersJson().then((items) => setState(() {
//          _users.addAll(items);
//        }
//      ));
    }
  }

}