import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:notasdiarias_app/anotacao.dart';
import 'dao.dart';

TextEditingController _tituloController = TextEditingController();
TextEditingController _descricaoController = TextEditingController();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Anotacao> _listadeAnotacoes = [];
  DAO _dao = DAO();

  _showAddNewAnotationScreen() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Adicionar anotação"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _tituloController,
                  keyboardType: TextInputType.text,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Título", hintText: "Ex: Minha anotação"),
                ),
                TextField(
                  controller: _descricaoController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Descrição",
                      hintText: "Ex: Essa é uma descrição"),
                ),
              ],
            ),
            actions: [
              FlatButton(
                child: Text("Salvar"),
                onPressed: () {

                  Anotacao anotacao = Anotacao(
                      titulo: _tituloController.text,
                      descricao: _descricaoController.text,
                      data: DateTime.now().toString(),
                  );

                  setState(() {
                    _listadeAnotacoes.add(anotacao);
                    _updateList();
                  });

                  _dao.salvarAnotacao(anotacao);
                  _tituloController.clear();
                  _descricaoController.clear();
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                  onPressed: () {
                    _tituloController..clear();
                    _descricaoController.clear();
                    Navigator.pop(context);
                  },
                  child: Text("Cancelar")),
            ],
          );
        });
  }

  _showUpdateAnotationScreen(Anotacao anotacao) {
    _tituloController.text = anotacao.titulo;
    _descricaoController.text = anotacao.descricao;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Atualizar anotação"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _tituloController,
                  keyboardType: TextInputType.text,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Título", hintText: "Ex: Minha anotação atualizada"),
                ),
                TextField(
                  controller: _descricaoController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(

                      labelText: "Descrição",
                      hintText: "Ex: Essa é uma descrição atualizada"),
                ),
              ],
            ),
            actions: [
              FlatButton(
                child: Text("Atualizar"),
                onPressed: () {
                  Anotacao anotacaoAtualizada = Anotacao(
                      id: anotacao.id,
                      titulo: _tituloController.text,
                      descricao: _descricaoController.text,
                      data: DateTime.now().toString(),
                  );

                  _dao.atualizarAnotacao(anotacaoAtualizada);

                  setState(() {
                    _updateList();
                  });

                  print("${anotacao.id}");
                  print("${anotacaoAtualizada.id}");

                  _tituloController.clear();
                  _descricaoController.clear();
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                  onPressed: () {
                    _tituloController..clear();
                    _descricaoController.clear();
                    Navigator.pop(context);
                  },
                  child: Text("Cancelar")),
            ],
          );
        });
  }

  String _formatarData(String data){
    initializeDateFormatting("pt_BR");

    //DateFormat formatador = DateFormat("d/MM/y H:m:s");
    DateFormat formatador = DateFormat.yMd("pt_BR");
    DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = formatador.format(dataConvertida);

    return dataFormatada;
  }

  Widget _showList(){
    return ListView.builder(
        itemCount: _listadeAnotacoes.length,
        itemBuilder: (context, index) {
          Anotacao anotacao = _listadeAnotacoes[index];

          return Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 8),
            child: Card(
              elevation: 6,
              child: ListTile(
                title: Text("${anotacao.titulo}"),
                subtitle: Text("${_formatarData(anotacao.data)} - ${anotacao.descricao}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: (){_showUpdateAnotationScreen(anotacao);},
                      child: Padding(padding: EdgeInsets.only(right: 30),child: Icon(Icons.edit, color: Colors.blue,)),
                    ),
                    GestureDetector(
                      onTap: (){
                        _dao.deletarAnotacao(anotacao.id);
                        setState(() {
                          _listadeAnotacoes.removeAt(index);
                          _updateList();
                        });
                      },
                      child: Icon(Icons.delete, color: Colors.red,),
                    ),
                  ],
                ),

              ),
            ),
          );
        });
  }

  _updateList(){
    _dao.recuperarAnotacoes().then((values) {
      setState(() {
        //print(values);
        _listadeAnotacoes = values.map<Anotacao>((map) {
          return Anotacao.fromJson(map);
        }).toList();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _updateList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anotações"),
      ),
      body: Container(
        child: _showList(),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _showAddNewAnotationScreen();
          }),
    );
  }
}
