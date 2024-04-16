import 'package:http/http.dart' as http;

String httpErrorHandler(http.Response response) {
  final statusCode = response.statusCode;
  final responsePhrase = response.reasonPhrase;

  final String errorMsg = 'Request failed\nStatus code: $statusCode\nError reason: $responsePhrase';
  return errorMsg;
}