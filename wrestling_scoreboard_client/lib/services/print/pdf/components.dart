import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:wrestling_scoreboard_client/services/print/pdf/pdf_sheet.dart';
import 'package:wrestling_scoreboard_common/common.dart';

Container buildCheckBox({
  bool isChecked = false,
  PdfColor pencilColor = PdfSheet.pencilColor,
  PdfColor? checkBoxColor,
  double size = 20,
}) => Container(
  color: checkBoxColor,
  height: size,
  width: size,
  foregroundDecoration: BoxDecoration(border: Border.all(color: PdfColors.grey, width: .5)),
  alignment: Alignment.center,
  child: isChecked ? Text('×', style: TextStyle(fontSize: size, color: pencilColor)) : null,
);

Widget buildTextCell(
  String title, {
  double? height = 60,
  double? width,
  double? fontSize,
  PdfColor? borderColor,
  double? borderWidth,
  PdfColor? textColor,
  PdfColor? color,
  EdgeInsets? margin,
  Alignment alignment = Alignment.centerLeft,
}) {
  return buildTableCellWidget(
    child: Text(title, style: TextStyle(fontSize: fontSize, color: textColor ?? PdfColors.black)),
    margin: margin,
    height: height,
    alignment: alignment,
    borderColor: borderColor,
    borderWidth: borderWidth,
    color: color,
    width: width,
  );
}

Widget buildTableCellWidget({
  required Widget child,
  double? height = 60,
  double? width,
  PdfColor? borderColor,
  double? borderWidth,
  PdfColor? color,
  EdgeInsets? margin,
  Alignment alignment = Alignment.centerLeft,
}) {
  borderWidth ??= 0.5;
  return Container(
    color: color,
    margin: margin,
    padding: const EdgeInsets.all(2),
    alignment: alignment,
    foregroundDecoration:
        borderWidth <= 0
            ? null
            : BoxDecoration(border: Border.all(color: borderColor ?? PdfColors.grey, width: borderWidth)),
    height: height,
    width: width,
    child: child,
  );
}

Widget buildFormCell({
  String? title,
  String? content,
  double height = 40,
  double? width,
  PdfColor borderColor = PdfColors.grey,
  PdfColor? color,
  PdfColor pencilColor = PdfSheet.pencilColor,
  AlignmentGeometry? contentAlignment = Alignment.center,
}) {
  return buildFormCellWidget(
    title: title,
    content: content == null ? null : Text(content, style: TextStyle(fontSize: 11, color: pencilColor)),
    height: height,
    width: width,
    borderColor: borderColor,
    color: color,
    pencilColor: pencilColor,
    contentAlignment: contentAlignment,
  );
}

Widget buildFormCellWidget({
  String? title,
  Widget? content,
  double height = 40,
  double? width,
  PdfColor borderColor = PdfColors.grey,
  PdfColor? color,
  PdfColor pencilColor = PdfSheet.pencilColor,
  AlignmentGeometry? contentAlignment = Alignment.center,
  EdgeInsets? contentPadding = const EdgeInsets.symmetric(horizontal: 2),
}) {
  return Container(
    height: height,
    width: width,
    foregroundDecoration: BoxDecoration(border: Border.all(color: borderColor, width: .5)),
    color: color,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Container(
            padding: const EdgeInsets.only(left: 2, top: 2),
            child: Text(title.toUpperCase(), style: const TextStyle(fontSize: 6, fontWeight: FontWeight.bold)),
          ),
        content == null
            ? SizedBox.expand()
            : Expanded(child: Container(padding: contentPadding, alignment: contentAlignment, child: content)),
      ],
    ),
  );
}

extension BoutRolePdfColor on BoutRole {
  PdfColor get pdfColor {
    return this == BoutRole.red ? PdfSheet.homeColor : PdfSheet.guestColor;
  }

  PdfColor get textPdfColor {
    return PdfColors.white;
  }
}
