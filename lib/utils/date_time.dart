import 'package:intl/intl.dart';  // For formatting dates
import 'package:cloud_firestore/cloud_firestore.dart';  // For Firestore Timestamp conversions

class DateTimeUtils {
  // 1. Convert Firestore Timestamp to DateTime
  static DateTime timestampToDateTime(Timestamp timestamp) {
    return timestamp.toDate();
  }

  // 2. Convert DateTime to Firestore Timestamp
  static Timestamp dateTimeToTimestamp(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }

  // 3. Convert DateTime to formatted String
  static String formatDateTime(DateTime dateTime, {String format = 'yyyy-MM-dd HH:mm:ss'}) {
    return DateFormat(format).format(dateTime);
  }

  // 4. Parse formatted String to DateTime
  static DateTime parseDateTime(String dateTimeString, {String format = 'yyyy-MM-dd HH:mm:ss'}) {
    return DateFormat(format).parse(dateTimeString);
  }

  // 5. Convert Firestore Timestamp to formatted String
  static String timestampToFormattedString(Timestamp timestamp, {String format = 'yyyy-MM-dd HH:mm:ss'}) {
    return formatDateTime(timestampToDateTime(timestamp), format: format);
  }

  // 6. Convert DateTime to time ago (e.g., '2 hours ago')
  static String timeAgo(DateTime dateTime) {
    final Duration difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 1) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 1) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  // 7. Get the current DateTime in UTC
  static DateTime getCurrentUTC() {
    return DateTime.now().toUtc();
  }

  // 8. Convert DateTime to UTC format
  static DateTime convertToUTC(DateTime dateTime) {
    return dateTime.toUtc();
  }

  // 9. Convert UTC DateTime to local time
  static DateTime convertUTCToLocal(DateTime dateTime) {
    return dateTime.toLocal();
  }

  // 10. Check if DateTime is today
  static bool isToday(DateTime dateTime) {
    final DateTime now = DateTime.now();
    return dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day;
  }

  // 11. Check if DateTime is within the past 24 hours
  static bool isWithin24Hours(DateTime dateTime) {
    final DateTime now = DateTime.now();
    return now.difference(dateTime).inHours < 24;
  }

  // 12. Get the difference between two DateTimes in readable format
  static String getDifferenceReadable(DateTime dateTime1, DateTime dateTime2) {
    final Duration diff = dateTime1.difference(dateTime2);
    if (diff.inDays > 0) {
      return '${diff.inDays} days';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} hours';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} minutes';
    } else {
      return '${diff.inSeconds} seconds';
    }
  }


  // 1. Convert DateTime to full DateTime string (e.g., "2024-09-30 14:45:32")
  static String formatFullDateTime(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  // 2. Convert DateTime to Date only (e.g., "2024-09-30")
  static String formatDateOnly(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  // 3. Convert DateTime to time only (e.g., "14:45")
  static String formatTimeOnly(DateTime dateTime) {
  return DateFormat('HH:mm').format(dateTime);
  }

  // 4. Convert DateTime to hour and minute only (e.g., "14:45")
  static String formatHourMinute(DateTime dateTime) {
  return DateFormat('HH:mm').format(dateTime);
  }

  // 5. Convert DateTime to hour, minute, and second (e.g., "14:45:32")
  static String formatHourMinuteSecond(DateTime dateTime) {
  return DateFormat('HH:mm:ss').format(dateTime);
  }

  // 6. Convert DateTime to 12-hour format with AM/PM (e.g., "02:45 PM")
  static String format12Hour(DateTime dateTime) {
  return DateFormat('hh:mm a').format(dateTime);
  }

  // 7. Convert DateTime to 24-hour format (e.g., "14:45")
  static String format24Hour(DateTime dateTime) {
  return DateFormat('HH:mm').format(dateTime);
  }

  // 8. Format DateTime as "dd-MM-yyyy" (e.g., "30-09-2024")
  static String formatDDMMYYYY(DateTime dateTime) {
  return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  // 9. Format DateTime as "yyyy/MM/dd" (e.g., "2024/09/30")
  static String formatYYYYMMDDWithSlashes(DateTime dateTime) {
  return DateFormat('yyyy/MM/dd').format(dateTime);
  }

  // 10. Format DateTime as "dd/MM/yyyy" (e.g., "30/09/2024")
  static String formatDDMMYYYYWithSlashes(DateTime dateTime) {
  return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  // 11. Format DateTime as "MM/dd/yyyy" (e.g., "09/30/2024")
  static String formatMMDDYYYY(DateTime dateTime) {
  return DateFormat('MM/dd/yyyy').format(dateTime);
  }

  // 12. Format DateTime as "MMM dd, yyyy" (e.g., "Sep 30, 2024")
  static String formatMonthDayYear(DateTime dateTime) {
  return DateFormat('MMM dd, yyyy').format(dateTime);
  }

  // 13. Get day only (e.g., "Monday")
  static String formatDayOnly(DateTime dateTime) {
  return DateFormat('EEEE').format(dateTime);
  }

  // 14. Get short day name (e.g., "Mon")
  static String formatShortDayOnly(DateTime dateTime) {
  return DateFormat('EEE').format(dateTime);
  }

  // 15. Get month only (e.g., "September")
  static String formatMonthOnly(DateTime dateTime) {
  return DateFormat('MMMM').format(dateTime);
  }

  // 16. Get day and month (e.g., "30 Sep")
  static String formatDayMonth(DateTime dateTime) {
  return DateFormat('dd MMM').format(dateTime);
  }

  // 17. Get day of the month (e.g., "30")
  static String formatDayOfMonth(DateTime dateTime) {
  return DateFormat('dd').format(dateTime);
  }

  // 18. Format DateTime as ISO 8601 string (e.g., "2024-09-30T14:45:32.000Z")
  static String formatISO8601(DateTime dateTime) {
  return dateTime.toIso8601String();
  }

  // 19. Convert DateTime to Unix timestamp (seconds since epoch)
  static int formatToUnixTimestamp(DateTime dateTime) {
  return dateTime.toUtc().millisecondsSinceEpoch ~/ 1000;
  }

  // 20. Parse Unix timestamp to DateTime
  static DateTime fromUnixTimestamp(int timestamp) {
  return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
  }

  // 21. Parse string to DateTime with format (e.g., "yyyy-MM-dd")
  static DateTime parseFromString(String dateStr, String format) {
  return DateFormat(format).parse(dateStr);
  }

}
