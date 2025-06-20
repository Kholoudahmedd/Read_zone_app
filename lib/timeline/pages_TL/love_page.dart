// import 'package:flutter/material.dart';
// import '../model_TL/model_post.dart';
// import '../model_TL/api_service.dart';

// class LovePage extends StatefulWidget {
//   final PostModel post;

//   const LovePage({Key? key, required this.post}) : super(key: key);

//   @override
//   _LovePageState createState() => _LovePageState();
// }

// class _LovePageState extends State<LovePage> {
//   late Future<List<Liker>> _likersFuture;

//   @override
//   void initState() {
//     super.initState();
//     _likersFuture = ApiService.getPostLikers(widget.post.id);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('People Who Loved This Post')),
//       body: FutureBuilder<List<Liker>>(
//         future: _likersFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Failed to load loved users.'));
//           }

//           final likers = snapshot.data ?? [];

//           if (likers.isEmpty) {
//             return const Center(child: Text('No one has loved this post yet.'));
//           }

//           return ListView.builder(
//             itemCount: likers.length,
//             itemBuilder: (context, index) {
//               final user = likers[index];
//               return Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 child: Row(
//                   children: [
//                     Stack(
//                       clipBehavior: Clip.none,
//                       children: [
//                         CircleAvatar(
//                           radius: 30,
//                           backgroundImage: AssetImage(user.profileImageUrl),
//                         ),
//                         Positioned(
//                           bottom: -3,
//                           right: -3,
//                           child: Icon(
//                             Icons.favorite,
//                             color: Theme.of(context).secondaryHeaderColor,
//                             size: 31,
//                           ),
//                         ),
//                         Positioned(
//                           bottom: -1,
//                           right: -1,
//                           child: const Icon(
//                             Icons.favorite,
//                             color: Colors.red,
//                             size: 25,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(width: 10),
//                     Text(
//                       user.username,
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(height: 10),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:read_zone_app/themes/colors.dart';
import '../model_TL/model_post.dart';
import '../model_TL/api_service.dart';

class LovePage extends StatefulWidget {
  final PostModel post;

  const LovePage({Key? key, required this.post}) : super(key: key);

  @override
  _LovePageState createState() => _LovePageState();
}

class _LovePageState extends State<LovePage> {
  late Future<List<Liker>> _likersFuture;

  @override
  void initState() {
    super.initState();
    _likersFuture = ApiService.getPostLikers(widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('People Who Loved This Post')),
      body: FutureBuilder<List<Liker>>(
        future: _likersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load loved users.'));
          }

          final likers = snapshot.data ?? [];

          if (likers.isEmpty) {
            return const Center(child: Text('No one has loved this post yet.'));
          }

          return ListView.builder(
            itemCount: likers.length,
            itemBuilder: (context, index) {
              final user = likers[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: user.profileImageUrl != null
                              ? NetworkImage(user.profileImageUrl!)
                              : AssetImage('assets/images/test.jpg')
                                  as ImageProvider,
                          // child: user.profileImageUrl == null
                          //     ? Icon(Icons.person,
                          //         size: 30, color: Colors.white)
                          //     : null,
                        ),
                        Positioned(
                          bottom: -3,
                          right: -3,
                          child: Icon(
                            Icons.favorite,
                            color: Theme.of(context).secondaryHeaderColor,
                            size: 31,
                          ),
                        ),
                        Positioned(
                          bottom: -1,
                          right: -1,
                          child: Icon(
                            Icons.favorite,
                            color: getRedColor(context),
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Text(
                      user.username,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
