import 'package:get_storage/get_storage.dart';

class LocalStorage{
  static final GetStorage _storageBox = GetStorage();

  static write(String key,dynamic value){
    _storageBox.write(key, value);
  }

  static T? read<T>(String key){
    try {
      return _storageBox.read(key) as T;
    } catch (e) {
      return null;
    }
  }

}