import 'package:flutter/material.dart';

class HabitProgressBar extends StatelessWidget {
  final int totalBars;
  final int filledBars;

  const HabitProgressBar({
    Key? key,
    required this.totalBars,
    required this.filledBars,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int excessCount = filledBars > totalBars ? filledBars - totalBars : 0;
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      ...List.generate(totalBars, (index) {
        return Flexible(
            flex: 1,
            child: 
            Container(
          height: 10, // Height of each bar
          margin: EdgeInsets.only(right: 4), // Space between bars
          decoration: BoxDecoration(
            color: index < filledBars
                ? Colors.green
                : Colors.grey, // Fill color based on progress
            borderRadius:
                BorderRadius.circular(2), // Optional: to make bars rounded
          ),
        )
        );
      }),
      if (excessCount > 0)
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            '+$excessCount',
            style: TextStyle(color: Colors.blue),
          ),
        ),
    ]);
  }
}
