import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:taxi_segurito_app/bloc/validators/blocValidate.dart';

class CustomTextField extends StatefulWidget {
  String hint;
  String? value;
  double marginLeft;
  double marginRight;
  double marginBotton;
  double marginTop;
  MultiValidator multiValidator;
  double heightNum;
  bool obscureText;
  _CustomTextFieldState _customTextFieldState = new _CustomTextFieldState();
  CustomTextField({
    Key? key,
    this.hint = "Campo de text",
    this.marginLeft = 50,
    this.marginRight = 50,
    this.marginTop = 5,
    this.marginBotton = 5,
    this.heightNum = 35,
    this.obscureText = false,
    required this.multiValidator,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() {
    return _customTextFieldState;
  }

  String getValue() {
    return value = _customTextFieldState.getValue();
  }

  void changeHeightTextField(double num) {
    _customTextFieldState.changeHeightTextField(num);
  }
}

class _CustomTextFieldState extends State<CustomTextField> {
  final TextEditingController valueController = TextEditingController();
  changeHeightTextField(double num) {
    setState(() {
      widget.heightNum = num;
    });
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        new Container(
          margin: new EdgeInsets.only(
              top: widget.marginTop,
              bottom: widget.marginBotton,
              left: widget.marginLeft,
              right: widget.marginRight),
          width: width,
          height: widget.heightNum,
          alignment: Alignment.bottomCenter,
          child: new TextFormField(
            obscureText: widget.obscureText,
            textCapitalization: TextCapitalization.sentences,
            validator: (value) {
              var validators = widget.multiValidator.validators;
              for (FieldValidator validator in validators) {
                if (validator.call(value) != null) {
                  changeHeightTextField(60);
                  return validator.errorText;
                } else {
                  changeHeightTextField(35);
                  return null;
                }
              }
            },
            textAlignVertical: TextAlignVertical.center,
            controller: valueController,
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 13),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              hintText: widget.hint,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(width: 2, color: Colors.grey),
              ),
              fillColor: Colors.yellow,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 0.0),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String getValue() {
    return valueController.text;
  }
}
