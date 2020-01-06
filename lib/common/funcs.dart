import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

showAddRssDialog(context) async {
  final controller = TextEditingController();

  return await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('添加RSS订阅'),
        content: TextField(
          controller: controller,
          autofocus: true,
          autocorrect: false,
          decoration: InputDecoration(
            hintText: 'www.zhihu.com/rss'
          )
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('确定'),
            onPressed: () {
              Navigator.pop(context, controller.text);
            }
          )
        ]
      );
    }
  );
}

// class _SystemPadding extends StatelessWidget {
//   final Widget child;

//   _SystemPadding({Key key, this.child}): super(key: key);
  
//   @override
//   Widget build(BuildContext context) {
//     var mediaQuery = MediaQuery.of(context);
//     return AnimatedContainer(
//       padding: mediaQuery.viewInsets,
//       duration: const Duration(milliseconds: 300),
//       child: child
//     );
//   }
// }

const _MONTHS = const['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
var _timeReg = RegExp(r'^(\d{2})\s+(\w+)\s+(\d+)\s+(\d{2}:\d{2}:\d{2})\s+(\+\d{4})$');

DateTime _parseTimeString(timeString) {
  timeString = timeString.split(',')[1].trim();
  var m = _timeReg.firstMatch(timeString);
  if (m == null) {
    return DateTime.tryParse(timeString);
  }
  var year = m.group(3);
  var month = (_MONTHS.indexOf(m.group(2)) + 1).toString().padLeft(2, '0');
  var day = m.group(1);
  var time = m.group(4);
  var zone = m.group(5);

  timeString = '$year-$month-$day $time$zone';
  return DateTime.tryParse(timeString);
}

DateTime _getDateTime(time) {
  if (time is DateTime) {
    return time;
  }
  if (time is String) {
    return _parseTimeString(time);
  }
  if (time is int) {
    var timeStr = time.toString();
    if (timeStr.length == 13) {
      return DateTime.fromMillisecondsSinceEpoch(time);
    }
    if (timeStr.length == 15) {
      return DateTime.fromMicrosecondsSinceEpoch(time);
    }
  }
  return null;
}

String pubDateFormat(time) {
  var dt = _getDateTime(time);
  if (dt == null) {
    return '';
  }

  var now = DateTime.now();
  now = DateTime(now.year, now.month, now.day, 23, 59, 59);
  var diffDays = now.difference(dt).inDays;

  if (diffDays == 0) {
    return '今天 ' + formatDate(dt, [HH, ':', nn]);
  }

  if (diffDays == 1) {
    return '昨天 ' + formatDate(dt, [HH, ':', nn]);
  }

  if (diffDays == 2) {
    return '前天 ' + formatDate(dt, [HH, ':', nn]);
  }

  if (dt.year == now.year) {
    return formatDate(dt, [mm, '月', dd, '日', ' ', HH, ':', nn]);
  }

  return formatDate(dt, [yyyy, '年', mm, '月', dd, '日', ' ', HH, ':', nn]);
}
