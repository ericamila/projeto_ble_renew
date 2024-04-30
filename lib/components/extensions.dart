extension DateTimeExtension on DateTime {
  String get FormatBrazilianDate{
    return '$day/$month/$year';
  }
  String get FormatBrazilianTime{ //Alterar
    return '$hour:$minute:$second';
  }
}