import 'package:creative_movers/data/remote/model/feeds_response.dart';
import 'package:flutter/material.dart';

import '../../profile/views/view_profile_screen.dart';

class LikersSheet extends StatefulWidget {
  const LikersSheet({Key? key, required this.likers}) : super(key: key);
  final List<Poster> likers;

  @override
  State<LikersSheet> createState() => _LikersSheetState();
}

class _LikersSheetState extends State<LikersSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.likers.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: _LikerItem(liker: widget.likers[index]),
        ),
      ),
    );
  }
}

class _LikerItem extends StatelessWidget {
  const _LikerItem({Key? key, required this.liker}) : super(key: key);
  final Poster liker;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ViewProfileScreen(
            userId: liker.id,
          ),
        ));
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(liker.profilePhotoPath!),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(child: Text(liker.fullname)),
          const Icon(
            Icons.arrow_forward_ios_sharp,
            size: 16,
          )
        ],
      ),
    );
  }
}
