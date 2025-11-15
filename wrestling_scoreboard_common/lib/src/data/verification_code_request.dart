import 'package:freezed_annotation/freezed_annotation.dart';

part 'verification_code_request.freezed.dart';

part 'verification_code_request.g.dart';

@freezed
abstract class VerificationCodeRequest with _$VerificationCodeRequest {
  const VerificationCodeRequest._();

  const factory VerificationCodeRequest({String? username}) = _VerificationCodeRequest;

  factory VerificationCodeRequest.fromJson(Map<String, Object?> json) => _$VerificationCodeRequestFromJson(json);

  static const cTableName = 'verification_code_request';
}
