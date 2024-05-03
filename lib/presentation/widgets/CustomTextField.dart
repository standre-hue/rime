import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  String title;
  TextEditingController controller;
  String? Function(String? value) validator;
  //Icon icon;
  CustomTextField(
      {Key? key,
      required this.title,
      required this.controller,
      required this.validator})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                widget.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Spacer()
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            decoration: InputDecoration(
              //hintText: "Userename",
              suffixIcon: IconButton(
                  onPressed: () {
                    //print("hello");
                    widget.controller.clear();
                  },
                  icon: Icon(Icons.clear)),
              //icon: widget.icon,
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                    width: 3,
                    color: Color.fromARGB(255, 207, 201, 201)), //<-- SEE HERE
              ),
            ),
          )
        ],
      ),
    );
  }
}
