import 'package:feed_app/models/activity.dart';
import 'package:flutter/material.dart';

class ActivityDetailModal extends StatelessWidget {
  final Activity activity;

  const ActivityDetailModal({
    Key key,
    @required this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _buildActivityDetailCard(),
    );
  }

  Widget _buildActivityDetailCard() {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            alignment: Alignment.topRight,
            children: <Widget>[
              Positioned(
                top: 0,
                right: 5,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.grey,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(width: 15.0),
                        Expanded(
                          flex: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(activity.who),
                              Text(activity.when.toString()),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Column(
                      children: <Widget>[
                        const Divider(thickness: 1.0),
                        const SizedBox(height: 5.0),
                        Text(activity.what),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: RaisedButton.icon(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () {},
                        icon: Icon(
                          Icons.check,
                        ),
                        label: Text('sas'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  /*
  
  
   */
}
