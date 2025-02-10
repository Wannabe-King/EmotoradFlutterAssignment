// import 'package:emotorad_assignment/utils.dart/history_tile.dart';
// import 'package:flutter/material.dart';

// class HistoryScreen extends StatefulWidget {
//   const HistoryScreen({super.key});

//   @override
//   State<HistoryScreen> createState() => _HistoryScreenState();
// }

// class _HistoryScreenState extends State<HistoryScreen> {
//   final List _history = [
//     {
//       "description": "Hello this is the reason",
//       "timestamp": "10:20 PM",
//       "points": 23,
//       "transaction-type": "credit"
//     },
//     {
//       "description": "Hello this is the reason",
//       "timestamp": "10:20 PM",
//       "points": 23,
//       "transaction-type": "deposit"
//     },
//     // {"description": "Hello this is the reason"},
//   ];

//   void addTransaction() {
//     setState(() {
//       _history.add({
//         "description": "Hello this is the reason",
//         "timestamp": "10:20 PM",
//         "points": 23,
//         "transaction-type": "deposit"
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           title: Text(
//             'Points History',
//             style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               TextButton(onPressed: addTransaction, child: Text("button")),
//               Expanded(
//                 child: ListView.builder(
//                     itemCount: _history.length,
//                     itemBuilder: (context, index) {
//                       return HistoryTile(
//                         description: _history[index]['description'],
//                         timestamp: _history[index]['timestamp'],
//                         transactionType: _history[index]['transaction-type'],
//                         points: _history[index]["points"],
//                       );
//                     }),
//               )
//             ],
//           ),
//         ));
//   }
// }

import 'package:emotorad_assignment/utils.dart/history_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/coin_bloc.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Points History',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<CoinBloc, CoinState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.history.length,
                    itemBuilder: (context, index) {
                      final transaction = state.history[index];
                      return HistoryTile(
                        description: transaction['description'],
                        timestamp: DateFormat('h:mm a')
                            .format(transaction['timestamp']),
                        transactionType: transaction['transaction-type'],
                        points: transaction['points'],
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
