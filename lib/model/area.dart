//1-8 e 14,15
enum Area {
  recepcao(1, 'Recepção'),
  pediatria(2, 'Pediatria'),
  quarto1(3, 'Quarto 1'),
  quarto2(4, 'Quarto 2'),
  quarto3(5, 'Quarto 3'),
  quarto4(6, 'Quarto 4'),
  salaraiox(7, 'Sala de Raio-X'),
  ortopedia(8, 'Ortopedia'),
  laboratorio01(9, 'Laboratório 01'),
  emergencia(10, 'Emergência'),
  neurologia(11, 'Neurologia'),
  cardiologia(12, 'Cardiologia'),
  laboratorio02(13, 'Laboratório 02'),
  corredorprincipal(14, 'Corredor Principal'),
  banheiros(15, 'Banheiros');

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