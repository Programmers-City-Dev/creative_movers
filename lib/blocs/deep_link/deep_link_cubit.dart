import 'package:bloc/bloc.dart';
import 'package:creative_movers/data/local/repository/deep_link/deep_link_repository.dart';
import 'package:creative_movers/models/deep_link_data.dart';
import 'package:flutter/material.dart';

class DeepLinkCubit extends Cubit<DeepLinkData?> {
  DeepLinkRepo repo;

  DeepLinkCubit(this.repo) : super(null);

  final inAppNotifier = ValueNotifier<DeepLinkData?>(null);

  void retrieveRecentNotification() async {
    var notification = await repo.getRecentNotification();
    emit(notification);
  }

  void saveRecentNotification(DeepLinkData notification) async {
    //await repo.saveRecentNotification(notification);
    emit(null);
    emit(notification);
  }

  void deleteRecentNotification() async {
    //await repo.deleteRecentNotification();
    emit(null);
  }
}
