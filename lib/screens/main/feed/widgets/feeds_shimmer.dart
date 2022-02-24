import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FeedsShimer extends StatelessWidget {
  const FeedsShimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Shimmer.fromColors(

        period: Duration(milliseconds: 1000),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(

                    children: [
                      const CircleAvatar(
                        radius: 20,
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              height: 10,
                              width: 100,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.grey,),

                          ),
                          SizedBox(height: 10,),
                          Container(
                            height: 10,
                            width: 70,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.grey,),

                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 12),
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.grey,),

                    height: 40,
                  ),
                ),
              ),
            ],
          ),
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[300]!),
    );
  }
}
