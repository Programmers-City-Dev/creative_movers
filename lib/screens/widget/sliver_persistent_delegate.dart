import 'package:flutter/material.dart';

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate(this._preferredSize);

  final PreferredSize _preferredSize;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _preferredSize;
  }

  @override
  double get maxExtent => _preferredSize.preferredSize.height;

  @override
  double get minExtent => _preferredSize.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
