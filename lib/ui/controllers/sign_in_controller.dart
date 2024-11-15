import 'package:get/get.dart';
import 'package:project01/data/models/login_model.dart';
import 'package:project01/data/services/network_caller.dart';
import 'package:project01/data/utils/urls.dart';
import 'package:project01/ui/controllers/auth_controller.dart';

import '../../data/models/network_response.dart';

class SignInController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> signIn(String email, String password) async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    Map<String, dynamic> requestBody = {
      'email': email,
      'password': password,
    };

    final NetworkResponse response =
        await NetworkCaller.postRequest(url: Urls.login, body: requestBody);

    if (response.isSuccess) {
      LoginModel loginModel = LoginModel.fromJson(response.responseData);
      await AuthController.saveAccessToken(loginModel.token!);
      await AuthController.saveUserData(loginModel.data!);
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}
