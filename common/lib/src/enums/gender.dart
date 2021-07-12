/// The persons gender.
enum Gender {
  male,
  female,
  other,
}

Gender genderDecode(String val) {
  return Gender.values.singleWhere((element) => element.toString() == 'Gender.' + val);
}
