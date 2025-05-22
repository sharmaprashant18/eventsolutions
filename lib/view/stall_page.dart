import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StallPage extends ConsumerWidget {
  const StallPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Stalls',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Text('Stalls'),
      ),
    );
  }
}

// class StallPage extends StatefulWidget {
//   const StallPage({super.key});

//   @override
//   State<StallPage> createState() => _StallPageState();
// }

// class _StallPageState extends State<StallPage> {
//   String formatDateManually(DateTime dateTime) {
//     String day = dateTime.day.toString().padLeft(2, '0');

//     List<String> months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec'
//     ];
//     String month = months[dateTime.month - 1];

//     // Get last two digits of year
//     String year = (dateTime.year % 100).toString().padLeft(2, '0');

//     return '$day $month, $year';
//   }

//   DateTime selectedDate = DateTime.now();
//   TimeOfDay selectedTime = TimeOfDay(hour: 13, minute: 0); // 1:00 PM

//   // Stall status: 0 = available, 1 = selected, 2 = reserved, 3 = unavailable
//   List<List<int>> stallGrid = [
//     [1, 0, 0, 0, 0, 0, 0, 2],
//     [0, 0, 0, 0, 0, 0, 0, 0],
//     [0, 0, 1, 1, 0, 0, 0, 0],
//     [2, 2, 2, 2, 2, 2, 2, 2],
//     [2, 2, 2, 2, 2, 2, 2, 3],
//   ];

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2025),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }

//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: selectedTime,
//     );
//     if (picked != null && picked != selectedTime) {
//       setState(() {
//         selectedTime = picked;
//       });
//     }
//   }

//   Color _getStallColor(int status) {
//     switch (status) {
//       case 0:
//         return Colors.white; // Available
//       case 1:
//         return Colors.blue; // Selected
//       case 2:
//         return Colors.green; // Reserved
//       case 3:
//         return Colors.red; // Unavailable
//       default:
//         return Colors.white;
//     }
//   }

//   void _toggleStall(int row, int col) {
//     setState(() {
//       // Only toggle if the stall is available or already selected
//       if (stallGrid[row][col] == 0) {
//         stallGrid[row][col] = 1; // Select
//       } else if (stallGrid[row][col] == 1) {
//         stallGrid[row][col] = 0; // Unselect
//       }
//       // Do nothing if the stall is reserved or unavailable
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Container(
//             decoration: BoxDecoration(
//               color: Colors.purple.shade100,
//               borderRadius: BorderRadius.circular(4),
//             ),
//             padding: const EdgeInsets.all(8),
//             child: const Icon(Icons.arrow_back, color: Colors.purple),
//           ),
//           onPressed: () {},
//         ),
//         title: const Text(
//           'Select Stall',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Date',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () => _selectDate(context),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 12),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey.shade300),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             formatDateManually(DateTime.timestamp()),
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                           const Icon(Icons.arrow_drop_down, color: Colors.grey),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () => _selectTime(context),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 12),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey.shade300),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             selectedTime.format(context),
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                           const Icon(Icons.arrow_drop_down, color: Colors.grey),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'Select Your Stall',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: GridView.builder(
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 8,
//                         crossAxisSpacing: 8.0,
//                         mainAxisSpacing: 8.0,
//                       ),
//                       itemCount: stallGrid.length * stallGrid[0].length,
//                       itemBuilder: (context, index) {
//                         final row = index ~/ stallGrid[0].length;
//                         final col = index % stallGrid[0].length;
//                         final stallStatus = stallGrid[row][col];

//                         return GestureDetector(
//                           onTap: () => _toggleStall(row, col),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: _getStallColor(stallStatus),
//                               borderRadius: BorderRadius.circular(8),
//                               border: Border.all(
//                                 color: Colors.grey.shade300,
//                                 width: stallStatus == 0 ? 1 : 0,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       _buildLegendItem(Colors.blue, 'Selected'),
//                       const SizedBox(width: 16),
//                       _buildLegendItem(Colors.green, 'Reserved'),
//                       const SizedBox(width: 16),
//                       _buildLegendItem(Colors.white, 'Available', border: true),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Text(
//                   'Checkout',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLegendItem(Color color, String label, {bool border = false}) {
//     return Row(
//       children: [
//         Container(
//           width: 12,
//           height: 12,
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(4),
//             border: border ? Border.all(color: Colors.grey.shade300) : null,
//           ),
//         ),
//         const SizedBox(width: 4),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             color: Colors.grey.shade600,
//           ),
//         ),
//       ],
//     );
//   }
// }
