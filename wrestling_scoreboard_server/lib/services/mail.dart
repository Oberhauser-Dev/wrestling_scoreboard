import 'package:logging/logging.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:wrestling_scoreboard_server/controllers/common/exceptions.dart';
import 'package:wrestling_scoreboard_server/services/environment.dart';

final _logger = Logger('Mail');

final supportEmail = env.smtpHost != null && env.smtpUser != null && env.smtpPassword != null;

String _getHtmlContent(String body) {
  return '''<!DOCTYPE html>
<html>
<body style="font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 20px;">
<table align="center" cellpadding="0" cellspacing="0" style="max-width: 600px; background: #ffffff; padding: 20px; border-radius: 8px;"
       width="100%">
    <tr>
        <td>
            $body
            <p>Thanks,<br>${env.webClientUrl != null ? '<a href="${env.webClientUrl}">${env.issuer}</a>' : env.issuer}</p>
        </td>
    </tr>
</table>
</body>
</html>
''';
}

String getHtmlButton(String href, String text) {
  return '''
<p style="text-align: center; margin: 30px 0;">
    <a href="$href"
       style="background-color: #2196f3; color: #ffffff; padding: 12px 20px; text-decoration: none; border-radius: 5px;">
        $text
    </a>
</p>
  ''';
}

Future<void> sendMail({required String recipient, required String subject, required String body}) async {
  if (!supportEmail) throw InvalidParameterException('Cannot send email without having SMTP parameters specified.');
  final smtpServer = SmtpServer(
    env.smtpHost!,
    username: env.smtpUser,
    password: env.smtpPassword,
    port: env.smtpPort ?? 587,
  );

  final message =
      Message()
        ..from = Address(env.smtpFrom!, 'Wrestling Scoreboard')
        ..recipients.add(recipient)
        ..subject = subject
        ..html = _getHtmlContent(body);

  try {
    final sendReport = await send(message, smtpServer);
    _logger.fine('Mail sent: $sendReport');
  } on MailerException catch (e, st) {
    _logger.warning('Mail not sent.', e, st);
  }
}
