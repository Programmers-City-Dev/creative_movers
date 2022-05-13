import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ConnectsShimer extends StatefulWidget {
  const ConnectsShimer({Key? key}) : super(key: key);

  @override
  _ConnectsShimerState createState() => _ConnectsShimerState();
}

class _ConnectsShimerState extends State<ConnectsShimer> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        period: const Duration(milliseconds: 1000),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 10,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 10,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 5,),
                        Container(
                          height: 10,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  height: 10,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

          ],
        ),
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[300]!);
  }
}
