import 'package:flutter/material.dart';

class CommentSection extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final ValueChanged<String> onCommentChanged;
  final bool isSubmitted;

  const CommentSection({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
    required this.onCommentChanged,
    required this.isSubmitted,
  }) : super(key: key);

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  late TextEditingController _commentController;
  static String _comment = '';

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    _commentController.text = _comment;
  }

  @override
  void didUpdateWidget(CommentSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSubmitted && !oldWidget.isSubmitted) {
      _commentController.clear();
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.screenWidth * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _commentController,
        maxLines: 4,
        onChanged: (value) {
          widget.onCommentChanged(value);
          _commentController.text = value;
          _comment = value;
        },
        style: TextStyle(
          fontSize: widget.screenWidth * 0.04,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: _commentController.text.isNotEmpty ? _commentController.text : 'Write your comment here...',
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.screenWidth * 0.04),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: widget.screenHeight * 0.015,
            horizontal: widget.screenWidth * 0.03,
          ),
        ),
      ),
    );
  }
}
