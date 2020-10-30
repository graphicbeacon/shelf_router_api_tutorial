import 'dart:io';
import 'dart:convert';

import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

void main(List<String> arguments) async {
  final List data = json.decode(File('films.json').readAsStringSync());
  final app = Router();

  app.get('/', (Request request) {
    return Response.ok(json.encode(data),
        headers: {'Content-Type': 'application/json'});
  });

  app.get('/<id|[0-9]+>', (Request request, String id) {
    final parsedId = int.tryParse(id);
    final film =
        data.firstWhere((film) => film['id'] == parsedId, orElse: () => null);

    if (film != null) {
      return Response.ok(json.encode(film),
          headers: {'Content-Type': 'application/json'});
    }

    return Response.notFound('Film not found.');
  });

  app.post('/', (Request request) async {
    final payload = await request.readAsString();
    data.add(json.decode(payload));
    return Response.ok(payload, headers: {'Content-Type': 'application/json'});
  });

  app.delete('/<id>', (Request request, String id) {
    final parsedId = int.tryParse(id);
    data.removeWhere((film) => film['id'] == parsedId);
    return Response.ok('Deleted.');
  });

  app.get('/<name|.*>', (Request request, String name) {
    final param = name.isNotEmpty ? name : 'World';
    return Response.ok('Hello $param!');
  });

  await io.serve(app.handler, 'localhost', 8083);
}
