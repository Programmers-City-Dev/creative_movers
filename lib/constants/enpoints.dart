import 'package:creative_movers/helpers/api_helper.dart';

class Endpoints {
  static const login_endpoint = '${ApiConstants.BASE_URL}api/login';

  static const register_endpoint = '${ApiConstants.BASE_URL}api/register';

  static const biodata_endpoint = '${ApiConstants.BASE_URL}api/user/biodata';

  static const acount_type_endpoint = '${ApiConstants.BASE_URL}api/user/account-type';
  static const add_connection_endpoint = '${ApiConstants.BASE_URL}api/user/choose-connection';
}
