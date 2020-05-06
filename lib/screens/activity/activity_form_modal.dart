import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:feed_app/models/activity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

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
  final _whatTextController = TextEditingController();
  final _whenTextController = TextEditingController();
  final _whereTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool get _isEditing => widget.activity != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _whatTextController.text = widget.activity.what;
      _whereTextController.text = widget.activity.where;
      _whenTextController.text = widget.activity.when.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
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
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        controller: _whatTextController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'What you want to do?',
                          labelText: 'What?',
                        ),
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        autovalidate: true,
                        validator: (value) {
                          return value.isEmpty ? 'Field is required' : null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: _whereTextController,
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Pick a cool place',
                          labelText: 'Where?',
                        ),
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        autovalidate: true,
                        validator: (value) {
                          return value.isEmpty ? 'Field is required' : null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      DateTimeField(
                        decoration: InputDecoration(
                          hintText: 'When will it be?',
                          labelText: 'When?',
                        ),
                        format: DateFormat('yyyy-MM-dd HH:mm'),
                        initialValue: widget.activity?.when,
                        resetIcon: null,
                        autocorrect: false,
                        autovalidate: true,
                        validator: (value) {
                          return value == null ? 'Field is required' : null;
                        },
                        onShowPicker: (context, currentValue) async {
                          final date = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100));
                          if (date != null) {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  currentValue ?? DateTime.now()),
                            );
                            return DateTimeField.combine(date, time);
                          } else {
                            return currentValue;
                          }
                        },
                        controller: _whenTextController,
                      ),
                      const SizedBox(height: 20.0),
                      RaisedButton(
                        color: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: _save,
                        child: Text(
                          _isEditing ? 'Update' : 'Add Activity',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    if (_formKey.currentState.validate()) {
      final activity = Activity(
        id: widget.activity?.id ?? Uuid().v1(),
        who: "user-id",
        what: _whatTextController.text,
        where: _whereTextController.text,
        when: DateTime.parse(_whenTextController.text),
      );

      Navigator.of(context).pop(activity);
    }
  }
}
