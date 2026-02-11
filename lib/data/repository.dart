import 'spendlog_storage.dart';

class Repository {
  static Future<Map<String, dynamic>> memoryData() async{
    Future<Map<String, dynamic>> allDataTransaction = SpendlogStorage.loadTransaction();

    return allDataTransaction;
  }
}