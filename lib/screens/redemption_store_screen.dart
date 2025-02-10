// import 'dart:math';

// import 'package:emotorad_assignment/utils.dart/redemption_card.dart';
// import 'package:emotorad_assignment/utils.dart/wallet_card.dart';
// import 'package:flutter/material.dart';

// class RedemptionStoreScreen extends StatefulWidget {
//   const RedemptionStoreScreen({super.key});

//   @override
//   State<RedemptionStoreScreen> createState() => _RedemptionStoreScreenState();
// }

// class _RedemptionStoreScreenState extends State<RedemptionStoreScreen> {
//   late final List _redeptionItems;

//   List<Map<String, dynamic>> generateRedemptionItems(int numberOfItems) {
//     final random = Random();
//     final redemptionItems = <Map<String, dynamic>>[];

//     for (int i = 0; i < numberOfItems; i++) {
//       final type = random.nextBool() ? "Gift Card" : "Discount Coupon";
//       final pointsRequired =
//           random.nextInt(996) + 5; // Generates between 5 and 1000 inclusive

//       redemptionItems.add({
//         "id": i + 1, // Or generate a UUID if you need truly unique IDs
//         "type": type,
//         "point-required": pointsRequired,
//       });
//     }

//     return redemptionItems;
//   }

//   @override
//   void initState() {
//     _redeptionItems = generateRedemptionItems(10);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Redemption Store',
//           style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             WalletCard(
//               pointAvailable: 100,
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Expanded(
//               child: GridView.builder(
//                 itemCount: _redeptionItems.length,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 10.0,
//                     mainAxisSpacing: 10.0,
//                     mainAxisExtent: 200),
//                 itemBuilder: (BuildContext context, int index) {
//                   return RedemptionCard(
//                       itemType: _redeptionItems[index]["type"],
//                       pointsRequired: _redeptionItems[index]["point-required"],
//                       onPressed: () {});
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:emotorad_assignment/utils.dart/redemption_card.dart';
import 'package:emotorad_assignment/utils.dart/wallet_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/coin_bloc.dart';

class RedemptionStoreScreen extends StatelessWidget {
  const RedemptionStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Redemption Store',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<CoinBloc, CoinState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                WalletCard(pointAvailable: state.coinBalance),
                const SizedBox(height: 10),
                Expanded(
                  child: GridView.builder(
                    itemCount: state.redemptionItems.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      mainAxisExtent: 200,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final item = state.redemptionItems[index];
                      return RedemptionCard(
                        itemType: item['type'],
                        pointsRequired: item['point-required'],
                        isEnabled: state.coinBalance >= item['point-required'],
                        onPressed: () => context.read<CoinBloc>().add(
                              RedeemItem(
                                item['point-required'],
                                item['type'],
                              ),
                            ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}