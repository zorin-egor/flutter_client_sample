import 'dart:ui' show ImageFilter;

import 'package:flushbar/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterclientsample/data/api/api_github.dart';
import 'package:flutterclientsample/data/api/models/details.dart';
import 'package:flutterclientsample/data/api/models/user.dart';
import 'package:flutterclientsample/presentation/widgets/base/animation_route.dart';
import 'package:flutterclientsample/presentation/widgets/base/constants.dart';
import 'package:flutterclientsample/presentation/widgets/base/progress_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';

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

  // final Dio _dio = Dio();
  final ApiGithub _api = ApiGithub(Dio());

  Details _details;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
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

        child: Scaffold(
          key: _scaffoldKey,
          extendBodyBehindAppBar: isTablet(context)? false : true,
          resizeToAvoidBottomInset: isAndroid(context)? true : false,

          appBar: AppBar(
            backgroundColor: isTablet(context)? Colors.blueAccent : Colors.transparent,
            elevation: 0.0,
          ),

          body: RefreshIndicator(
              key: _refreshIndicatorKey,

              onRefresh: () => _api.getDetails(widget._user.url).then((item) => setState(() {
                _details = item;
              })).catchError((error) {
                _showSnackBar(error.toString());
              }),

              child: isTablet(context)?
                Center(
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 5,
                    margin: EdgeInsets.all(DEFAULT_WIDGET_MARGIN_MEDIUM),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(DEFAULT_WIDGET_MARGIN_MEDIUM),
                    ),
                    child: _getMainWidget(context),
                  ),
                ) : _getMainWidget(context)
          ),
        )
      )
    );
  }

  Widget _getMainWidget(BuildContext context) {
    return ConstrainedBox(
        constraints:  isTablet(context)? BoxConstraints(
            minWidth: DEFAULT_WIDGET_WIDTH,
            maxWidth: DEFAULT_WIDGET_WIDTH
        ) : BoxConstraints(),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(
              bottom: isAndroid(context)? MediaQuery.of(context).viewInsets.bottom : 0.0
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                // User avatar
                ProgressImage(_details?.avatarUrl),

                SizedBox(
                    height: DEFAULT_WIDGET_MARGIN_MEDIUM
                ),

                // User detail information
                ..._details?.toPretty()?.entries?.map((entry) {

                  final value = entry.value/*.replaceAll("null", "")*/;

                  bool isUrl = false;
                  try {
                    isUrl = Uri.parse(value).isAbsolute;
                  } catch(e) {
                    // Stub
                  }

                  return _getDetailsWidget(context, entry.key, value, isUrl);
                }) ?? List()

              ]
          )
        )
    );
  }

  Widget _getDetailsWidget(BuildContext context, dynamic title, dynamic value, bool isUrl) {
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
                  text: '$title: ',
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
                            widget: _getDialogOpenLink(context, value)
                        ));
                      }
                    }
              ),
            ],
          ),
        )
    );
  }

  Widget _getDialogOpenLink(BuildContext context, String url) {
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