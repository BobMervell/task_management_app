
extension StringExtension on String {
  
  String truncateText(int maxLength) {
   if (length <= maxLength) {
      return this;
    } else {
      return '${substring(0, maxLength)} ... ';
    }
  }

  String toReadable() {
    if (isEmpty) return this;
    String readableString = replaceAllMapped(RegExp(r'(?<!^)(?=[A-Z])'),  (match) => ' ');

    return readableString[0].toUpperCase() + readableString.substring(1).toLowerCase();
  }
}
