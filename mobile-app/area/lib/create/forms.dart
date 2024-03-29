import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextForm extends StatefulWidget {
  final String name;
  final String widgetType;
  final Map<String, dynamic> resultOfForm;
  const TextForm(this.name, this.widgetType, this.resultOfForm, {super.key});

  @override
  State<TextForm> createState() => _TextState();
}

OutlineInputBorder getOutlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: const BorderSide(color: Colors.white, width: 1),
  );
}

class _TextState extends State<TextForm> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Card(
        color: Colors.black,
        child: TextFormField(
          onChanged: (value) {
            widget.resultOfForm[widget.name] = value.toString();
          },
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            counterStyle: TextStyle(color: Colors.white),
            helperStyle: TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.white, width: 1),
            ),
            border: getOutlineInputBorder(),
            focusedBorder: getOutlineInputBorder(),
            fillColor: Colors.white,
            // hintColor: ,
          ),
          cursorColor: Colors.white,
          validator: (value) {
            if (value.toString().isEmpty) {
              return 'Ajoutez un texte';
            } else {
              widget.resultOfForm[widget.name] = value.toString();
              return null;
            }
          },
          maxLength: 140,
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////

class DateTimeForm extends StatefulWidget {
  final String name;
  final String widgetType;
  final Map<String, dynamic> resultOfForm;
  const DateTimeForm(this.name, this.widgetType, this.resultOfForm,
      {super.key});

  @override
  State<DateTimeForm> createState() => _DateTimeFormState();
}

class _DateTimeFormState extends State<DateTimeForm> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Container(
      width: size.width,
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Card(
        color: Colors.black,
        child:
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.black),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.white)
                      )
                  )
              ),
            child: Text(style: TextStyle(color: Colors.white,), (() {

              if(widget.resultOfForm[widget.name] == null){
                return "Select Date";
              } else {
                return widget.resultOfForm[widget.name].toString();
              }
              })()),
            onPressed: () async {
              DateTime? date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(5000),
              );
              if (date != null) {
                setState(() {
                  widget.resultOfForm[widget.name] = date;
                });
              }
            }
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////

class TimeForm extends StatefulWidget {
  final String name;
  final String widgetType;
  final Map<String, dynamic> resultOfForm;
  const TimeForm(this.name, this.widgetType, this.resultOfForm, {super.key});

  @override
  State<TimeForm> createState() => _TimeFormState();
}

class _TimeFormState extends State<TimeForm> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

//////////////////////////////////////////////////////////////////////////

class EmailForm extends StatefulWidget {
  final String name;
  final String widgetType;
  final Map<String, dynamic> resultOfForm;
  const EmailForm(this.name, this.widgetType, this.resultOfForm, {super.key});

  @override
  State<EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Card(
        color: Colors.black,
        child: TextFormField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            counterStyle: TextStyle(color: Colors.white),
            helperStyle: TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.white, width: 1),
            ),
            border: getOutlineInputBorder(),
            focusedBorder: getOutlineInputBorder(),
            fillColor: Colors.white,
          ),
          cursorColor: Colors.white,
          validator: (value) {
            const pattern =
                r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
            final regExp = RegExp(pattern);
            if (value.toString().isEmpty) {
              return 'Enter an email';
            } else if (!regExp.hasMatch(value.toString())) {
              return 'Enter a valid email';
            } else {
              widget.resultOfForm[widget.name] = value.toString();
              return null;
            }
          },
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            widget.resultOfForm[widget.name] = value.toString();
          },
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////

class NumberForm extends StatefulWidget {
  final String name;
  final String widgetType;
  final Map<String, dynamic> resultOfForm;
  const NumberForm(this.name, this.widgetType, this.resultOfForm, {super.key});

  @override
  State<NumberForm> createState() => _NumberFormState();
}

class _NumberFormState extends State<NumberForm> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Card(
        color: Colors.black,
        child: TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            widget.resultOfForm[widget.name] = value.toString();
          },
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            counterStyle: TextStyle(color: Colors.white),
            helperStyle: TextStyle(color: Colors.white),
            enabledBorder: getOutlineInputBorder(),
            border: getOutlineInputBorder(),
            focusedBorder: getOutlineInputBorder(),
            fillColor: Colors.white,
            // hintColor: ,
          ),
          cursorColor: Colors.white,
          validator: (value) {
            if (value.toString().isEmpty) {
              return 'Ajoutez un texte';
            } else {
              widget.resultOfForm[widget.name] = value.toString();
              return null;
            }
          },
          maxLength: 140,
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////

class UrlForm extends StatefulWidget {
  final String name;
  final String widgetType;
  final Map<String, dynamic> resultOfForm;
  const UrlForm(this.name, this.widgetType, this.resultOfForm, {super.key});

  @override
  State<UrlForm> createState() => _UrlFormsStat();
}

class _UrlFormsStat extends State<UrlForm> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Card(
        color: Colors.black,
        child: TextFormField(
          keyboardType: TextInputType.url,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            widget.resultOfForm[widget.name] = value.toString();
          },
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            counterStyle: TextStyle(color: Colors.white),
            helperStyle: TextStyle(color: Colors.white),
            enabledBorder: getOutlineInputBorder(),
            border: getOutlineInputBorder(),
            focusedBorder: getOutlineInputBorder(),
            fillColor: Colors.white,
            // hintColor: ,
          ),
          cursorColor: Colors.white,
          validator: (value) {
            if (Uri.tryParse(value.toString()) == null) {
              return 'Enter URL';
            } else {
              widget.resultOfForm[widget.name] = value.toString();
              return null;
            }
          },
          maxLength: 140,
        ),
      ),
    );
  }
}
