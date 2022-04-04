import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StatusShimmer extends StatefulWidget {
  const StatusShimmer({Key? key}) : super(key: key);

  @override
  _StatusShimmerState createState() => _StatusShimmerState();
}

class _StatusShimmerState extends State<StatusShimmer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(

          scrollDirection: Axis.horizontal,
          itemBuilder:(context,index)=> Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[300]!,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(children:  [
            const CircleAvatar(radius: 25,backgroundColor: AppColors.lightGrey,),
            const SizedBox(height: 6,),
            Container(
              height: 10,
              width: 50,

              color: AppColors.lightGrey,
              padding: const EdgeInsets.only(right: 8.0),
              child: const Center(),
            )
          ],),
        ),
      )),
    );
  }
}
