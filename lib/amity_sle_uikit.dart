// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_uikit_beta_service/view/chat/chat_screen.dart';
import 'package:amity_uikit_beta_service/viewmodel/channel_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'viewmodel/amity_viewmodel.dart';
import 'viewmodel/channel_list_viewmodel.dart';
import 'viewmodel/community_viewmodel.dart';
import 'viewmodel/configuration_viewmodel.dart';
import 'viewmodel/create_post_viewmodel.dart';
import 'viewmodel/custom_image_picker.dart';
import 'viewmodel/feed_viewmodel.dart';
import 'viewmodel/post_viewmodel.dart';
import 'viewmodel/user_feed_viewmodel.dart';
import 'viewmodel/user_viewmodel.dart';
import 'utils/env_manager.dart';

class AmitySLEUIKit {
  Future<void> initUIKit(String apikey, String region) async {
    env = ENV(apikey, region);
    AmityRegionalHttpEndpoint? amityEndpoint;
    if (region.isNotEmpty) {
      switch (region) {
        case "":
          {
            log("REGION is not specify Please check .env file");
          }

          break;
        case "sg":
          {
            amityEndpoint = AmityRegionalHttpEndpoint.SG;
          }

          break;
        case "us":
          {
            amityEndpoint = AmityRegionalHttpEndpoint.US;
          }

          break;
        case "eu":
          {
            amityEndpoint = AmityRegionalHttpEndpoint.EU;
          }
      }
    } else {
      throw "REGION is not specify Please check .env file";
    }

    await AmityCoreClient.setup(
        option:
            AmityCoreClientOption(apiKey: apikey, httpEndpoint: amityEndpoint!),
        sycInitialization: true);
  }

  Future<void> registerDevice(BuildContext context, String userId) async {
    await Provider.of<AmityVM>(context, listen: false)
        .login(userId)
        .then((value) {
      Provider.of<UserVM>(context, listen: false).initAccessToken();
    });
  }

  void configAmityThemeColor(
      BuildContext context, Function(AmityUIConfiguration config) config) {
    var provider = Provider.of<AmityUIConfiguration>(context, listen: false);
    config(provider);
  }
}

class AmitySLEProvider extends StatelessWidget {
  final Widget child;
  const AmitySLEProvider({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserVM>(create: ((context) => UserVM())),
        ChangeNotifierProvider<AmityVM>(create: ((context) => AmityVM())),
        ChangeNotifierProvider<FeedVM>(create: ((context) => FeedVM())),
        ChangeNotifierProvider<CommunityVM>(
            create: ((context) => CommunityVM())),
        ChangeNotifierProvider<PostVM>(create: ((context) => PostVM())),
        ChangeNotifierProvider<UserFeedVM>(create: ((context) => UserFeedVM())),
        ChangeNotifierProvider<ImagePickerVM>(
            create: ((context) => ImagePickerVM())),
        ChangeNotifierProvider<CreatePostVM>(
            create: ((context) => CreatePostVM())),
        ChangeNotifierProvider<ChannelVM>(create: ((context) => ChannelVM())),
        ChangeNotifierProvider<AmityUIConfiguration>(
            create: ((context) => AmityUIConfiguration())),
      ],
      child: Builder(
        builder: (context) => child,
      ),
    );
  }
}
