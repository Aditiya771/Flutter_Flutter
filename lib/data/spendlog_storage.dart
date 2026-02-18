import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'repository.dart';

class Transaction {
  final int amount;
  final String category;
  final String note;
  final DateTime timeDate;

  Transaction({
    required this.amount,
    required this.category,
    required this.note,
    required this.timeDate
  });
}

class SpendlogStorage {
  //AMBIL DIREKTORY
  static Future<File> getFile() async{
    final fileDir = await getApplicationDocumentsDirectory();
    return File('${fileDir.path}/spendLog.JSON');
  }

//---------------------------------------------------------------------
  //PENYIMPAN DATA
  static Future<void> saveTransaction(Transaction transaction) async{
    final fileTransaction = await getFile();

    Map<String, dynamic> data = {};

    if (await fileTransaction.exists()) {
      final content = await fileTransaction.readAsString();
      if(content.isNotEmpty){
        data = jsonDecode(content);
      }
    }

    //PENGAMBILAN DATA YANG ASELI NO FEK FEK YA GES YAAA
    final now = transaction.timeDate;
    final month = '${now.year}-${now.month.toString().padLeft(2,'0')}';
    final day = '${now.year}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')}';

    final transactionMap = {
      'time': '${now.hour}:${now.minute}',
      'value': transaction.amount,
      'note': transaction.note,
      'category': transaction.category,
    };

    templateJSON(data, month, day, transactionMap);

    await fileTransaction.writeAsString(jsonEncode(data));
    await Repository.loadFromZero();
  }

  static void templateJSON(
    Map<String,dynamic> data, 
    String month, day, 
    Map<String, dynamic> transaction)
    {
      data.putIfAbsent(month, () => {});
      data[month].putIfAbsent(day, () => []);
      data[month][day].add(transaction);
    }

//------------------------------------------------------------------
  //MELOAD SEMUA DATA DI STORAGE HP
  static Future<Map<String, dynamic>> loadTransaction() async{
    final fileTransaction = await getFile();
    if(!await fileTransaction.exists()){
      return {};
    }
      
    final content = await fileTransaction.readAsString();
    if(content.isEmpty){
      return {};
    }

    return jsonDecode(content) as Map<String,dynamic>;  
  }


//---------------------------------------------------------------------
  //BERSIHKAN SEMUA DATA
  static Future<void> hapusJawir() async{
    final fileTransaction = await getFile();

    if(await fileTransaction.exists()){
      await fileTransaction.writeAsString(jsonEncode({}));
    }

    await Repository.loadFromZero();
  }

//----------------------------------------------------------------

static Future<void> generateDummyData() async{
 Map<String, dynamic> dummyData = {
  "2025-12": {
    "2025-12-01": [
      {
        "time": "08:10",
        "value": 15000,
        "note": "Sarapan",
        "category": "Makanan"
      },
      {
        "time": "12:45",
        "value": 30000,
        "note": "Makan siang",
        "category": "Makanan"
      },
      {
        "time": "19:30",
        "value": 25000,
        "note": "Ojek online",
        "category": "Transport"
      }
    ],
    "2025-12-02": [
      {
        "time": "09:00",
        "value": 10000,
        "note": "Kopi",
        "category": "Hiburan"
      },
      {
        "time": "13:20",
        "value": 28000,
        "note": "",
        "category": "Makanan"
      },
      {
        "time": "20:15",
        "value": 40000,
        "note": "Nonton film",
        "category": "Hiburan"
      },
      {
        "time": "22:00",
        "value": 12000,
        "note": "Snack",
        "category": "Makanan"
      }
    ],
    "2025-12-03": [
      {
        "time": "07:30",
        "value": 18000,
        "note": "Sarapan",
        "category": "Makanan"
      },
      {
        "time": "12:00",
        "value": 32000,
        "note": "",
        "category": "Makanan"
      },
      {
        "time": "18:40",
        "value": 15000,
        "note": "Parkir",
        "category": "Transport"
      }
    ],
    "2025-12-04": [
      {
        "time": "10:15",
        "value": 50000,
        "note": "Belanja",
        "category": "Lainnya"
      },
      {
        "time": "14:00",
        "value": 20000,
        "note": "Makan siang",
        "category": "Makanan"
      },
      {
        "time": "19:10",
        "value": 45000,
        "note": "Ngopi",
        "category": "Hiburan"
      }
    ],
    "2025-12-05": [
      {
        "time": "08:00",
        "value": 12000,
        "note": "",
        "category": "Makanan"
      },
      {
        "time": "12:30",
        "value": 35000,
        "note": "Makan siang",
        "category": "Makanan"
      },
      {
        "time": "21:00",
        "value": 60000,
        "note": "Beli pulsa",
        "category": "Tagihan"
      }
    ]
  },

  "2026-01": {
    "2026-01-01": [
      {
        "time": "09:20",
        "value": 20000,
        "note": "Sarapan",
        "category": "Makanan"
      },
      {
        "time": "13:10",
        "value": 30000,
        "note": "",
        "category": "Makanan"
      },
      {
        "time": "18:50",
        "value": 25000,
        "note": "Bensin",
        "category": "Transport"
      }
    ],
    "2026-01-02": [
      {
        "time": "07:45",
        "value": 10000,
        "note": "Kopi",
        "category": "Hiburan"
      },
      {
        "time": "12:00",
        "value": 28000,
        "note": "",
        "category": "Makanan"
      },
      {
        "time": "19:30",
        "value": 55000,
        "note": "Makan malam",
        "category": "Makanan"
      }
    ],
    "2026-01-03": [
      {
        "time": "08:15",
        "value": 15000,
        "note": "",
        "category": "Makanan"
      },
      {
        "time": "13:40",
        "value": 45000,
        "note": "Belanja",
        "category": "Lainnya"
      },
      {
        "time": "20:10",
        "value": 30000,
        "note": "Streaming",
        "category": "Hiburan"
      },
      {
        "time": "22:30",
        "value": 12000,
        "note": "",
        "category": "Makanan"
      }
    ],
    "2026-01-04": [
      {
        "time": "09:00",
        "value": 22000,
        "note": "",
        "category": "Makanan"
      },
      {
        "time": "14:20",
        "value": 35000,
        "note": "Transport",
        "category": "Transport"
      },
      {
        "time": "19:00",
        "value": 40000,
        "note": "Makan malam",
        "category": "Makanan"
      }
    ],
    "2026-01-05": [
      {
        "time": "08:30",
        "value": 18000,
        "note": "",
        "category": "Makanan"
      },
      {
        "time": "12:10",
        "value": 30000,
        "note": "",
        "category": "Makanan"
      },
      {
        "time": "21:45",
        "value": 75000,
        "note": "Internet",
        "category": "Tagihan"
      },
      {
        "time": "21:45",
        "value": 75000,
        "note": "Beli Buku",
        "category": "Pendidikan"
      },
      {
        "time": "21:45",
        "value": 75000,
        "note": "Beli nasi padang buat nyogok orang demo",
        "category": "Politik"
      }
    ]
  }
};

  final fileTransaction = await getFile();
  await fileTransaction.writeAsString(jsonEncode(dummyData));
  await Repository.loadFromZero();

  }
}