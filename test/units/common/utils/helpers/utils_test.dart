import 'package:flutter_test/flutter_test.dart';
import 'package:lenses/common/utils/helpers/utils.dart';

void main() {
  group('Utils.getMonthNameByNumber', () {
    test('fullLength parent forms cover all months', () {
      final expected = {
        1: 'января',
        2: 'февраля',
        3: 'марта',
        4: 'апреля',
        5: 'мая',
        6: 'июня',
        7: 'июля',
        8: 'августа',
        9: 'сентября',
        10: 'октября',
        11: 'ноября',
        12: 'декабря',
      };
      for (final entry in expected.entries) {
        expect(Utils.getMonthNameByNumber(entry.key, fullLength: true), entry.value);
      }
    });

    test('fullLength nominative forms cover all months', () {
      final expected = {
        1: 'январь',
        2: 'февраль',
        3: 'март',
        4: 'апрель',
        5: 'май',
        6: 'июнь',
        7: 'июль',
        8: 'август',
        9: 'сентябрь',
        10: 'октябрь',
        11: 'ноябрь',
        12: 'декабрь',
      };
      for (final entry in expected.entries) {
        expect(
          Utils.getMonthNameByNumber(entry.key, parent: false, fullLength: true),
          entry.value,
        );
      }
    });

    test('short forms cover all months', () {
      expect(Utils.getMonthNameByNumber(1), 'янв.');
      expect(Utils.getMonthNameByNumber(2), 'февр.');
      expect(Utils.getMonthNameByNumber(3), 'марта');
      expect(Utils.getMonthNameByNumber(3, parent: false), 'март');
      expect(Utils.getMonthNameByNumber(4), 'апр.');
      expect(Utils.getMonthNameByNumber(5), 'мая');
      expect(Utils.getMonthNameByNumber(5, parent: false), 'май');
      expect(Utils.getMonthNameByNumber(6), 'июня');
      expect(Utils.getMonthNameByNumber(6, parent: false), 'июнь');
      expect(Utils.getMonthNameByNumber(7), 'июля');
      expect(Utils.getMonthNameByNumber(7, parent: false), 'июль');
      expect(Utils.getMonthNameByNumber(8), 'авг.');
      expect(Utils.getMonthNameByNumber(9), 'сент.');
      expect(Utils.getMonthNameByNumber(10), 'окт.');
      expect(Utils.getMonthNameByNumber(11), 'нояб.');
      expect(Utils.getMonthNameByNumber(12), 'дек.');
      expect(Utils.getMonthNameByNumber(99), 'янв.');
    });
  });

  group('Utils.weekday', () {
    test('maps weekdays', () {
      expect(Utils.weekday(DateTime(2026, 8, 3)), 'Пн'); // Monday
      expect(Utils.weekday(DateTime(2026, 8, 4)), 'Вт');
      expect(Utils.weekday(DateTime(2026, 8, 5)), 'Ср');
      expect(Utils.weekday(DateTime(2026, 8, 6)), 'Чт');
      expect(Utils.weekday(DateTime(2026, 8, 7)), 'Пт');
      expect(Utils.weekday(DateTime(2026, 8, 8)), 'Сб');
      expect(Utils.weekday(DateTime(2026, 8, 9)), 'Вс');
    });
  });

  group('DateTimeExtension.isSameDate', () {
    test('ignores time of day', () {
      final a = DateTime(2026, 8, 1, 9);
      final b = DateTime(2026, 8, 1, 23);
      final c = DateTime(2026, 8, 2);
      expect(a.isSameDate(b), isTrue);
      expect(a.isSameDate(c), isFalse);
    });
  });
}
