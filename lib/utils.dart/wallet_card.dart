import 'package:flutter/material.dart';

class WalletCard extends StatelessWidget {
  final int pointAvailable;
  const WalletCard({super.key, required this.pointAvailable});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.amber),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.wallet,
                size: 50,
              ),
              Text(
                "Coin Balance",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
              )
            ],
          ),
          Text(
            "$pointAvailable Points",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
          )
        ],
      ),
    );
  }
}
