import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final String text;

  final bool isHover;

  final VoidCallback onTap;

  const MenuItem({
    this.text = "",
    this.isHover = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 4,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 1,
        ),
        decoration: BoxDecoration(
          color: isHover ? Color.fromRGBO(0, 0, 0, .08) : Colors.transparent,
          border: Border.all(
            width: 1,
            color: Colors.black12,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(text),
      ),
    );
  }
}
