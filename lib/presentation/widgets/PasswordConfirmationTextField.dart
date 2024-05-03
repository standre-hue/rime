import 'package:flutter/material.dart';

class PasswordConfirmationTextField extends StatefulWidget {
  String title;
  TextEditingController controller;
  //Icon icon;
  PasswordConfirmationTextField({
    Key? key,
    required this.title,
    required this.controller,
  }) : super(key: key);

  @override
  _PasswordConfirmationTextFieldState createState() =>
      _PasswordConfirmationTextFieldState();
}

class _PasswordConfirmationTextFieldState extends State<PasswordConfirmationTextField> {

  final  _controller = TextEditingController();

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
            controller: _controller,
            validator: (value) {
              if (value == null || value.isEmpty  ) {
                return 'La confirmation du mot de passe est obligatoire';
              }

              if (value != widget.controller.text) {
                return 'Les mots de passe ne correspondent pas';
              }
              return null;
            },
            decoration: InputDecoration(
              //hintText: "Userename",
              suffixIcon: IconButton(
                  onPressed: () {
                    //print("hello");
                    _controller.clear();
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
