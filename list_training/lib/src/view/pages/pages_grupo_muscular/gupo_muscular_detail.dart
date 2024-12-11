import 'package:flutter/material.dart';
import 'package:list_training/src/model/entidades/grupo_muscular.dart';
import 'package:list_training/src/model/firebase/grupo_muscular_firebase.dart';

import '../../components/campo_input.dart';
import '../../components/drawer.dart';

class GrupoMuscularDetail extends StatefulWidget {
  const GrupoMuscularDetail({super.key});

  @override
  State<GrupoMuscularDetail> createState() => _GrupoMuscularDetailState();
}

class _GrupoMuscularDetailState extends State<GrupoMuscularDetail> {
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  GrupoMuscularFirebase grupoMuscularFirebase = GrupoMuscularFirebase();
  String retornoValidador = 'Campo obrigatório';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Grupos Musculares',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      drawer: DrawerExample(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<List<GrupoMuscular>>(
                stream: grupoMuscularFirebase.readGruposMusculares(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<GrupoMuscular>> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Algo deu errado"));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text("Nenhum Grupo Muscular encontrado"));
                  }

                  // Ordenando os grupos musculares por nome em ordem alfabética
                  final gruposOrdenados = snapshot.data!
                    ..sort((a, b) => a.nome.compareTo(b.nome));

                  return ListView(
                    children:
                        gruposOrdenados.map((GrupoMuscular grupoMuscular) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(
                            grupoMuscular.nome,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple),
                          ),
                          subtitle: Text(
                            grupoMuscular.descricao!,
                            style: TextStyle(color: Colors.black),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  _showEditModal(context, grupoMuscular);
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _confirmDelete(context, grupoMuscular.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              onPressed: () {
                _showModalBottomSheet(context);
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              backgroundColor: Colors.deepPurple,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Modal para adicionar ou editar um grupo muscular
  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: formGrupoMuscular(),
            ),
          ],
        );
      },
    );
  }

  // Função para abrir modal de edição
  void _showEditModal(BuildContext context, GrupoMuscular grupoMuscular) {
    _nomeController.text = grupoMuscular.nome;
    _descricaoController.text = grupoMuscular.descricao ?? '';

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 50,
                    child: Center(
                      child: Text(
                        'Editar Grupo Muscular',
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                  CampoInput(
                      visibilidade: false,
                      rotulo: 'Nome',
                      tipo: TextInputType.name,
                      controller: _nomeController,
                      retornoValidador: retornoValidador),
                  CampoInput(
                      visibilidade: false,
                      rotulo: 'Descrição',
                      tipo: TextInputType.text,
                      controller: _descricaoController,
                      retornoValidador: retornoValidador),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_task_rounded),
                          SizedBox(width: 8),
                          Text('Salvar'),
                        ],
                      ),
                      onPressed: () {
                        grupoMuscularFirebase.updateGrupoMuscular(
                          id: grupoMuscular.id,
                          nome: _nomeController.text,
                          descricao: _descricaoController.text,
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // Função para exibir diálogo de confirmação para deletar
  void _confirmDelete(BuildContext context, String id) async {
    bool isLinked = await grupoMuscularFirebase.isGrupoMuscularLinked(id);

    if (isLinked) {
      // Exibe mensagem de erro se o grupo muscular estiver vinculado a um exercício
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text(
                'Este grupo muscular está vinculado a um exercício e não pode ser excluído.'),
            actions: [
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    } else {
      // Exibe diálogo de confirmação para exclusão
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmar Exclusão'),
            content: const Text(
                'Tem certeza que deseja deletar este grupo muscular?'),
            actions: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Excluir'),
                onPressed: () {
                  grupoMuscularFirebase.deleteGrupoMuscular(id: id);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  // Formulário para adicionar novo grupo muscular
  Widget formGrupoMuscular() {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20), // Adiciona espaço acima do título
          const Center(
            child: Text(
              'Grupo Muscular',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold, // Dá maior destaque ao título
                color: Colors.deepPurple, // Cor para combinar com o tema
              ),
              textAlign: TextAlign.center, // Garante alinhamento central
            ),
          ),
          const SizedBox(height: 20), // Espaço abaixo do título
          CampoInput(
            visibilidade: false,
            rotulo: 'Nome',
            tipo: TextInputType.name,
            controller: _nomeController,
            retornoValidador: retornoValidador,
          ),
          CampoInput(
            visibilidade: false,
            rotulo: 'Descrição',
            tipo: TextInputType.text,
            controller: _descricaoController,
            retornoValidador: retornoValidador,
          ),
          const SizedBox(height: 20), // Espaço entre os campos e o botão
          ElevatedButton.icon(
            icon: const Icon(Icons.add_task_rounded, color: Colors.white),
            label: const Text(
              'Salvar',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.deepPurple, // Cor do botão de salvar
              shape: const StadiumBorder(), // Estilo arredondado
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            onPressed: () {
              grupoMuscularFirebase.addGrupoMuscular(
                cGrupoMuscular: GrupoMuscular(
                  nome: _nomeController.text,
                  descricao: _descricaoController.text,
                ),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
