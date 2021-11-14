extension OrdinalConversion on int {
  String toOrdinal() {
    if (this >= 11 && this <= 13) {
      return 'th';
    }

    switch (this % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
