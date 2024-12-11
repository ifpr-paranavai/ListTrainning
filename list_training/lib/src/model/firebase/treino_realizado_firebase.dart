import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../entidades/exercicio_realizado.dart';
import '../entidades/treino_realizado.dart';

class TreinoRealizadoFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Função para adicionar um treino realizado e seus exercícios realizados à subcoleção do usuário logado
  Future<void> addTreinoRealizadoParaUsuarioLogado({
    required TreinoRealizado treinoRealizado,
    required List<ExercicioRealizado> exerciciosRealizados,
  }) async {
    try {
      // Obtendo o usuário logado
      User? usuario = _auth.currentUser;

      if (usuario != null) {
        String userId = usuario.uid;

        // Referência para a subcoleção 'treinos_realizados' dentro do documento do usuário
        DocumentReference userDocRef =
            _firestore.collection('users').doc(userId);
        CollectionReference treinosRealizadosCollectionRef =
            userDocRef.collection('treinos_realizados');

        // Cria um novo documento de treino realizado
        DocumentReference docTreinoRealizado =
            treinosRealizadosCollectionRef.doc();

        final treinoRealizadoData = TreinoRealizado(
          id: docTreinoRealizado.id,
          idTreino: treinoRealizado.idTreino,
          data: treinoRealizado.data,
        ).toJson();

        // Adiciona o treino realizado à subcoleção
        await docTreinoRealizado.set(treinoRealizadoData).then((value) async {
          print('Treino realizado cadastrado com sucesso');

          // Agora adiciona os exercícios realizados dentro da subcoleção 'exercicios_realizados' do treino
          CollectionReference exerciciosRealizadosCollectionRef =
              docTreinoRealizado.collection('exercicios_realizados');

          for (var exercicioRealizado in exerciciosRealizados) {
            DocumentReference docExercicioRealizado =
                exerciciosRealizadosCollectionRef.doc();

            final exercicioRealizadoData = ExercicioRealizado(
              id: docExercicioRealizado.id,
              nome: exercicioRealizado.nome,
              peso: exercicioRealizado.peso,
              repeticao: exercicioRealizado.repeticao,
              dataRealizacao: exercicioRealizado.dataRealizacao,
            ).toJson();

            // Adiciona o exercício realizado ao treino
            await docExercicioRealizado
                .set(exercicioRealizadoData)
                .then((value) {
              print('Exercicio realizado cadastrado com sucesso');
            }).catchError((error) {
              print('Erro ao adicionar exercício realizado: $error');
            });
          }
        }).catchError(
            (error) => print('Erro ao adicionar treino realizado: $error'));
      } else {
        print('Nenhum usuário está logado.');
      }
    } catch (e) {
      print('Erro ao adicionar treino realizado: $e');
    }
  }

  // Função para listar todos os treinos realizados e seus exercícios realizados da subcoleção do usuário logado
  Stream<List<TreinoRealizado>> readTreinosRealizadosDoUsuarioLogado() {
    User? usuario = _auth.currentUser;

    if (usuario != null) {
      String userId = usuario.uid;

      // Referência para a subcoleção 'treinos_realizados' dentro do documento do usuário
      CollectionReference treinosRealizadosCollectionRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('treinos_realizados');

      // Retorna o Stream para os treinos realizados
      return treinosRealizadosCollectionRef
          .snapshots()
          .asyncMap((querySnapshot) async {
        List<TreinoRealizado> treinos = [];

        // Para cada treino realizado, obtém os exercícios realizados
        for (var doc in querySnapshot.docs) {
          TreinoRealizado treino =
              TreinoRealizado.fromJson(doc.data() as Map<String, dynamic>);

          // Agora lemos a subcoleção de exercícios realizados dentro do treino
          CollectionReference exerciciosRealizadosCollectionRef =
              doc.reference.collection('exercicios_realizados');

          // Obtém os exercícios realizados
          var exerciciosSnapshot =
              await exerciciosRealizadosCollectionRef.get();
          List<ExercicioRealizado> exerciciosRealizados = exerciciosSnapshot
              .docs
              .map((exercicioDoc) => ExercicioRealizado.fromJson(
                  exercicioDoc.data() as Map<String, dynamic>))
              .toList();

          // Agora associamos os exercícios ao treino
          treino.exerciciosRealizados = exerciciosRealizados;
          treinos.add(treino);
        }

        return treinos;
      });
    } else {
      print('Nenhum usuário está logado.');
      return Stream.value(
          []); // Retorna uma stream vazia se não houver usuário logado
    }
  }

  // Função para deletar um treino realizado pelo ID e seus exercícios realizados
  Future<void> deleteTreinoRealizadoById(String id) async {
    try {
      User? usuario = _auth.currentUser;

      if (usuario != null) {
        String userId = usuario.uid;

        // Referência para o documento do treino realizado
        DocumentReference docTreinoRealizado = _firestore
            .collection('users')
            .doc(userId)
            .collection('treinos_realizados')
            .doc(id);

        // Exclui o documento do treino realizado
        await docTreinoRealizado.delete().then((value) async {
          // Exclui todos os exercícios realizados dentro desse treino
          CollectionReference exerciciosRealizadosCollectionRef =
              docTreinoRealizado.collection('exercicios_realizados');

          var exerciciosSnapshot =
              await exerciciosRealizadosCollectionRef.get();
          for (var exercicio in exerciciosSnapshot.docs) {
            await exercicio.reference.delete();
          }
          print('Treino e exercícios realizados excluídos com sucesso');
        }).catchError(
            (error) => print('Erro ao excluir treino realizado: $error'));
      } else {
        print('Nenhum usuário está logado.');
      }
    } catch (e) {
      print('Erro ao excluir treino realizado: $e');
    }
  }
}
