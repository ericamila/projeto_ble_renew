extension DateTimeExtension on DateTime {
  String get formatBrazilianDate{
    return '$day/$month/$year';
  }
  String get formatBrazilianTime{ //Alterar
    return '$hour:$minute:$second';
  }
}