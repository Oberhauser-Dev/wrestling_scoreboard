import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_quill_to_pdf/flutter_quill_to_pdf.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:wrestling_scoreboard_client/services/print/pdf/pdf_sheet.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionCertificate extends PdfSheet {
  CompetitionCertificate({
    required this.competition,
    this.contestants = const [],
    required this.deltaAsJson,
    super.baseColor,
    super.accentColor,
    required super.buildContext,
  });

  final Competition competition;
  final String deltaAsJson;

  // TODO: to model
  final List<String> contestants;

  Competition get event => competition;

  @override
  Future<Uint8List> buildPdf({PdfPageFormat? pageFormat}) async {
    // TODO: maybe use another editor, which is based on flutter_quill, or provide own implementation which supports single text fields.
    final replacedCompetition = deltaAsJson.replaceAll('{competition}', competition.name);
    final tmpContestants = contestants.toList();
    if (tmpContestants.isEmpty) {
      tmpContestants.add('John');
    }
    final deltas = tmpContestants.map((c) {
      final replacedContestant = replacedCompetition.replaceAll('{prename}', c).replaceAll('{surname}', c);
      return Delta.fromJson(jsonDecode(replacedContestant));
    }).toList();
    // TODO: manipulate delta to spread across multiple pages
    final pdfConverter = PDFConverter(
      pageFormat: PDFPageFormat.a4,
      document: deltas.reduce((value, element) {
        // TODO add new page
        return value.concat(element);
      }),
      // onRequestFontFamily: (familyRequest) {
      //   // final gFont =  GoogleFonts.getTextTheme(fontFamily);
      //   // final gFont =  GoogleFonts.pendingFonts(fontFamily);
      //   // return TtfFont(
      //   //   bytes.buffer.asByteData(bytes.offsetInBytes, bytes.lengthInBytes),
      //   //   protect: protect,
      //   // );
      //   final textStyle = PdfGoogleFonts.valu(familyRequest.family);
      //   return FontFamilyResponse(fontNormalV: textStyle.font);
      // },
      // onDetectAlignedParagraph: ,
      fallbacks: [],
    );
    final doc = await pdfConverter.createDocument();

    // Add page to the PDF
    // doc!.addPage(
    //   MultiPage(
    //     pageTheme: await buildTheme(pageFormat: pageFormat ?? PdfSheet.a4Cross),
    //     footer: buildFooter,
    //     build: (context) => [buildInfo(context, event)],
    //   ),
    // );

    // Return the PDF file content
    return doc!.save();
  }
}
