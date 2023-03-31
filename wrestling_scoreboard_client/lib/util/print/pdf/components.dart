import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

Widget buildTextCell(
  String title, {
  double? height = 60,
  double? width,
  double? fontSize,
  PdfColor borderColor = PdfColors.grey,
  PdfColor textColor = PdfColors.black,
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
        border: Border.all(
          color: borderColor,
          width: .5,
        ),
      ),
      height: height,
      width: width,
      child: Text(title, style: TextStyle(fontSize: fontSize, color: textColor)));
}

Widget buildFormCell({
  String? title,
  String? content,
  double height = 60,
  double? width,
  PdfColor borderColor = PdfColors.grey,
  PdfColor? color,
  PdfColor pencilColor = PdfColors.blue800,
}) {
  return Container(
    height: height,
    width: width,
    foregroundDecoration: BoxDecoration(
      border: Border.all(
        color: borderColor,
        width: .5,
      ),
    ),
    color: color,
    child: Stack(
      children: [
        if (title != null)
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(2),
            child: Text(title.toUpperCase(), style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold)),
          ),
        if (content != null)
          Expanded(
              child: Container(
            alignment: Alignment.center,
            child: Text(content, style: TextStyle(fontSize: 12, color: pencilColor)),
          )),
      ],
    ),
  );
}
