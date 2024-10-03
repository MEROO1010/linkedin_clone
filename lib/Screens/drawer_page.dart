import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkedin_clone/Screens/login_screen.dart';

class DrawerPage extends StatefulWidget {
  final userdata;

  const DrawerPage({super.key, required this.userdata});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  Uint8List? _file;
  bool isFile = false;
  final ImagePicker _imagePicker = ImagePicker();

  selectImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _file = pickedFile!.bytes;
      isFile = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Stack(children: [
              UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(widget.userdata['photoUrl']),
                  ),
                  accountName: Text(widget.userdata['name']),
                  accountEmail: Text(widget.userdata['email'])),
              Positioned(
                bottom: 70,
                left: 60,
                child: IconButton(
                  onPressed: selectImage,
                  icon: const Icon(Icons.add_a_photo),
                ),
              )
            ]),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const LoginScreen()));
                },
                child: const Text('Logout'))
          ],
        ),
      ),
    );
  }
}

extension on XFile {
  Uint8List? get bytes => null;
}
