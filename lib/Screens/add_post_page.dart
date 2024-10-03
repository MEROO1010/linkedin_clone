import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkedin_clone/Services/firestore_methods';
import 'package:linkedin_clone/screens/home_screen.dart';
import 'package:linkedin_clone/utils/utils.dart';

class AddPost extends StatefulWidget {
  final userdata;
  const AddPost({super.key, required this.userdata});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  Uint8List? _file;
  bool isFile = false;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  _selectImage(BuildContext parentContext) async {
    return showDialog(
        context: parentContext,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select image'),
            children: [
              SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text('Take a photo'),
                  onPressed: () async {
                    Navigator.pop(context);
                    final pickedFile = await _imagePicker.pickImage(
                        source: ImageSource.camera);
                    setState(() {
                      isFile = true;
                      _file = pickedFile!.bytes;
                    });
                  }),
              SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text('Choose from Gallery'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    final pickedFile = await _imagePicker.pickImage(
                        source: ImageSource.gallery);
                    setState(() {
                      isFile = true;
                      _file = pickedFile!.bytes;
                    });
                  }),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.cancel_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          },
        ),
        title: Container(
          alignment: Alignment.bottomRight,
          child: TextButton(
            child: const Text('Post', style: TextStyle(color: Colors.blue)),
            onPressed: () async {
              String res = "Some error";
              setState(() {
                isLoading = true;
              });
              if (isFile) {
                res = await FireStoreMethods().uploadPost(
                    _descriptionController.text.toString(),
                    _file!,
                    widget.userdata['uid'],
                    widget.userdata['name'],
                    widget.userdata['photoUrl']);
              } else {
                res = await FireStoreMethods().uploadPostWithoutPhoto(
                    _descriptionController.text.toString(),
                    widget.userdata['uid'],
                    widget.userdata['name'],
                    widget.userdata['photoUrl']);
              }
              if (res == "success") {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const HomeScreen()));
              } else {
                showSnackBar(res, context);
              }
              setState(() {
                isLoading = false;
              });
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              (isLoading) ? const LinearProgressIndicator() : const SizedBox(),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(widget.userdata['photoUrl']),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    margin: const EdgeInsets.all(5),
                    child: TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 50,
                      minLines: 3,
                    ),
                  )
                ],
              ),
              (_file != null)
                  ? Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Image.memory(
                        _file!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
      bottomNavigationBar: TextButton(
          onPressed: () => _selectImage(context),
          child: const Text('Add photo')),
    );
  }
}

extension on XFile {
  Uint8List? get bytes => null;
}
