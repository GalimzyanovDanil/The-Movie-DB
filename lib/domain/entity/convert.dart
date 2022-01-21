DateTime? verifyDateTime(String? dateTimeString) {
  if (dateTimeString == null || dateTimeString.isEmpty) {
    return null;
  }
  return DateTime.tryParse(dateTimeString);
}
