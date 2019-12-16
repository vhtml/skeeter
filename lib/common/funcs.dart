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