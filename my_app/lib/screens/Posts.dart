import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:my_app/models/post.dart';
import 'dart:convert';
import '../dio.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  Future<List<Post>> getPosts() async {
    Dio.Response response = await dio()
        .get('user/posts', options: Dio.Options(headers: {'auth': true}));

    List posts = json.decode(response.toString());
    return posts.map((post) => Post.fromjson(post)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Psots'),
      ),
      body: Center(
        child: FutureBuilder<List<Post>>(
          future: getPosts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    var item = snapshot.data?[index];

                    return ListTile(
                      title: Text(item?.title ?? 'No title'),
                    );
                  });
            } else if (snapshot.hasError) {
              return Text('Not post found');
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
