import 'package:flutter/material.dart';

class OverflowItem extends StatelessWidget {
  final String k;
  final String v;
  final double l;
  final bool kBold;
  OverflowItem({
    required this.k,
    required this.v,
    this.l = 10,
    this.kBold = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 1,
      ),
      child: Row(
        children: [
          Text(
            k,
            style: TextStyle(
              fontWeight: kBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          SizedBox(
            width: l,
          ),
          Expanded(
            child: Text(
              v,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
