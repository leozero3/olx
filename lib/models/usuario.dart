class Usuario{

  String _idUsuario;
  String _nome;
  String _email;
  String _senha;

  String get idUsuario => _idUsuario;

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map={
      'idUsuario' : idUsuario,
      'nome' : nome,
      'email' : email,
    };
    return map;
  }

  set idUsuario(String value) {
    _idUsuario = value;
  }

  String get nome => _nome;

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  set nome(String value) {
    _nome = value;
  }
}