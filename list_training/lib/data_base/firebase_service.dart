import 'package:firebase_database/firebase_database.dart';

class FirebaseService{
  
  late FirebaseDatabase database;

  FirebaseService(){
    database = FirebaseDatabase.instance;
  }

  Future<void> addData(String path, Map<String, dynamic> data)async{
    String? key = database.reference().child(path).push().key;
    await database.reference().child(path).push().set(data);
  }

  Future<void> updateData(String path, String key, Map<String, dynamic> data)async{
    await database.reference().child(path).child(key).update(data);
  }

  Future<void> deleteData(String path, String key) async {
    await database.reference().child(path).child(key).remove();
  }

  Future<List<Map<String, dynamic>>> getAllData(String path)async{
    DataSnapshot snapshot = (await database.reference().child(path).once()) as DataSnapshot;

    List<Map<String, dynamic>> listData = [];

    if(snapshot.value != null){
      
    }

    return listData;
  }
}