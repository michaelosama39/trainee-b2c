//
//
//
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:upgrade_traine_project/core/ui/widgets/custom_appbar.dart';
//
// import 'AgoraConstants.dart';
//
// class VideoCallScreen extends StatefulWidget {
//   final String channelName;
//   const VideoCallScreen({Key? key, required this.channelName,}) : super(key: key);
//
//   @override
//   State<VideoCallScreen> createState() => _VideoCallScreenState();
// }
//
// class _VideoCallScreenState extends State<VideoCallScreen> {
//   String channelName = "test";
//   String token = "007eJxTYLjKurWL5RZTzSElvhdRJhdPG+vbC26M6bewtpR64/9h+W0FBpMUS0vTtGQTc+MkYxMT8zRLS3OzVFNz08TktFTDJAPTJ2drUxoCGRlevTRnZWSAQBCfhaEktbiEgQEA64MfNA==";
//
//   int uid = 0; // uid of the local user
//
//   int? _remoteUid; // uid of the remote user
//   bool _isJoined = false; // Indicates if the local user has joined the channel
//   bool muted = false;
//   late RtcEngine agoraEngine; // Agora engine instance
//
//   final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey
//   = GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold
//
//   showMessage(String message) {
//     scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
//       content: Text(message),
//     ));
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // Set up an instance of Agora engine
//     setupVideoSDKEngine();
//   }
//
//   Future<void> setupVideoSDKEngine() async {
//     // retrieve or request camera and microphone permissions
//     await [Permission.microphone, Permission.camera].request();
//
//     //create an instance of the Agora engine
//     agoraEngine = createAgoraRtcEngine();
//     await agoraEngine.initialize(const RtcEngineContext(
//         appId: AgoraConstants.appId
//     ));
//
//     await agoraEngine.enableVideo();
//
//     // Register the event handler
//     agoraEngine.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           showMessage("Local user uid:${connection.localUid} joined the channel");
//           setState(() {
//             _isJoined = true;
//           });
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           showMessage("Remote user uid:$remoteUid joined the channel");
//           setState(() {
//             _remoteUid = remoteUid;
//           });
//         },
//         onUserOffline: (RtcConnection connection, int remoteUid,
//             UserOfflineReasonType reason) {
//           showMessage("Remote user uid:$remoteUid left the channel");
//           setState(() {
//             _remoteUid = null;
//           });
//         },
//       ),
//     );
//
//     await agoraEngine.startPreview();
//
//     // Set channel options including the client role and channel profile
//     ChannelMediaOptions options = const ChannelMediaOptions(
//       clientRoleType: ClientRoleType.clientRoleBroadcaster,
//       channelProfile: ChannelProfileType.channelProfileCommunication,
//     );
//
//     await agoraEngine.joinChannel(
//       token: token,
//       channelId: channelName,
//       options: options,
//       uid: uid,
//     );
//   }
//
//
//
//   void leave() async{
//     setState(() {
//       _isJoined = false;
//       _remoteUid = null;
//     });
//    await  agoraEngine.leaveChannel();
//    Navigator.pop(context);}
//
//   // Release the resources when you leave
//   @override
//   void dispose() async {
//     await agoraEngine.leaveChannel();
//     agoraEngine.release();
//     super.dispose();
//   }
//
//   // Create UI with local view and remote view
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: const TransparentAppBar(
//           title: "",
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             children: [
//               // Container for the local video
//               Expanded(
//                 child: _localPreview(),
//               ),
//               const SizedBox(height: 10),
//               //Container for the Remote video
//               Expanded(
//                 child: _remoteVideo(),
//               ),
//               // Button Row
//               if(_isJoined)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   InkWell(
//                     onTap: (){
//                      setState(() {
//                        muted = !muted;
//                      });
//                       agoraEngine.muteLocalAudioStream(muted);
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: const BoxDecoration(color: Colors.red,shape: BoxShape.circle),
//                       child: Icon(muted ? Icons.mic : Icons.mic_off,color: Colors.white,),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () => leave(),
//                     child: Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: const BoxDecoration(color: Colors.red,shape: BoxShape.circle),
//                       child: const Icon(Icons.call_end,color: Colors.white,),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: (){
//                       agoraEngine.switchCamera();
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: const BoxDecoration(color: Colors.red,shape: BoxShape.circle),
//                       child: const Icon(Icons.camera_alt,color: Colors.white,),
//                     ),
//                   ),
//
//                 ],
//               ),
//               // Button Row ends
//             ],
//           ),
//         ));
//   }
//
// // Display local video preview
//   Widget _localPreview() {
//     if (_isJoined) {
//       return AgoraVideoView(
//         controller: VideoViewController(
//           rtcEngine: agoraEngine,
//           canvas: const VideoCanvas(uid: 0),
//         ),
//       );
//     } else {
//       return const Text(
//         'Join a channel',
//         textAlign: TextAlign.center,
//       );
//     }
//   }
//
// // Display remote user's video
//   Widget _remoteVideo() {
//     if (_remoteUid != null) {
//       return AgoraVideoView(
//         controller: VideoViewController.remote(
//           rtcEngine: agoraEngine,
//           canvas: VideoCanvas(uid: _remoteUid),
//           connection: RtcConnection(channelId: channelName),
//         ),
//       );
//     } else {
//       String msg = '';
//       if (_isJoined) msg = 'Waiting for a remote user to join';
//       return Text(
//         msg,
//         textAlign: TextAlign.center,
//       );
//     }
//   }
//
// }
