import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("GET / returns 200 Hello World!", () async {
    expectResponse(await harness.agent.get("/"), 200, body: "Hello World!");
  });
}
