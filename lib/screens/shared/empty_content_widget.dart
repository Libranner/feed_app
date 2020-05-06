import 'package:flutter/material.dart';

class EmptyContentWidget extends StatelessWidget {
  const EmptyContentWidget({
    Key key,
    @required this.title,
    this.message = '',
  }) : super(key: key);

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 32, color: Colors.black45),
          ),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.black45),
          )
        ],
      ),
    );
  }
}
