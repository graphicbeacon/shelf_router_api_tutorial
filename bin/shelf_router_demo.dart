import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

import 'package:shelf_router_demo/film_api.dart';

void main(List<String> arguments) async {
  final app = Router();

  app.mount('/films/', FilmApi().router);

  app.get('/<name|.*>', (Request request, String name) {
    final param = name.isNotEmpty ? name : 'World';
    return Response.ok('Hello $param!');
  });

  await io.serve(app.handler, 'localhost', 8083);
}
