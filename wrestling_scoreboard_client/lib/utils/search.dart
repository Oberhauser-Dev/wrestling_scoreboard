bool isValidSearchTerm(String searchTerm) {
  return searchTerm.length > 3 || (double.tryParse(searchTerm) != null);
}
