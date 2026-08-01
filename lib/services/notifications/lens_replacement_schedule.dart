import 'package:lenses/common/utils/helpers/utils.dart';
import 'package:lenses/core/lenses/models/generated/generated.dart';

/// Какая линза (или обе) попадает в ближайшее напоминание о замене.
enum ReplacementTarget { left, right, both }

/// Ближайшая дата замены и какие линзы в этот день заканчиваются.
({DateTime date, ReplacementTarget which})? nextLensReplacement(LensesPairDatesModel? pairDates) {
  if (pairDates == null || pairDates.isEmpty) {
    return null;
  }

  final leftEnd = pairDates.left?.dateEnd;
  final rightEnd = pairDates.right?.dateEnd;

  if (leftEnd != null && rightEnd != null) {
    if (leftEnd.isSameDate(rightEnd)) {
      return (date: leftEnd, which: ReplacementTarget.both);
    }
    if (leftEnd.isBefore(rightEnd)) {
      return (date: leftEnd, which: ReplacementTarget.left);
    }
    return (date: rightEnd, which: ReplacementTarget.right);
  }

  if (leftEnd != null) {
    return (date: leftEnd, which: ReplacementTarget.left);
  }
  return (date: rightEnd!, which: ReplacementTarget.right);
}
