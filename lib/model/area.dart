enum Area {
  recepcao(1, 'Recepção'),
  pediatria(2, 'Pediatria'),
  quarto1(3, 'Quarto 1'),
  quarto2(4, 'Quarto 2'),
  quarto3(5, 'Quarto 3'),
  uti1(6, 'UTI 1'),
  laboratorio01(7, 'Laboratório 01'),
  laboratorio02(8, 'Laboratório 02'),
  salaraiox(9, 'Sala de Raio-X'),
  emergencia(10, 'Emergência'),
  neurologia(11, 'Neurologia'),
  cardiologia(12, 'Cardiologia'),
  ortopedia(13, 'Ortopedia'),
  corredorprincipal(14, 'Corredor Principal'),
  alainfantil(15, 'Ala Infantil');

  const Area(this.codigo, this.descricao);
  final int codigo;
  final String descricao;

  static Area fromId(int codigo) {
    return Area.values.firstWhere((cargo) => cargo.codigo == codigo);
  }

  static String getNomeById(int codigo) {
    return Area.values.firstWhere((cargo) => cargo.codigo == codigo).descricao;
  }

  static List<Area> getAll() {
    return Area.values;
  }
}