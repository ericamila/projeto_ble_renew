enum TipoDispositivoEnum {
  pulseira(0, 'Pulseira'),
  cracha(1, 'Crachá'),
  etiqueta(2, 'Etiqueta');

  const TipoDispositivoEnum(this.codigo, this.descricao);
  final int codigo;
  final String descricao;

  static TipoDispositivoEnum fromId(int codigo) {
    return TipoDispositivoEnum.values.firstWhere((cargo) => cargo.codigo == codigo);
  }

  static String getNomeById(int codigo) {
    return TipoDispositivoEnum.values.firstWhere((cargo) => cargo.codigo == codigo).descricao;
  }

  static List<TipoDispositivoEnum> getAll() {
    return TipoDispositivoEnum.values;
  }
}