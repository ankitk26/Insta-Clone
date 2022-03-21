import 'package:flutter/material.dart';
import 'package:insta_clone/models/comment_model.dart';
import 'package:insta_clone/services/comment_service.dart';
import 'package:insta_clone/utils/constants.dart';

class EditCommentScreen extends StatefulWidget {
  final CommentModel comment;
  const EditCommentScreen({Key? key, required this.comment}) : super(key: key);

  static const routeName = "/edit-comment";

  @override
  State<EditCommentScreen> createState() => _EditCommentScreenState();
}

class _EditCommentScreenState extends State<EditCommentScreen> {
  final _commentController = TextEditingController();

  @override
  void initState() {
    _commentController.text = widget.comment.text;
    super.initState();
  }

  Future<void> _updateComment() async {
    if (_commentController.text.isEmpty) return;
    await CommentService().updateComment(
      commentId: widget.comment.id,
      text: _commentController.text,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit comment"),
        actions: [
          IconButton(
            onPressed: _updateComment,
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: spacing,
          horizontal: spacing * 1.25,
        ),
        child: TextField(
          minLines: 2,
          maxLines: 4,
          controller: _commentController,
          decoration: textFieldDecoration.copyWith(
            labelText: "Comment",
          ),
        ),
      ),
    );
  }
}
