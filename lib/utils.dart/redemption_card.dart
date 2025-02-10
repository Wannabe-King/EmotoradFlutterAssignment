import 'dart:math';
import 'package:flutter/material.dart';

class RedemptionCard extends StatelessWidget {
  final String itemType;
  final int pointsRequired;
  final Function() onPressed;
  final bool isEnabled;
  const RedemptionCard(
      {super.key,
      required this.itemType,
      required this.pointsRequired,
      required this.onPressed,
      required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    final List<Color> itemColors = [
      Colors.blueGrey,
      Colors.redAccent,
      Colors.orangeAccent,
      Colors.pinkAccent
    ];
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: itemColors[Random().nextInt(4)]),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              itemType == "Gift Card"
                  ? Icons.card_giftcard_rounded
                  : Icons.attach_money_outlined,
              size: 100,
            ),
            Text(
              itemType,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "$pointsRequired points",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: isEnabled ? onPressed : () {},
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: isEnabled ? Colors.blue : Colors.blueGrey),
                child: Center(
                  child: Text(
                    "Redeem",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            )
          ],
        ));
    ;
  }
}
