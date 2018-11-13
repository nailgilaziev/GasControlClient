String relativeTime(DateTime time) {
  var n = DateTime.now();
  var diff = n.difference(time);
  var days = diff.inDays;
  if (days >= 5) {
    return '$days дней\nназад';
  }
  if (days >= 2) {
    return '$days дня\nназад';
  }
  if (days >= 1) {
    var hours = diff.inHours - 24;
    return '$days д. $hours ч.\nназад';
  }
  var hours = diff.inHours;
  if (hours >= 1) {
    var minutes = diff.inMinutes - hours * 60;
    return '$hours ч. $minutes м.\nназад';
  }
  var minutes = diff.inMinutes;
  if (minutes == 0) return 'менее минуты\nназад';
  return '$minutes мин\nназад';
}

String gapMessage(Duration gap) {
  if (gap == null) return null;
  if (gap.inDays > 0)
    return 'Длительный перерыв в подаче показаний: ${gap.inDays} д.';
  if (gap.inHours > 0) return 'Перерыв в подаче показаний: ${gap.inHours} ч.';
  if (gap.inMinutes > 20)
    return 'Небольшой перерыв в подаче показаний: ${gap.inMinutes} мин';
  return null;
}
