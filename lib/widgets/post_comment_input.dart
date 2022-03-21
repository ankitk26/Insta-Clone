import 'package:flutter/material.dart';
import 'package:insta_clone/services/comment_service.dart';
import 'package:insta_clone/utils/constants.dart';

class PostCommentInput extends StatefulWidget {
  final String postId;
  const PostCommentInput({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  State<PostCommentInput> createState() => _PostCommentInputState();
}

class _PostCommentInputState extends State<PostCommentInput> {
  final _textController = TextEditingController();
  bool isTextEmpty = true;

  Future<void> _postComment() async {
    await CommentService().addComment(
      _textController.text,
      widget.postId,
    );
    FocusScope.of(context).unfocus();
    _textController.clear();
  }

  @override
  void initState() {
    super.initState();
    _textController.addListener(_listenEmptyText);
  }

  void _listenEmptyText() {
    if (_textController.text.isNotEmpty) {
      setState(() => isTextEmpty = false);
    } else {
      setState(() => isTextEmpty = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff222222),
      padding: const EdgeInsets.only(left: spacing / 2, right: spacing),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: textFieldDecoration.copyWith(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                hintText: "Enter comment",
              ),
            ),
          ),
          InkWell(
            onTap: _postComment,
            child: Text(
              "Post",
              style: TextStyle(
                color: Theme.of(context)
                    .primaryColor
                    .withOpacity(isTextEmpty ? 0.5 : 1),
              ),
            ),
          )
        ],
      ),
    );
  }
}
