import 'package:flutter/material.dart';

class HistoryTile extends StatelessWidget {
  final String description;
  final String timestamp;
  final String transactionType;
  final int points;
  const HistoryTile({
    super.key,
    required this.description,
    required this.timestamp,
    required this.transactionType,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      height: 80,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              color: Colors.amber,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description,
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    timestamp,
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: 100,
            color: transactionType == "credit" ? Colors.blue : Colors.redAccent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('${transactionType == "credit" ? "+" : "-"} $points',
                    style: TextStyle(fontSize: 24)),
                Text("Points", style: TextStyle(fontSize: 14)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
