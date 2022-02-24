import 'package:flutter/material.dart';
import 'package:image_stack/image_stack.dart';
import 'package:shimmer/shimmer.dart';

class FeedLoader extends StatefulWidget {
  final double? height;
  const FeedLoader({Key? key, this.height}) : super(key: key);

  @override
  _FeedLoaderState createState() => _FeedLoaderState();
}

class _FeedLoaderState extends State<FeedLoader> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? MediaQuery.of(context).size.height * 0.5,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (_, __) => FeedLoaderItem(),
      ),
    );
  }
}

class FeedLoaderItem extends StatelessWidget {
  final images = ["assets/images/1.jpg", "assets/images/2.jpg"];

  FeedLoaderItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[300]!,
      child: Card(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 10,
                          width: 150,
                          color: Colors.grey[200],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          height: 10,
                          width: 100,
                          color: Colors.grey[200],
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                      color: Colors.grey[200], shape: BoxShape.circle),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              height: MediaQuery.of(context).size.width * 0.7,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[200],
            ),
            const SizedBox(
              height: 8,
            ),
            const SizedBox(
              height: 8,
            ),
            // Stack(
            //   ch
            // ),
            // const SizedBox(
            //   height: 8,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 10,
                  width: 100,
                  color: Colors.grey[200],
                ),
                const SizedBox(
                  width: 8,
                ),
                Container(
                  height: 10,
                  width: 100,
                  color: Colors.grey[200],
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
