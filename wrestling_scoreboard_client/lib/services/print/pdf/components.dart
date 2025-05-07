import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:wrestling_scoreboard_client/services/print/pdf/pdf_sheet.dart';
import 'package:wrestling_scoreboard_common/common.dart';

buildCheckBox({bool isChecked = false, PdfColor pencilColor = PdfSheet.pencilColor, PdfColor? checkBoxColor}) =>
    Container(
      color: checkBoxColor,
      margin: const EdgeInsets.all(4),
      height: 20,
      width: 20,
      foregroundDecoration: BoxDecoration(border: Border.all(color: PdfColors.grey, width: .5)),
      alignment: Alignment.center,
      child: isChecked ? Text('×', style: TextStyle(fontSize: 20, color: pencilColor)) : null,
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
  return Container(
    color: color,
    margin: margin,
    padding: const EdgeInsets.all(2),
    alignment: alignment,
    foregroundDecoration: BoxDecoration(
      border: Border.all(color: borderColor ?? PdfColors.grey, width: borderWidth ?? .5),
    ),
    height: height,
    width: width,
    child: Text(title, style: TextStyle(fontSize: fontSize, color: textColor ?? PdfColors.black)),
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
  EdgeInsets? contentPadding = const EdgeInsets.all(2),
}) {
  return Container(
    height: height,
    width: width,
    foregroundDecoration: BoxDecoration(border: Border.all(color: borderColor, width: .5)),
    color: color,
    child: Stack(
      children: [
        if (title != null)
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(2),
            child: Text(title.toUpperCase(), style: const TextStyle(fontSize: 6, fontWeight: FontWeight.bold)),
          ),
        if (content != null)
          Expanded(child: Container(padding: contentPadding, alignment: contentAlignment, child: content)),
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
