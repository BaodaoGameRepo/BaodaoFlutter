
import 'package:gobang/api/core/update_client.dart';

import 'api/core/app_client.dart';
import 'api/core/client_response.dart';
import 'api/interceptors/token_interceptor.dart';
import 'memorandum/login_request.dart';

final UserServices userServices = UserServices();

class UserServices {
  String user = "";

  Future<ClientResponse> smsLogin(
      String username, String password) async {
    user = username;
    return updateClient
        .request(LoginRequest.smsLogin(username, password));
  }
}
