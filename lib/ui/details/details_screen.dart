import 'dart:ui' show ImageFilter;

import 'package:flushbar/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutterclientsample/api/api.dart';
import 'package:flutterclientsample/data/details.dart';
import 'package:flutterclientsample/data/user.dart';
import 'package:flutterclientsample/ui/base/animation.dart';
import 'package:flutterclientsample/ui/base/constants.dart';
import 'package:flutterclientsample/ui/base/image_user.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatefulWidget {

  static final String ROUTE = "DetailsScreen";

  User _user;

  DetailsScreen(this._user, { Key key }) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final Api _api = Api();

  Details _details;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Details screen"),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,

        onRefresh: () => _api.getDetailsJson(widget._user.url).then((item) => setState(() {
          _details = item;
        })).catchError((error) {
          _showSnackBar(error.toString());
        }),

        child: Center (
          child: isTablet(context)? Card (
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 5,
            margin: EdgeInsets.all(DEFAULT_WIDGET_MARGIN_MEDIUM),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DEFAULT_WIDGET_MARGIN_MEDIUM),
            ),
            child: _getWidget(),
          ) : _getWidget()
        )
      )
    );
  }

  Widget _getWidget() {
    return ConstrainedBox(
        constraints:  isTablet(context)? BoxConstraints(
            minWidth: DEFAULT_WIDGET_WIDTH,
            maxWidth: DEFAULT_WIDGET_WIDTH
        ) : BoxConstraints(),
        child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[

                  // User avatar
                  ImageUser(
                      _details?.avatarUrl
                  ),

                  SizedBox(
                      height: DEFAULT_WIDGET_MARGIN_MEDIUM
                  ),

                  // User detail information
                  ..._details?.toPretty()?.entries?.map((entry) {

                    final value = entry.value.replaceAll("null", "");

                    bool isUrl = false;
                    try {
                      isUrl = Uri.parse(value).isAbsolute;
                    } catch(e) {
                      // Stub
                    }

                    return Padding(
                        padding: EdgeInsets.only(
                            left: DEFAULT_WIDGET_MARGIN_LARGE,
                            right: DEFAULT_WIDGET_MARGIN_LARGE,
                            top: DEFAULT_WIDGET_MARGIN_SMALL,
                            bottom: DEFAULT_WIDGET_MARGIN_SMALL
                        ),
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: '${entry.key}: ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                              TextSpan(
                                  text: '$value',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: isUrl? Colors.blue : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      decoration: isUrl? TextDecoration.underline : TextDecoration.none
                                  ),
                                  recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        if (isUrl) {
                                          Navigator.push(context, animateRoute(
                                              opaque: false,
                                              barrierDismissible: true,
                                              widget: _getDialogOpenLink(value)
                                          ));
                                        }
                                      }
                              ),
                            ],
                          ),
                        )
                    );
                  }) ?? List()

                ]
            )
        )
    );
  }

  Widget _getDialogOpenLink(String url) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DEFAULT_WIDGET_MARGIN_MEDIUM),
        ),
        title: new Text("Open link?"),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              Navigator.pop(context);
              await launch(url);
            },
            child: Text("Open")
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close")
          )
        ],
      )
    );
  }

  void _showSnackBar(String message) {
    Flushbar(
      message: message,
      maxWidth: isTablet(_scaffoldKey.currentState.context)? DEFAULT_WIDGET_WIDTH : double.infinity,
      isDismissible: true,
      duration: Duration(seconds: 2),
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: EdgeInsets.all(5.0),
      borderRadius: 5.0
    ).show(_scaffoldKey.currentState.context);
  }

}