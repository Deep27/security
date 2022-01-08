import 'dart:convert';

import 'package:http/http.dart';
import 'package:test/test.dart';

void runTests(
  void Function(String name, Future<void> Function(String host)) testServer,
) {
  testServer('home', (host) async {
    final response = await get(Uri.parse(host));
    expect(response.statusCode, 200);
    expect(response.body, contains('banana_2'));
    expect(response.headers, contains('last-modified'));
    expect(response.headers, contains('date'));
    expect(response.headers, containsPair('content-type', 'text/html'));
    expect(response.body, contains('banana_2'));
  });

  testServer('temp', (host) async {
    final response = await get(Uri.parse('$host/temp'));
    expect(response.statusCode, 200);

    final tempResponse = jsonDecode(response.body);
    print(tempResponse);
    expect(
      tempResponse['temperature'],
      isNotNull,
      reason: 'Did not receive "temperature" in response.',
    );
  });

  testServer('not found', (host) async {
    var response = await get(Uri.parse('$host/banana'));
    expect(response.statusCode, 404);
    expect(response.body, 'Route not found');
  });
}
