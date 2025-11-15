import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_verification.freezed.dart';
part 'user_verification.g.dart';

enum VerificationMethod { email, sms }

@freezed
abstract class UserVerification with _$UserVerification {
  const UserVerification._();

  const factory UserVerification({
    required String username,
    required String verificationCode,
    required VerificationMethod method,
  }) = _UserVerification;

  factory UserVerification.fromJson(Map<String, Object?> json) => _$UserVerificationFromJson(json);

  static const cTableName = 'user_verification';
}
