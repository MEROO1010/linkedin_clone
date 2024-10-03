import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linkedin_clone/Screens/drawer_page.dart';

import 'package:linkedin_clone/Widgets/post_card.dart';

class HomePage extends StatefulWidget {
  var userData;
  HomePage({super.key, required this.userData});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _search = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            scaffoldKey.currentState!.openDrawer();
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.userData['photoUrl']),
            ),
          ),
        ),
        centerTitle: false,
        title: ListTile(
          leading: const Icon(Icons.search),
          title: TextField(
            controller: _search,
            decoration: const InputDecoration(hintText: 'Search'),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.message),
            onPressed: () {},
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return PostCard(
                  snap: snapshot.data!.docs[index].data(),
                  usersnap: widget.userData,
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      drawer: DrawerPage(userdata: widget.userData),
    );
  }
}
