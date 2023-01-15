import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/post_model.dart';
import '../service/auth_service.dart';
import '../service/rtdb_service.dart';
import '../service/store_service.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {

  TextEditingController nameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  bool isLoading = false;

  void _createPost() async {
    String name = nameController.text.trim();
    String title = titleController.text.trim();
    String content = contentController.text.trim();
    String userId = AuthService.currentUserId();
    String date = DateTime.now().toString();
    if (title.isEmpty || content.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    String? downloadUrl = await StoreService.uploadImage(_image!);

    Post post = Post(userId,name, title, content, date, downloadUrl);
    RTDBService.addPost(post).then((value) => {
      Navigator.pop(context),
    });
  }


  Future<void> uploadImage() async {
  }



  File? _image;
  final picker = ImagePicker();
  void _getImage() async {
    final pickerFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickerFile != null) {
        _image = File(pickerFile.path);
      } else {
        print("No image");
      }
    });

    setState(() {
      isLoading = false;
    });

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create post"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: (){
                    _getImage();
                  },
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: (_image == null) ?
                    const Image(
                      image: AssetImage("assets/images/img.jpg"),
                    ) :
                    Image(
                      image: FileImage(_image!),
                    ),
                  ),
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: "Name",
                  ),
                ),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: "Title",
                  ),
                ),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    hintText: "Content",
                  ),
                ),
                ElevatedButton(
                  onPressed: (){
                    _createPost();
                  },
                  child: const Text("Add post"),
                )
              ],
            ),
            (isLoading) ?
                const Center(
                  child: CircularProgressIndicator(),
                ) : const SizedBox(),
          ],
        )
      ),
    );
  }
}
