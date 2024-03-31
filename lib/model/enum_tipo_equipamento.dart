enum TipoEquipamento {
  cama(0, 'Cama'),
  mesa(1, 'Mesa'),
  cadeira(2, 'Cadeira'),
  sofa(3, 'Sofá'),
  armario(4, 'Armário'),
  televisao(5, 'Televisão'),
  desfibrilador(6, 'Desfibrilador'),
  monitorMultiparametrico(7, 'Monitor Multiparamétrico'),
  bombaInfusao(8, 'Bomba de Infusão'),
  eletrocardiografo(9, 'Eletrocardiógrafo '),
  carroCurativo(10, 'Carrinho de curativo'),
  computadores(11, 'Computadores'),
  balanca(12, 'Balança'),
  aparelhoRaioX(13, 'Aparelho de raio-X');

  const TipoEquipamento(this.codigo, this.descricao);
  final int codigo;
  final String descricao;

  static TipoEquipamento fromId(int codigo) {
    return TipoEquipamento.values.firstWhere((cargo) => cargo.codigo == codigo);
  }

  static String getNomeById(int codigo) {
    return TipoEquipamento.values.firstWhere((cargo) => cargo.codigo == codigo).descricao;
  }

  static List<TipoEquipamento> getAll() {
    return TipoEquipamento.values;
  }
}