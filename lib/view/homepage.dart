import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'edit_homepage.dart';
import '../services/firebase_operations.dart';
import '../firebase_options.dart';
import '../model/model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    initFirebase();
    super.initState();
  }

  Future<void> initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Firebase CRUD"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Name"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "City"),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  FirestoreHelper.create(UserModel(
                      name: _nameController.text, city: _cityController.text));
                  // _create();
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
                        "Create",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder<List<UserModel>>(
                  stream: FirestoreHelper.read(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("some error occurred"),
                      );
                    }
                    if (snapshot.hasData) {
                      final userData = snapshot.data;
                      return Expanded(
                        child: ListView.builder(
                            itemCount: userData!.length,
                            itemBuilder: (context, index) {
                              final singleUser = userData[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: Card(
                                  elevation: 5,
                                  child: ListTile(
                                    title: Text("${singleUser.name}"),
                                    subtitle: Text("${singleUser.city}"),
                                    trailing: SizedBox(
                                      width: 60,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditPage(
                                                              user: UserModel(
                                                                  name: singleUser
                                                                      .name,
                                                                  city: singleUser
                                                                      .city,
                                                                  id: singleUser
                                                                      .id),
                                                            )));
                                              },
                                              child: const Icon(Icons.edit)),
                                          InkWell(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title:
                                                            const Text("Delete"),
                                                        content: const Text(
                                                            "Are you sure you want to delete"),
                                                        actions: [
                                                          ElevatedButton(
                                                              onPressed: () {
                                                                FirestoreHelper
                                                                        .delete(
                                                                            singleUser)
                                                                    .then(
                                                                        (value) {
                                                                  Navigator.pop(
                                                                      context);
                                                                });
                                                              },
                                                              child: const Text(
                                                                  "Delete"))
                                                        ],
                                                      );
                                                    });
                                              },
                                              child: const Icon(Icons.delete)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
