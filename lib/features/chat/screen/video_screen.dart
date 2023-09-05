import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upgrade_traine_project/features/profile/presentation/state_m/cubit/profile_cubit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class VideoCallPage extends StatelessWidget {
  const VideoCallPage({Key? key, required this.trainerId}) : super(key: key);
  final int trainerId;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 172297515, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign: "7088d2ea9432e77970a85beeb177953cbee5b6a7b41845280e1a1c4d39ac813e", // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: BlocProvider.of<ProfileCubit>(context).profileModel!.result!.id.toString(),
      userName: BlocProvider.of<ProfileCubit>(context).profileModel!.result!.name ?? "",
      callID: "${BlocProvider.of<ProfileCubit>(context).profileModel!.result!.id}$trainerId",
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        ..onOnlySelfInRoom = (context) => Navigator.of(context).pop(),
    );
  }
}