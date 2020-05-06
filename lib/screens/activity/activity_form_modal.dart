import 'package:feed_app/models/activity.dart';
import 'package:flutter/material.dart';

class ActivityFormModal extends StatefulWidget {
  final Activity activity;

  const ActivityFormModal({
    Key key,
    this.activity,
  }) : super(key: key);

  @override
  _ActivityFormModalState createState() => _ActivityFormModalState();
}

class _ActivityFormModalState extends State<ActivityFormModal> {
  final _whatController = TextEditingController();
  final _whenController = TextEditingController();
  final _whereController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _buildActivityForm(),
    );
  }

  Widget _buildActivityForm() {
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
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        controller: _whatController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'What you want to do?',
                        ),
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        autovalidate: true,
                        // validator: (_) {
                        //   return !state.isEmailValid ? '' : null;
                        // },
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        controller: _whereController,
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Where?',
                        ),
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        autovalidate: true,
                        // validator: (_) {
                        //   return !state.isEmailValid ? '' : null;
                        // },
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        controller: _whenController,
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: 'When?',
                        ),
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        autovalidate: true,
                        // validator: (_) {
                        //   return !state.isEmailValid ? '' : null;
                        // },
                      ),
                      const SizedBox(height: 20.0),
                      RaisedButton(
                        onPressed: () {},
                        child: Text('Add Activity'),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
