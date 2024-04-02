enum TipoPacienteEnum {
  bebe(1, 'Bêbe'),
  crianca(2, 'Criança'),
  adulto(3, 'Adulto'),
  idoso(4, 'Idoso'),
  dependente(5, 'Dependente');

  const TipoPacienteEnum(this.codigo, this.descricao);
  final int codigo;
  final String descricao;

  static TipoPacienteEnum fromId(int codigo) {
    return TipoPacienteEnum.values.firstWhere((cargo) => cargo.codigo == codigo);
  }

  static String getNomeById(int codigo) {
    return TipoPacienteEnum.values.firstWhere((cargo) => cargo.codigo == codigo).descricao;
  }

  static List<TipoPacienteEnum> getAll() {
    return TipoPacienteEnum.values;
  }
}