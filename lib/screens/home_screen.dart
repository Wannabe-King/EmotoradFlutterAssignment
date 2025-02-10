// import 'dart:math';
// import 'package:emotorad_assignment/utils.dart/scratch_card.dart';
// import 'package:emotorad_assignment/utils.dart/wallet_card.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:intl/intl.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int coinBalance = 1000;
//   DateTime? lastScratchTime;
//   bool isScratchable = true;
//   String scratchMessage = "You earned ??? coins!";
//   int? lastReward;

//   void scratchCard() {
//     if (!isScratchable) return;

//     final random = Random();
//     int reward = 50 + random.nextInt(451); // Random reward between 50 and 500
//     Timer(Duration(seconds: 5), () {
//       setState(() {
//         isScratchable = false;
//       });
//     });
//     setState(() {
//       lastReward = reward;
//       coinBalance += reward;
//       lastScratchTime = DateTime.now();
//       scratchMessage = "You earned $reward coins!";
//     });

//     // Enable the scratch card after one hour
//     Timer(Duration(hours: 1), () {
//       setState(() {
//         isScratchable = true;
//         scratchMessage = "You earned ??? coins!";
//       });
//     });
//   }

//   String formatTime(DateTime time) {
//     final DateFormat formatter =
//         DateFormat('h:mm a'); // 12-hour format with AM/PM
//     return formatter.format(time);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Scratch Card App',
//           style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             WalletCard(pointAvailable: coinBalance),
//             SizedBox(height: 20),
//             if (isScratchable)
//               Scratcher(
//                 brushSize: 30,
//                 threshold: 50,
//                 color: Colors.grey,
//                 text: 'Scratch to reveal your reward!',
//                 textStyle: TextStyle(
//                     fontSize: 20,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold),
//                 onScratchComplete: () => scratchCard(),
//                 child: Container(
//                   width: 400,
//                   height: 500,
//                   decoration: BoxDecoration(
//                     color: Colors.blue,
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Center(
//                     child: Text(
//                       scratchMessage,
//                       style:
//                           TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               ),
//             if (!isScratchable)
//               Container(
//                 width: 400,
//                 height: 500,
//                 decoration: BoxDecoration(color: Colors.grey),
//                 child: Center(
//                   child: Text(
//                     "Scratch Card Not Available Yet !!!",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                         fontSize: 20,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             SizedBox(
//               height: 20,
//             ),
//             if (!isScratchable && lastScratchTime != null)
//               Text(
//                 'Next scratch available at: ${formatTime(lastScratchTime!.add(Duration(hours: 1)))}',
//                 style: TextStyle(
//                     fontSize: 22,
//                     color: Colors.red,
//                     fontWeight: FontWeight.bold),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:emotorad_assignment/utils.dart/scratch_card.dart';
import 'package:emotorad_assignment/utils.dart/wallet_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/coin_bloc.dart';

class HomeScreen extends StatelessWidget {
  String formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scratch Card App',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<CoinBloc, CoinState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                WalletCard(pointAvailable: state.coinBalance),
                const SizedBox(height: 20),
                if (state.isScratchable)
                  Scratcher(
                    brushSize: 30,
                    threshold: 50,
                    color: Colors.grey,
                    text: 'Scratch to reveal your reward!',
                    textStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    onScratchComplete: () =>
                        context.read<CoinBloc>().add(ScratchCard()),
                    child: Container(
                      width: 400,
                      height: 500,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          "You earned ${state.lastReward ?? '???'} coins!",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (!state.isScratchable)
                  Container(
                    width: 400,
                    height: 500,
                    decoration: const BoxDecoration(color: Colors.grey),
                    child: Center(
                      child: Text(
                        "Scratch Card Available at: ${state.lastScratchTime != null ? formatTime(state.lastScratchTime!.add(const Duration(hours: 1))) : ''}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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