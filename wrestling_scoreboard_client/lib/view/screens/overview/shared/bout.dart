import 'package:wrestling_scoreboard_client/utils/io.dart';
import 'package:wrestling_scoreboard_common/common.dart';

extension BoutFileExt on Bout {
  String getFileBaseName(WrestlingEvent event) {
    final fileNameBuilder = [
      event.date.toFileNameDateFormat(),
      id?.toString(),
      r?.membership.person.surname,
      '–',
      b?.membership.person.surname,
    ];
    fileNameBuilder.removeWhere((e) => e == null || e.isEmpty);
    return fileNameBuilder.join('_').sanitizedFileName;
  }
}
