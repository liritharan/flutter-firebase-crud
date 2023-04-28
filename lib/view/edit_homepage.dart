import 'package:flutter/material.dart';

import '../services/firebase_operations.dart';
import '../model/model.dart';

class EditPage extends StatefulWidget {
  final UserModel user;

  const EditPage({Key? key, required this.user}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController? _usernameController;
  TextEditingController? _cityController;

  @override
  void initState() {
    _usernameController = TextEditingController(text: widget.user.name);
    _cityController = TextEditingController(text: widget.user.city);
    super.initState();
  }

  @override
  void dispose() {
    _usernameController!.dispose();
    _cityController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "username"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "age"),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  FirestoreHelper.update(
                    UserModel(
                        id: widget.user.id,
                        name: _usernameController!.text,
                        city: _cityController!.text),
                  ).then((value) {
                    Navigator.pop(context);
                  });
                },
                child: Container(
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Update",
                        style: TextStyle(color: Colors.white),
                      ),
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
}
