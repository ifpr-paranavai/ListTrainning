import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:list_training/src/model/firebase/exercicio_firebse.dart';
import '../entidades/exercicio.dart';
import '../entidades/exercicio_realizado.dart';
import '../entidades/itens_treino.dart';
import '../entidades/treino.dart';
import '../entidades/treino_realizado.dart';

class TreinoRealizadoFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Função para adicionar um treino realizado e seus exercícios realizados à subcoleção do usuário logado
  Future<void> addTreinoRealizadoComExercicios(
      {required TreinoRealizado treinoRealizado,
      required List<ItensTreino> exerciciosRealizados}) async {
    try {
      // Obtendo o usuário logado
      User? usuario = _auth.currentUser;

      String nomeExercicio;

      if (usuario != null) {
        String userId = usuario.uid;

        // Referência para a subcoleção 'treinos_realizados' dentro do documento do usuário
        DocumentReference userDocRef =
            _firestore.collection('users').doc(userId);
        CollectionReference treinosRealizadosCollectionRef =
            userDocRef.collection('treinos_realizados');

        // Data atual formatada como string (para facilitar a comparação)
        String dataHoje = DateTime.now().toIso8601String().split('T')[0];

        // Verifica se já existe um treino realizado para o mesmo treino e data
        var existingTreinoSnapshot = await treinosRealizadosCollectionRef
            .where('idTreino', isEqualTo: treinoRealizado.idTreino)
            .where('data', isEqualTo: dataHoje)
            .limit(1)
            .get();

        DocumentReference docTreinoRealizado;

        if (existingTreinoSnapshot.docs.isNotEmpty) {
          // Se o treino já existe, reutiliza o documento existente
          docTreinoRealizado = existingTreinoSnapshot.docs.first.reference;
          print(
              'Treino realizado já existe para hoje. Adicionando exercícios.');
        } else {
          // Cria um novo documento de treino realizado com um ID único
          docTreinoRealizado = treinosRealizadosCollectionRef.doc();

          final treinoRealizadoData = {
            'id': docTreinoRealizado.id,
            'idTreino': treinoRealizado.idTreino,
            'nome': treinoRealizado.nome,
            'data': DateTime.now(),
          };

          // Salva o treino realizado
          await docTreinoRealizado.set(treinoRealizadoData);
          print('Novo treino realizado cadastrado com sucesso.');
        }

        // Adiciona os exercícios realizados à subcoleção 'exercicios_realizados'
        CollectionReference exerciciosRealizadosCollectionRef =
            docTreinoRealizado.collection('exercicios_realizados');

        for (var item in exerciciosRealizados) {
          var exercicio =
              await ExercicioFirebase().getExercicioById(item.idExercicio);
          nomeExercicio = exercicio?.nome ?? '';
          // Cria o ExercicioRealizado com base no ItensTreino
          ExercicioRealizado exercicioRealizado = ExercicioRealizado(
            idExercicio: item.idExercicio,
            sequncia: item.sequncia,
            nome: nomeExercicio,
            peso: item.peso,
            repeticao: item.repeticao,
            dataRealizacao: DateTime.now(),
            idTreinoRealizado: docTreinoRealizado.id,
          );

          // Cria um novo documento para o exercício realizado
          DocumentReference docExercicioRealizado =
              exerciciosRealizadosCollectionRef.doc();

          exercicioRealizado.id = docExercicioRealizado.id;

          // Salva o exercício realizado
          await docExercicioRealizado.set(exercicioRealizado.toJson());

          print(
              'Exercício realizado cadastrado com sucesso: ${exercicioRealizado.nome}');
        }
      } else {
        print('Nenhum usuário está logado.');
      }
    } catch (e) {
      print('Erro ao adicionar treino realizado e exercícios: $e');
    }
  }

  Future<void> addTreinoRealizadoSemExercicios({
    required Treino treinoRealizado,
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

        // Data atual formatada como string (para facilitar a comparação)
        String dataHoje = DateTime.now().toIso8601String().split('T')[0];

        // Verifica se já existe um treino realizado para o mesmo treino e data
        var existingTreinoSnapshot = await treinosRealizadosCollectionRef
            .where('idTreino', isEqualTo: treinoRealizado.id)
            .where('data', isEqualTo: dataHoje)
            .limit(1)
            .get();

        if (existingTreinoSnapshot.docs.isNotEmpty) {
          print('Treino realizado já cadastrado para hoje.');
          return; // Não faz nada se o treino já foi cadastrado hoje
        }

        // Cria um novo documento de treino realizado
        DocumentReference docTreinoRealizado =
            treinosRealizadosCollectionRef.doc();

        final treinoRealizadoData = TreinoRealizado(
          id: docTreinoRealizado.id,
          idTreino: treinoRealizado.id,
          nome: treinoRealizado.nome,
          data: DateTime.now(),
        ).toJson();

        // Salva o treino realizado
        await docTreinoRealizado.set(treinoRealizadoData);
        print('Novo treino realizado cadastrado com sucesso.');
      } else {
        print('Nenhum usuário está logado.');
      }
    } catch (e) {
      print('Erro ao adicionar treino realizado: $e');
    }
  }

  Future<void> addExercicioRealizado({
    required String idTreinoRealizado, // ID do treino realizado
    required ItensTreino
        exercicioRealizado, // Dados do exercício a ser adicionado
  }) async {
    try {
      // Obtendo o usuário logado
      User? usuario = _auth.currentUser;

      if (usuario != null) {
        String userId = usuario.uid;

        // Referência para o documento do treino realizado
        DocumentReference treinoRealizadoDocRef = _firestore
            .collection('users')
            .doc(userId)
            .collection('treinos_realizados')
            .doc(idTreinoRealizado);

        // Referência para a subcoleção 'exercicios_realizados'
        CollectionReference exerciciosRealizadosCollectionRef =
            treinoRealizadoDocRef.collection('exercicios_realizados');

        // Verifica se o exercício já existe na subcoleção
        var existingExercicioSnapshot = await exerciciosRealizadosCollectionRef
            .where('idExercicio', isEqualTo: exercicioRealizado.idExercicio)
            .limit(1)
            .get();

        if (existingExercicioSnapshot.docs.isEmpty) {
          // Obtem o nome do exercício
          String nomeExercicio;
          Exercicio? exercicioR = await ExercicioFirebase()
              .getExercicioById(exercicioRealizado.idExercicio);
          exercicioR != null
              ? nomeExercicio = exercicioR.nome
              : nomeExercicio = 'Exercicio sem nome';

          // Cria o documento do exercício realizado
          DocumentReference docExercicioRealizado =
              exerciciosRealizadosCollectionRef.doc();
          final exercicioRealizadoData = ExercicioRealizado(
            id: docExercicioRealizado.id,
            idExercicio: exercicioRealizado.idExercicio,
            sequncia: exercicioRealizado.sequncia,
            nome: nomeExercicio,
            peso: exercicioRealizado.peso,
            repeticao: exercicioRealizado.repeticao,
            dataRealizacao: DateTime.now(),
          ).toJson();

          // Salva o exercício realizado
          await docExercicioRealizado.set(exercicioRealizadoData);
          print('Exercício realizado cadastrado com sucesso.');
        } else {
          print('Exercício já cadastrado no treino realizado. Ignorando.');
        }
      } else {
        print('Nenhum usuário está logado.');
      }
    } catch (e) {
      print('Erro ao adicionar exercício realizado: $e');
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
          var data = doc.data() as Map<String, dynamic>;
          TreinoRealizado treino = TreinoRealizado.fromJson(data);

          // Lê a subcoleção de exercícios realizados
          var exerciciosSnapshot =
              await doc.reference.collection('exercicios_realizados').get();
          List<ExercicioRealizado> exerciciosRealizados = exerciciosSnapshot
              .docs
              .map((exercicioDoc) => ExercicioRealizado.fromJson(
                  exercicioDoc.data() as Map<String, dynamic>))
              .toList();

          // Associa os exercícios ao treino
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
}
