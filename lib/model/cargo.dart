enum Cargo {
  diretor(1, 'Diretor'),
  medico(2, 'Médico'),
  enfermeiro(3, 'Enfermeiro'),
  tecnicoDeEnfermagem(4, 'Técnico de Enfermagem'),
  fisioterapeuta(5, 'Fisioterapeuta'),
  nutricionista(6, 'Nutricionista'),
  psicologo(7, 'Psicólogo'),
  assistenteSocial(8, 'Assistente Social'),
  recepcionista(9, 'Recepcionista'),
  auxiliarAdministrativo(10, 'Auxiliar Administrativo'),
  zelador(11, 'Zelador'),
  jardineiro(12, 'Jardineiro'),
  cozinheiro(13, 'Cozinheiro'),
  garcom(14, 'Garçom'),
  lavadorDePratos(15, 'Lavador de Pratos'),
  limpador(16, 'Limpador'),
  seguranca(17, 'Segurança');

  const Cargo(this.codigo, this.descricao);
  final int codigo;
  final String descricao;

  static Cargo fromId(int codigo) {
    return Cargo.values.firstWhere((cargo) => cargo.codigo == codigo);
  }

  static String getNomeById(int codigo) {
    return Cargo.values.firstWhere((cargo) => cargo.codigo == codigo).descricao;
  }
}