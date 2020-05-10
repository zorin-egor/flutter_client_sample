import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


const DEFAULT_TABLET_SIZE = 600;

const DEFAULT_WIDGET_WIDTH = 400.0;

const DEFAULT_WIDGET_HEIGHT = 400.0;

const DEFAULT_WIDGET_MARGIN_LARGE = 20.0;

const DEFAULT_WIDGET_MARGIN_MEDIUM = 10.0;

const DEFAULT_WIDGET_MARGIN_SMALL = 5.0;

bool isTablet(BuildContext context) => MediaQuery.of(context).size.shortestSide >= 600 || kIsWeb;