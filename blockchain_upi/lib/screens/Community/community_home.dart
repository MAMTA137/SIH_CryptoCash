import 'package:blockchain_upi/screens/community/detailedcomm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

// class CommunityHome extends StatelessWidget {
//   const CommunityHome({super.key});

//   /*List<Map<String,dynamic>> data = [
//     {
//       "time":DateTime(2000),
//       "pfp":"",
//       "by":"Zeeshan",
//       "comments":[
//         {
//           "by":"Zeeshan",
//           "time": DateTime(2002),
//           "message":"This is Comment",
//           "senderPicUrl": "",
//           "replies":[
//             {
//               "by":"User1",
//               "reply":"Reply Message1",
//             },
//             {
//               "by":"User2",
//               "reply":"Reply Message2",
//             },
//             {
//               "by":"User3",
//               "reply":"Reply Message3",
//             },
//           ],
//         },
//         {
//           "by":"Zeeshan",
//           "time": DateTime(2002),
//           "message":"This is Comment",
//           "senderPicUrl": "",
//           "replies":[
//             {
//               "by":"User1",
//               "reply":"Reply Message1",
//             },
//             {
//               "by":"User2",
//               "reply":"Reply Message2",
//             },
//             {
//               "by":"User3",
//               "reply":"Reply Message3",
//             },
//           ],
//         },
//       ],
//       "title":"Post Title",
//       "descr":"This is the Description of Post",
//       "ups":2,
//       "downs":2,
//       "postUrl":"https://m.foolcdn.com/media/dubs/images/how-blockchain-works-infographic.width-880.png"
//     },
//     {
//       "time":DateTime(2000),
//       "pfp":"",
//       "by":"Zeeshan",
//       "comments":[
//         {
//           "by":"Zeeshan",
//           "time": DateTime(2002),
//           "message":"This is Comment",
//           "senderPicUrl": "",
//           "replies":[
//             {
//               "by":"User1",
//               "reply":"Reply Message1",
//             },
//             {
//               "by":"User2",
//               "reply":"Reply Message2",
//             },
//             {
//               "by":"User3",
//               "reply":"Reply Message3",
//             },
//           ],
//         },
//         {
//           "by":"Zeeshan",
//           "time": DateTime(2002),
//           "message":"This is Comment",
//           "senderPicUrl": "",
//           "replies":[
//             {
//               "by":"User1",
//               "reply":"Reply Message1",
//             },
//             {
//               "by":"User2",
//               "reply":"Reply Message2",
//             },
//             {
//               "by":"User3",
//               "reply":"Reply Message3",
//             },
//           ],
//         },
//       ],
//       "title":"Post Title",
//       "descr":"This is the Description of Post",
//       "ups":2,
//       "downs":2,
//       "postUrl":"https://m.foolcdn.com/media/dubs/images/how-blockchain-works-infographic.width-880.png"
//     },
//     {
//       "time":DateTime(2000),
//       "pfp":"",
//       "by":"Zeeshan",
//       "comments":[
//         {
//           "by":"Zeeshan",
//           "time": DateTime(2002),
//           "message":"This is Comment",
//           "senderPicUrl": "",
//           "replies":[
//             {
//               "by":"User1",
//               "reply":"Reply Message1",
//             },
//             {
//               "by":"User2",
//               "reply":"Reply Message2",
//             },
//             {
//               "by":"User3",
//               "reply":"Reply Message3",
//             },
//           ],
//         },
//         {
//           "by":"Zeeshan",
//           "time": DateTime(2002),
//           "message":"This is Comment",
//           "senderPicUrl": "",
//           "replies":[
//             {
//               "by":"User1",
//               "reply":"Reply Message1",
//             },
//             {
//               "by":"User2",
//               "reply":"Reply Message2",
//             },
//             {
//               "by":"User3",
//               "reply":"Reply Message3",
//             },
//           ],
//         },
//       ],
//       "title":"Post Title",
//       "descr":"This is the Description of Post",
//       "ups":2,
//       "downs":2,
//       "postUrl":"https://m.foolcdn.com/media/dubs/images/how-blockchain-works-infographic.width-880.png"
//     },
//   ];*/

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text("Community"),
//         ),
//         body: StreamBuilder(
//             stream: FirebaseFirestore.instance
//                 .collection("Posts")
//                 .doc("Posts")
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const CircularProgressIndicator();
//               }
//               final data = snapshot.data!.data()!["posts"];
//               return ListView.builder(
//                   itemCount: data.length,
//                   itemBuilder: (context, index) {
//                     final postData = data[index];
//                     Timestamp t = postData['time'];
//                     return InkWell(
//                       splashFactory: NoSplash.splashFactory,
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => DetailedComm(
//                               data: postData,
//                               index: index,
//                             ),
//                           ),
//                         );
//                       },
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               SizedBox(
//                                 width: size.width * 0.04,
//                               ),
//                               CircleAvatar(
//                                 radius: size.width * 0.055,
//                                 child: postData['pfp'] == ""
//                                     ? const Icon(Icons.person)
//                                     : Image.network(
//                                         postData['pfp'],
//                                         fit: BoxFit.fill,
//                                       ),
//                               ),
//                               SizedBox(
//                                 width: size.width * 0.035,
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     postData['title'],
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                         fontSize: size.width * 0.04,
//                                         fontWeight: FontWeight.bold),
//                                     textAlign: TextAlign.left,
//                                   ),
//                                   Text(
//                                     "Posted by ${postData['by']}",
//                                     style:
//                                         TextStyle(color: Colors.grey.shade600),
//                                   ),
//                                 ],
//                               ),
//                               const Spacer(),
//                               Text(
//                                 timeago.format(postData['time'].toDate()),
//                                 style: TextStyle(color: Colors.grey.shade600),
//                               ),
//                               const Spacer(),
//                             ],
//                           ),
//                           SizedBox(
//                             height: size.height * 0.015,
//                           ),
//                           SizedBox(
//                             width: size.width,
//                             height: size.height * 0.3,
//                             child: postData['postUrl'] == ''
//                                 ? const Placeholder()
//                                 : Hero(
//                                     tag: postData["postUrl"],
//                                     child: Image.network(
//                                       postData['postUrl'],
//                                       fit: BoxFit.cover,
//                                     )),
//                           ),
//                           SizedBox(height: size.height * 0.01),
//                           Padding(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: size.width * 0.03),
//                             child: Text(
//                               postData["descr"],
//                               style: TextStyle(fontSize: size.width * 0.04),
//                             ),
//                           ),
//                           SizedBox(
//                             height: size.height * 0.01,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               SizedBox(
//                                 width: size.width * 0.04,
//                               ),
//                               InkWell(
//                                 splashFactory: NoSplash.splashFactory,
//                                 onTap: () async {
//                                   final get = await FirebaseFirestore.instance
//                                       .collection("Posts")
//                                       .doc("Posts")
//                                       .get();
//                                   List posts = get.data()!["posts"];
//                                   final post = posts[index];
//                                   post['ups'] += 1;
//                                   posts.removeAt(index);
//                                   posts.insert(index, post);
//                                   await FirebaseFirestore.instance
//                                       .collection("Posts")
//                                       .doc("Posts")
//                                       .update({"posts": posts});
//                                 },
//                                 child: const Icon(Icons.arrow_upward),
//                               ),
//                               SizedBox(
//                                 width: size.width * 0.02,
//                               ),
//                               Text(
//                                 postData['ups'].toString(),
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               SizedBox(
//                                 width: size.width * 0.03,
//                               ),
//                               InkWell(
//                                 splashFactory: NoSplash.splashFactory,
//                                 onTap: () async {
//                                   final get = await FirebaseFirestore.instance
//                                       .collection("Posts")
//                                       .doc("Posts")
//                                       .get();
//                                   List posts = get.data()!["posts"];
//                                   final post = posts[index];
//                                   if (post['ups'] == 0) {
//                                     return;
//                                   }
//                                   post['ups'] -= 1;
//                                   posts.removeAt(index);
//                                   posts.insert(index, post);
//                                   await FirebaseFirestore.instance
//                                       .collection("Posts")
//                                       .doc("Posts")
//                                       .update({"posts": posts});
//                                 },
//                                 child: const Icon(Icons.arrow_downward),
//                               ),
//                               SizedBox(
//                                 width: size.width * 0.06,
//                               ),
//                               const Icon(Icons.message),
//                               SizedBox(
//                                 width: size.width * 0.02,
//                               ),
//                               Text(
//                                 postData['comments'].length.toString(),
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               SizedBox(
//                                 width: size.width * 0.06,
//                               ),
//                               const Icon(Icons.share),
//                               SizedBox(
//                                 width: size.width * 0.02,
//                               ),
//                               const Text(
//                                 "Share",
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                               SizedBox(
//                                 width: size.width * 0.04,
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: size.height * 0.01,
//                           ),
//                           const Divider(),
//                           SizedBox(
//                             height: size.height * 0.01,
//                           ),
//                         ],
//                       ),
//                     );
//                   });
//             }));
//   }
// }

// class CommunityHome extends StatelessWidget {
//   const CommunityHome({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // List of posts
//     final posts = [
//       {
//         'author': 'Elena Marie',
//         'time': '1 hr ago',
//         'content':
//             'How do you prepare for a job interview? I\'m a newbie, so I want to prepare myself to be better.',
//         'image': 'https://picsum.photos/id/1/400/300',
//         'likes': 3,
//         'comments': 1,
//         'shares': 123,
//       },
//       {
//         'author': 'John Doe',
//         'time': '2 hrs ago',
//         'content': 'Can someone suggest good resources for learning Flutter?',
//         'likes': 5,
//         'comments': 2,
//         'shares': 56,
//       },
//       {
//         'author': 'Jane Smith',
//         'time': '3 hrs ago',
//         'content': 'What are some tips for improving coding skills?',
//         'likes': 8,
//         'comments': 3,
//         'shares': 89,
//       },
//     ];

//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Community wisdom and support',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   // Search bar
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF2b8889).withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(Icons.search, color: const Color(0xFF2b8889)),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: TextField(
//                             decoration: InputDecoration(
//                               hintText: 'Search community, events, topic...',
//                               border: InputBorder.none,
//                               hintStyle: TextStyle(
//                                   color:
//                                       const Color(0xFF2b8889).withOpacity(0.6)),
//                             ),
//                           ),
//                         ),
//                         Icon(Icons.favorite_border,
//                             color: const Color(0xFF2b8889)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Recent Discussion Header
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   'Recent Discussions',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: const Color(0xFF2b8889),
//                   ),
//                 ),
//               ),
//             ),
//             // Posts List
//             Expanded(
//               child: ListView.builder(
//                 padding: const EdgeInsets.all(16.0),
//                 itemCount: posts.length,
//                 itemBuilder: (context, index) {
//                   final post = posts[index];
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => PostDetailPage(post: post),
//                         ),
//                       );
//                     },
//                     child: _buildDiscussionItem(post),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: 2,
//         selectedItemColor: const Color(0xFF2b8889),
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.work), label: 'My Jobs'),
//           BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Community'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//       ),
//     );
//   }

//   Widget _buildDiscussionItem(Map<String, dynamic> post) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const CircleAvatar(
//                 radius: 20,
//                 backgroundColor: Color(0xFF2b8889),
//                 child: Icon(Icons.person),
//               ),
//               const SizedBox(width: 12),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     post['author'],
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     post['time'],
//                     style: TextStyle(
//                         color: const Color(0xFF2b8889).withOpacity(0.6),
//                         fontSize: 12),
//                   ),
//                 ],
//               ),
//               const Spacer(),
//               Icon(Icons.more_horiz,
//                   color: const Color(0xFF2b8889).withOpacity(0.6)),
//             ],
//           ),
//           const SizedBox(height: 12),
//           if (post['image'] != null)
//             Padding(
//               padding: const EdgeInsets.only(bottom: 12.0),
//               child: Image.network(
//                 post['image'],
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//                 height: 200,
//               ),
//             ),
//           Text(
//             post['content'],
//             style: const TextStyle(fontSize: 14),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Icon(Icons.favorite_border,
//                   size: 20, color: const Color(0xFF2b8889)),
//               const SizedBox(width: 4),
//               Text('${post['likes']} likes',
//                   style: TextStyle(
//                       color: const Color(0xFF2b8889).withOpacity(0.6))),
//               const SizedBox(width: 16),
//               Icon(Icons.chat_bubble_outline,
//                   size: 20, color: const Color(0xFF2b8889)),
//               const SizedBox(width: 4),
//               Text('${post['comments']} comments',
//                   style: TextStyle(
//                       color: const Color(0xFF2b8889).withOpacity(0.6))),
//               const SizedBox(width: 16),
//               Icon(Icons.share, size: 20, color: const Color(0xFF2b8889)),
//               const SizedBox(width: 4),
//               Text('${post['shares']} shares',
//                   style: TextStyle(
//                       color: const Color(0xFF2b8889).withOpacity(0.6))),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class PostDetailPage extends StatelessWidget {
//   final Map<String, dynamic> post;

//   const PostDetailPage({required this.post, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Post Details'),
//         backgroundColor: const Color(0xFF2b8889),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (post['image'] != null)
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 16.0),
//                 child: Image.network(
//                   post['image'],
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                   height: 200,
//                 ),
//               ),
//             Text(
//               post['author'],
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               post['time'],
//               style: TextStyle(color: const Color(0xFF2b8889).withOpacity(0.6)),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               post['content'],
//               style: const TextStyle(fontSize: 16),
//             ),
//             const Spacer(),
//             Row(
//               children: [
//                 ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF2b8889),
//                   ),
//                   child: const Text('Like'),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF2b8889),
//                   ),
//                   child: const Text('Comment'),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF2b8889),
//                   ),
//                   child: const Text('Share'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class CommunityHome extends StatelessWidget {
  const CommunityHome({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = [
      {
        'author': 'Elena Marie',
        'time': '1 hr ago',
        'content':
            'How do you prepare for a job interview? I\'m a newbie, so I want to prepare myself to be better.',
        'image': 'https://picsum.photos/id/1/400/300',
        'likes': 3,
        'comments': 1,
        'shares': 123,
      },
      {
        'author': 'John Doe',
        'time': '2 hrs ago',
        'content': 'Can someone suggest good resources for learning Flutter?',
        'likes': 5,
        'comments': 2,
        'shares': 56,
      },
    ];

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 20, 7, 55),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Community wisdom and support',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Search bar with gradient and glossy effect
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF5B6BE4),
                          Color(0xFFE88FDA),
                          Color(0xFF563CA2)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(4, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // const Icon(Icons.search, color: Colors.white),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search community, events, topic...',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                        const Icon(Icons.favorite_border, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Recent Discussion Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recent Discussions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFE88FDA),
                  ),
                ),
              ),
            ),
            // Posts List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailPage(post: post),
                        ),
                      );
                    },
                    child: _buildDiscussionItem(post),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscussionItem(Map<String, dynamic> post) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFF5B6BE4),
                child: Icon(Icons.person),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post['author'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    post['time'],
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.more_horiz, color: Color(0xFFE88FDA)),
            ],
          ),
          const SizedBox(height: 12),
          if (post['image'] != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Image.network(
                post['image'],
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
            ),
          Text(
            post['content'],
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.favorite_border,
                  size: 20, color: Color(0xFFE88FDA)),
              const SizedBox(width: 4),
              Text('${post['likes']} likes',
                  style: const TextStyle(color: Color(0xFFE88FDA))),
              const SizedBox(width: 16),
              const Icon(Icons.chat_bubble_outline,
                  size: 20, color: Color(0xFFE88FDA)),
              const SizedBox(width: 4),
              Text('${post['comments']} comments',
                  style: const TextStyle(color: Color(0xFFE88FDA))),
              const SizedBox(width: 16),
              const Icon(Icons.share, size: 20, color: Color(0xFFE88FDA)),
              const SizedBox(width: 4),
              Text('${post['shares']} shares',
                  style: const TextStyle(color: Color(0xFFE88FDA))),
            ],
          ),
        ],
      ),
    );
  }
}

class PostDetailPage extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostDetailPage({required this.post, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context)
                .pop(); // Navigates back to the previous screen
          },
        ),
        title: const Text(
          'Post Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF563CA2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post['image'] != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Image.network(
                  post['image'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
            Text(
              post['author'],
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              post['time'],
              style: const TextStyle(color: Color(0xFFE88FDA)),
            ),
            const SizedBox(height: 16),
            Text(
              post['content'],
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const Spacer(),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B6BE4),
                  ),
                  child:
                      const Text('Like', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE88FDA),
                  ),
                  child: const Text('Comment'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF563CA2),
                  ),
                  child: const Text('Share',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
