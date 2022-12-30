import 'package:creative_movers/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:pusher_client/pusher_client.dart';

class PusherService {
  PusherService._();

  static PusherClient? pusher;

  // / [PusherService] factory constructor.
  static Future<PusherService> get getInstance async {
    final PusherService pusherService = PusherService._();
    return pusherService;
  }

  Future<void> initialize() async {
    PusherOptions options = PusherOptions(
      cluster: "eu",
      // host: 'staging.creativemovers.app',
      // // wsPort: 6001,
      // // encrypted: false,
      // auth: PusherAuth(
      //   'https://staging.creativemovers.app/pusher/user-auth',
      //   headers: {
      //     'Authorization': 'Bearer $token',
      //   },
      // ),
    );

    pusher = PusherClient(Constants.pusherApiKey, options,
        autoConnect: true, enableLogging: true);
    // connect at a later time than at instantiation.
    await pusher?.connect();
    pusher?.onConnectionStateChange((state) {
      debugPrint(
          "previousState: ${state?.previousState}, currentState: ${state?.currentState}");
    });

    pusher?.onConnectionError((error) {
      debugPrint("error: ${error?.message}");
    });
  }

  Future<PusherClient?> get getClient async {
    if (pusher == null) {
      await initialize();
    }
    return pusher;
  }
}
