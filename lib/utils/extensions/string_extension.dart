extension StringCasingExtension on String {
  String capitalize() {
    if (isEmpty) return '';
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String capitalizeEachWord() {
    return split(' ').map((word) => word.capitalize()).join(' ');
  }
}
