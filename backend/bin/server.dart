import 'dart:convert';
import 'dart:io';

import 'package:process_run/shell.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:shelf_static/shelf_static.dart' as shelf_static;

import 'handlers/temperature_handler.dart';

Future main() async {
  final cascade = Cascade().add(_staticHandler).add(_router);

  final server = await shelf_io.serve(
    logRequests().addHandler(cascade.handler),
    InternetAddress.anyIPv4,
    4044,
  );

  print('Server started at http://${server.address.host}:${server.port}');
}

final _staticHandler =
    shelf_static.createStaticHandler('public', defaultDocument: 'index.html');

final _router = shelf_router.Router()
  ..get('/hi', _greetHandler)
  ..get('/temp', TemperatureHandler.staticHandler)
  ..get('/temp/<a|[0-9]+>', TemperatureHandler.dynamicHandler);

Response _greetHandler(Request request) => Response.ok('Hi!');
