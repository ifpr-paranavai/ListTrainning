import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await Firebase.initializeApp(); // inicializa o Firebase
  });

  test('Teste de conexão com o Firebase', () async {
    // Cria um novo documento com um ID aleatório
    final collectionRef = FirebaseFirestore.instance.collection('test');
    final documentRef = collectionRef.doc();
    await documentRef.set({'foo': 'bar'});

    // Verifica se o documento foi criado com sucesso
    final snapshot = await documentRef.get();
    expect(snapshot.exists, isTrue);
    expect(snapshot.data(), equals({'foo': 'bar'}));
  });
}
