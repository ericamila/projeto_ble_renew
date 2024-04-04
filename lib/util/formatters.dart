import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

var macFormatter = MaskTextInputFormatter(
    mask: '##:##:##:##:##:##',
    filter: { "#": RegExp(r'[0-9A-Fa-f]') },
    type: MaskAutoCompletionType.lazy
);

var cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy
);