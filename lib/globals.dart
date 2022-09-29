import 'package:crumbs/utilities/local_storage.dart';
import 'package:flutter/foundation.dart';

var localStorage = LocalStorage();
var routeFilesListener = ValueNotifier(localStorage.getAllRouteFiles());
