enum TipoPaciente {
  bebe(1, 'Bêbe'),
  crianca(2, 'Criança'),
  adulto(3, 'Adulto'),
  idoso(4, 'Idoso'),
  dependente(17, 'Dependente');

  const TipoPaciente(this.codigo, this.descricao);
  final int codigo;
  final String descricao;

  static TipoPaciente fromId(int codigo) {
    return TipoPaciente.values.firstWhere((cargo) => cargo.codigo == codigo);
  }

  static String getNomeById(int codigo) {
    return TipoPaciente.values.firstWhere((cargo) => cargo.codigo == codigo).descricao;
  }

  static List<TipoPaciente> getAll() {
    return TipoPaciente.values;
  }
}