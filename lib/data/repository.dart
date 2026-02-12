import 'spendlog_storage.dart';

class Repository {

  static Map<String, dynamic>? allDataTransaction;


  static List<String> allMonth = [];
  static String? selectedMonth;
  static Map<String, double>? trasactionByDate;


  static Future<Map<String, dynamic>> loadMemoryData() async{
    if(allDataTransaction != null){
      return allDataTransaction!;
    }
    else{
      return await loadFromZero();
    }
  }

  static Future<Map<String, dynamic>> loadFromZero() async{
    allDataTransaction = await SpendlogStorage.loadTransaction();
    return allDataTransaction!;
  }

  

  
}