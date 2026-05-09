import 'package:flutter/rendering.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
  static const tableName = 'transactions';
  //AMBIL DIREKTORY
  static Future<Database> getFile() async{
    String path = join(await getDatabasesPath(), 'Database.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, time TEXT, value INTEGER, note TEXT, category TEXT)"
        );
      },
    );
  }

//------------------------------------------------------------------
  //Convert ke Nested Map
  static Map<String, dynamic> convertToNestedMap(List<Map<String, dynamic>> sqliteData) {
    Map<String, dynamic> nestedData = {};

    for (var row in sqliteData) {
      String date = row['date'];
      String month = date.substring(0, 7); 

      nestedData.putIfAbsent(month, () => <String, dynamic>{});
      
      nestedData[month].putIfAbsent(date, () => []);

      nestedData[month][date].add({
        'time': row['time'],
        'value': row['value'],
        'note': row['note'],
        'category': row['category'],
      });
    }
    return nestedData;
  }

//---------------------------------------------------------------------
  //PENYIMPAN DATA
  static Future<void> saveTransaction(Transaction transaction) async {
    final db = await getFile();

    final now = transaction.timeDate;
    final month = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    
    final Map<String, dynamic> dataToInsert = {
      'date': month,
      'time': '${now.hour}:${now.minute}',
      'value': transaction.amount,
      'note': transaction.note,
      'category': transaction.category,
    };

    await db.insert(
      tableName,
      dataToInsert,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

//------------------------------------------------------------------
  //MELOAD SEMUA DATA PERBULAN
  static Future<Map<String, dynamic>> loadTransaction(String? selectedMonth) async{
    final db = await getFile();
    var month = selectedMonth;
    
    if(month == null){
      final lastData = await db.query(tableName, orderBy: 'id DESC', limit: 1);

      if(lastData.isEmpty){
        return {};
      }
      month = lastData.first['date'] as String;
    }
    
    final data = await db.query(
      tableName,
      where: 'date LIKE ?',
      whereArgs: ["$month%"]
    );
    debugPrint('loadTransaction data dipanggil (SpendLog Storage)');
    return convertToNestedMap(data);
  }

//-----------------------------------------------------
  //FUNGSI UNTUK MENGAMBIL BULAN TERAKHIR
  static Future<String?> getLastMonth() async {
    final db = await getFile();

    final result = await db.query(
      tableName,
      columns: ['date'],
      orderBy: 'date DESC',
      limit: 1,
    );

    if (result.isEmpty) return null;

    final String fullDate = result.first['date'] as String;

    debugPrint('geLastMonth dipanggil (SpendLog Storage)');
    return fullDate.substring(0, 7);
  }
//------------------------------------------------------------------------------
  //GET DAFTAR BULAN
  static Future<List<String>> getAllMonth() async {
    final db = await getFile();

    final List<Map<String,dynamic>> result = await db.rawQuery(
      'SELECT DISTINCT SUBSTR(date, 1, 7) AS month FROM $tableName ORDER BY date ASC'
    );
    debugPrint('getAllMonth dipanggil (SpendLog Storage)');
    debugPrint('${result.map((item) => item['month'] as String).toList()}');
    return result.map((item) => item['month'] as String).toList();
  }

//---------------------------------------------------------------------
  //BERSIHKAN SEMUA DATA
  static Future<void> clearAllTransaction() async {
  final db = await getFile();
  await db.delete(tableName); 
  }

//----------------------------------------------------------------

  static Future<void> generateDummyData() async{
    final db = await getFile();
    final batch = db.batch();

    List<Map<String, dynamic>> dummyList = [
      {'date': '2025-12-01', 'time': '08:10', 'value': 15000, 'note': 'Sarapan', 'category': 'Makanan'},
      {'date': '2025-12-01', 'time': '12:45', 'value': 30000, 'note': 'Makan siang', 'category': 'Makanan'},
      {'date': '2025-12-01', 'time': '19:30', 'value': 25000, 'note': 'Ojek online', 'category': 'Transport'},
      {'date': '2025-12-02', 'time': '09:00', 'value': 10000, 'note': 'Kopi', 'category': 'Hiburan'},
      {'date': '2025-12-02', 'time': '13:20', 'value': 28000, 'note': '', 'category': 'Makanan'},
      {'date': '2025-12-02', 'time': '20:15', 'value': 40000, 'note': 'Nonton film', 'category': 'Hiburan'},
      {'date': '2025-12-02', 'time': '22:00', 'value': 12000, 'note': 'Snack', 'category': 'Makanan'},
      {'date': '2025-12-03', 'time': '07:30', 'value': 18000, 'note': 'Sarapan', 'category': 'Makanan'},
      {'date': '2025-12-03', 'time': '12:00', 'value': 32000, 'note': '', 'category': 'Makanan'},
      {'date': '2025-12-03', 'time': '18:40', 'value': 15000, 'note': 'Parkir', 'category': 'Transport'},
      {'date': '2025-12-04', 'time': '10:15', 'value': 50000, 'note': 'Belanja', 'category': 'Lainnya'},
      {'date': '2025-12-04', 'time': '14:00', 'value': 20000, 'note': 'Makan siang', 'category': 'Makanan'},
      {'date': '2025-12-04', 'time': '19:10', 'value': 45000, 'note': 'Ngopi', 'category': 'Hiburan'},
      {'date': '2025-12-05', 'time': '08:00', 'value': 12000, 'note': '', 'category': 'Makanan'},
      {'date': '2025-12-05', 'time': '12:30', 'value': 35000, 'note': 'Makan siang', 'category': 'Makanan'},
      {'date': '2025-12-05', 'time': '21:00', 'value': 60000, 'note': 'Beli pulsa', 'category': 'Tagihan'},
      {'date': '2026-01-01', 'time': '09:20', 'value': 20000, 'note': 'Sarapan', 'category': 'Makanan'},
      {'date': '2026-01-01', 'time': '13:10', 'value': 30000, 'note': '', 'category': 'Makanan'},
      {'date': '2026-01-01', 'time': '18:50', 'value': 25000, 'note': 'Bensin', 'category': 'Transport'},
      {'date': '2026-01-02', 'time': '07:45', 'value': 10000, 'note': 'Kopi', 'category': 'Hiburan'},
      {'date': '2026-01-02', 'time': '12:00', 'value': 28000, 'note': '', 'category': 'Makanan'},
      {'date': '2026-01-02', 'time': '19:30', 'value': 55000, 'note': 'Makan malam', 'category': 'Makanan'},
      {'date': '2026-01-03', 'time': '08:15', 'value': 15000, 'note': '', 'category': 'Makanan'},
      {'date': '2026-01-03', 'time': '13:40', 'value': 45000, 'note': 'Belanja', 'category': 'Lainnya'},
      {'date': '2026-01-03', 'time': '20:10', 'value': 30000, 'note': 'Streaming', 'category': 'Hiburan'},
      {'date': '2026-01-03', 'time': '22:30', 'value': 12000, 'note': '', 'category': 'Makanan'},
      {'date': '2026-01-04', 'time': '09:00', 'value': 22000, 'note': '', 'category': 'Makanan'},
      {'date': '2026-01-04', 'time': '14:20', 'value': 35000, 'note': 'Transport', 'category': 'Transport'},
      {'date': '2026-01-04', 'time': '19:00', 'value': 40000, 'note': 'Makan malam', 'category': 'Makanan'},
      {'date': '2026-01-05', 'time': '08:30', 'value': 18000, 'note': '', 'category': 'Makanan'},
      {'date': '2026-01-05', 'time': '12:10', 'value': 30000, 'note': '', 'category': 'Makanan'},
      {'date': '2026-01-05', 'time': '21:45', 'value': 75000, 'note': 'Internet', 'category': 'Tagihan'},
      {'date': '2026-01-05', 'time': '21:45', 'value': 75000, 'note': 'Beli Buku', 'category': 'Pendidikan'},
      {'date': '2026-01-05', 'time': '21:45', 'value': 75000, 'note': 'Beli nasi padang buat nyogok orang demo', 'category': 'Politik'},
    ];
    for (var data in dummyList) {
      batch.insert(tableName, data);
    }
    await batch.commit(noResult: true);
    
  }
  
}