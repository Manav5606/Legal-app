import 'package:intl/intl.dart';

extension Date on int {
  String formatToDate() {
    return DateFormat.yMMMMd()
        .format(DateTime.fromMillisecondsSinceEpoch(this));
  }
}
