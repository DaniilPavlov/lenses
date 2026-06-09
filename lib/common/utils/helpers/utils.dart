class Utils {
  static String getMonthNameByNumber(
    int month, {
    bool parent = true,
    bool fullLength = false,
  }) {
    if (fullLength) {
      switch (month) {
        case 2:
          return parent ? 'февраля' : 'февраль';
        case 3:
          return parent ? 'марта' : 'март';
        case 4:
          return parent ? 'апреля' : 'апрель';
        case 5:
          return parent ? 'мая' : 'май';
        case 6:
          return parent ? 'июня' : 'июнь';
        case 7:
          return parent ? 'июля' : 'июль';
        case 8:
          return parent ? 'августа' : 'август';
        case 9:
          return parent ? 'сентября' : 'сентябрь';
        case 10:
          return parent ? 'октября' : 'октябрь';
        case 11:
          return parent ? 'ноября' : 'ноябрь';
        case 12:
          return parent ? 'декабря' : 'декабрь';

        case 1:
        default:
          return parent ? 'января' : 'январь';
      }
    } else {
      switch (month) {
        case 2:
          return 'февр.';
        case 3:
          return parent ? 'марта' : 'март';
        case 4:
          return 'апр.';
        case 5:
          return parent ? 'мая' : 'май';
        case 6:
          return parent ? 'июня' : 'июнь';
        case 7:
          return parent ? 'июля' : 'июль';
        case 8:
          return 'авг.';
        case 9:
          return 'сент.';
        case 10:
          return 'окт.';
        case 11:
          return 'нояб.';
        case 12:
          return 'дек.';

        case 1:
        default:
          return 'янв.';
      }
    }
  }

  static String weekday(DateTime date) {
    switch (date.weekday) {
      case 7:
        return 'Вс';
      case 1:
        return 'Пн';
      case 2:
        return 'Вт';
      case 3:
        return 'Ср';
      case 4:
        return 'Чт';
      case 5:
        return 'Пт';
      case 6:
        return 'Сб';

      default:
        return 'Пн';
    }
  }
}

extension DateTimeExtension on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
