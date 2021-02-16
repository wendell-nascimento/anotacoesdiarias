

class Anotacao{
  int id;
  String titulo;
  String descricao;
  String data;

  Anotacao({this.id,this.titulo, this.descricao, this.data});

  static Map<String, dynamic> toMap(Anotacao anotacao){
    Map<String, dynamic> data = Map();

    data["titulo"] = anotacao.titulo;
    data["descricao"] = anotacao.descricao;
    data["data"] = anotacao.data;

    return data;
  }

  factory Anotacao.fromJson(Map<String,dynamic> map){
    return Anotacao(
        id: map["id"], //ID do banco de dados
        titulo: map["titulo"],
        descricao: map["descricao"],
        data: map["data"],
    );
  }
}