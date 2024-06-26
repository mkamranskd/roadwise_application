import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:roadwise_application/const/app_const.dart';
import 'package:roadwise_application/features/domain/entities/user_post_data.dart';
import 'package:roadwise_application/global/style.dart';

class SinglePostCardWidget extends StatelessWidget {
  final UserPostData userPostData;

  const SinglePostCardWidget({Key? key, required this.userPostData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(userPostData.profileUrl!),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userPostData.name!,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          userPostData.headline!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    PopupMenuButton<int>(
                      icon: const Icon(CupertinoIcons.ellipsis_vertical),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            leading: Icon(Clarity.share_line,size: 15,),
                            title: Text('Share'),
                          ),
                        ),
                        const PopupMenuItem(
                          value: 2,
                          child: ListTile(
                            leading: Icon(Clarity.book_line,size: 15),
                            title: Text('Save'),
                          ),
                        ),
                        const PopupMenuItem(
                          value: 3,
                          child: ListTile(
                            leading: Icon(Clarity.eye_hide_line,size: 15),
                            title: Text('Hide'),
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        // Handle item selection here
                        switch (value) {
                          case 1:
                          // Handle Share selection
                            break;
                          case 2:
                          // Handle Save selection
                            break;
                          case 3:
                          // Handle Hide selection
                            break;
                        }
                      },
                    )

                  ],
                ),
                sizeVer(8),
                Text(
                  userPostData.description!,
                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                ),
                Text(
                  userPostData.tags!,
                  style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Image.asset(userPostData.image!),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Row(children: [
              Container(
                height: 16,
                width: 16,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.asset(
                  "assets/likes/like_icon 1.png",
                  color: Colors.white54,
                ),
              ),
              Container(
                height: 16,
                width: 16,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.asset(
                  "assets/likes/like_icon 2.png",
                  color: Colors.white,
                ),
              ),
              Container(
                height: 16,
                width: 16,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.asset("assets/likes/like_icon 3.png"),
              ),
              sizeHor(6),
              Text(
                userPostData.likes!,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const Spacer(),
              Text(
                userPostData.comments!,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              sizeHor(4),
              const Text(
                "comments",
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              sizeHor(4),
              const Text(
                "-",
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              sizeHor(4),
              Text(
                userPostData.repost!,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              )
            ]),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _rowButtons(icon: CupertinoIcons.hand_thumbsup, name: "Like"),
                _rowButtons(
                    icon: CupertinoIcons.chat_bubble_text, name: "Comment"),
                _rowButtons(icon: CupertinoIcons.repeat, name: "Repost"),
                _rowButtons(icon: Icons.send_rounded, name: "Send"),
              ],
            ),
          ),
          sizeVer(8),
          const Divider(
            thickness: 8,
          )
        ],
      ),
    );
  }

  _rowButtons({String? name, IconData? icon}) {
    return Column(
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        Text(
          "$name",
          style: const TextStyle(fontSize: 10, color: Colors.black54),
        )
      ],
    );
  }
}
