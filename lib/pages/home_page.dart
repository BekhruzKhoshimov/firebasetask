import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebasetask/pages/signin_page.dart';
import 'package:flutter/material.dart';

import '../model/post_model.dart';
import '../service/auth_service.dart';
import '../service/rtdb_service.dart';
import 'create_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Post> items = [];

  void _getPost() async {
    RTDBService.getPosts().then((value) => {
      setState((){
        items = value;
      }),
    });
  }

  @override
  void initState() {
    _getPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts"),
        actions: [
          IconButton(
            onPressed: (){
              AuthService.signOutUser().then((value) => {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInPage())),
              });
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return itemOfPost(items[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatePage()));
          _getPost();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget itemOfPost(Post post) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(color: Colors.grey, blurRadius: 5)
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 350,
            width: 400,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: post.imgUrl!
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              child: Text(post.title!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                            ),
                            Container(
                              padding: const EdgeInsets.all(5),
                              child: Text(post.content!),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          child: Text(post.name!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        Container(
                          alignment: Alignment.bottomRight,
                          padding: const EdgeInsets.all(5),
                          child: Text(post.date!, style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),),
                        )
                      ],
                    )
                  ],
                )
              ),
            ],
          ),
        ],
      )
    );
  }
}