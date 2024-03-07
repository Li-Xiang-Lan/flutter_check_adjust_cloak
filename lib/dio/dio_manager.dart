import 'package:dio/dio.dart';

class DioManager{
  factory DioManager() => _getInstance();
  static DioManager get instance => _getInstance();
  static DioManager? _instance;
  static DioManager _getInstance() {
    _instance ??= DioManager._internal();
    return _instance!;
  }
  DioManager._internal(){
    if (_dio == null) {
      BaseOptions options = BaseOptions(
        responseType: ResponseType.json,
        receiveDataWhenStatusError: false,
        connectTimeout: const Duration(milliseconds: 30000),
        receiveTimeout: const Duration(milliseconds: 30000),
      );
      _dio = Dio(options);
    }
  }

  Dio? _dio;

  Future<String> requestGet({required String url}) async{
    try{
      var response = await _dio?.request<String>(
          url,
          options: Options(method: "get")
      );
      if(response?.statusCode==200){
        return response?.data?.toString()??"";
      }else{
        return "";
      }
    }catch(e){
      return "";
    }
  }
}