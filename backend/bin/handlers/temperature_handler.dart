import 'dart:convert';

import 'package:process_run/shell.dart';
import 'package:shelf/shelf.dart';

class TemperatureHandler {
  static Future<Response> staticHandler(request) async =>
      await _getTemperature();

  static Future<Response> dynamicHandler(request, String thermalZone) async {
    final zoneNum = int.parse(thermalZone);
    return await _getTemperature(thermalZone: zoneNum);
  }

  static Future<Response> _getTemperature({int thermalZone = 0}) async {
    final shell = Shell(throwOnError: false);
    final res = (await shell // @TODO execute command on host from docker
            .run('cat /sys/class/thermal/thermal_zone$thermalZone/temp'))
        .first;
    if (res.exitCode == 0) {
      return Response.ok(
        const JsonEncoder.withIndent(' ').convert({
          'thermalZone': thermalZone,
          'temperature': int.parse(res.outText),
        }),
        headers: _jsonHeaders(),
      );
    } else {
      return Response(
        422,
        body: const JsonEncoder.withIndent(' ').convert({
          'thermalZone': thermalZone,
          'error': {
            'exitCode': res.exitCode,
            'text': res.errText,
          }
        }),
        headers: _jsonHeaders(),
      );
    }
  }

  static Map<String, String> _jsonHeaders() => {
        'content-type': 'application/json',
        'Cache-Control': 'public, max-age=604800',
      };
}
