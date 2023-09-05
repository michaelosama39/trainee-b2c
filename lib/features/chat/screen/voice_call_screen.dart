// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:upgrade_traine_project/core/ui/widgets/custom_appbar.dart';
//
// import 'AgoraConstants.dart';
//
// class VoiceCallScreen extends StatefulWidget {
//   final String channelName;
//   const VoiceCallScreen({Key? key, required this.channelName}) : super(key: key);
//
//   @override
//   State<VoiceCallScreen> createState() => _VoiceCallScreenState();
// }
//
// class _VoiceCallScreenState extends State<VoiceCallScreen> {
//   String channelName = "test";
//   String token = "007eJxTYLjKurWL5RZTzSElvhdRJhdPG+vbC26M6bewtpR64/9h+W0FBpMUS0vTtGQTc+MkYxMT8zRLS3OzVFNz08TktFTDJAPTJ2drUxoCGRlevTRnZWSAQBCfhaEktbiEgQEA64MfNA==";
//
//   int uid = 0; // uid of the local user
//
//   int? _remoteUid; // uid of the remote user
//   bool _isJoined = false; // Indicates if the local user has joined the channel
//   bool muted = false; // Indicates if the local user has joined the channel
//   late RtcEngine agoraEngine; // Agora engine instance
//
//   final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey
//   = GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold
//
//   showMessage(String message) {
//     scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
//       content: Text(message),
//     ));
//   }// Global key to access the scaffold
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     // Set up an instance of Agora engine
//     setupVoiceSDKEngine();
//   }
//
//   Future<void> setupVoiceSDKEngine() async {
//     // retrieve or request microphone permission
//     await [Permission.microphone].request();
//
//     //create an instance of the Agora engine
//     agoraEngine = createAgoraRtcEngine();
//     await agoraEngine.initialize(const RtcEngineContext(
//         appId: AgoraConstants.appId
//     ));
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
//   void leave() async{
//     setState(() {
//       _isJoined = false;
//       _remoteUid = null;
//     });
//     await agoraEngine.leaveChannel();
//     Navigator.pop(context);
//
//   }
//
//
//   // Clean up the resources when you leave
//   @override
//   void dispose() async {
//     await agoraEngine.leaveChannel();
//     super.dispose();
//   }
//
//   // Build UI
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: const TransparentAppBar(
//           title: "",
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//
//             children: [
//               // Status text
//               SizedBox(
//                   height: 40,
//                   child:Center(
//                       child:_status()
//                   )
//               ),
//               // Button Row
//               if(_isJoined)
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: <Widget>[
//                     InkWell(
//                       onTap: (){
//                         setState(() {
//                           muted = !muted;
//                         });
//                         agoraEngine.muteLocalAudioStream(muted);
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.all(10),
//                         decoration: const BoxDecoration(color: Colors.red,shape: BoxShape.circle),
//                         child: Icon(muted ? Icons.mic : Icons.mic_off,color: Colors.white,),
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () => leave(),
//                       child: Container(
//                         padding: const EdgeInsets.all(10),
//                         decoration: const BoxDecoration(color: Colors.red,shape: BoxShape.circle),
//                         child: const Icon(Icons.call_end,color: Colors.white,),
//                       ),
//                     ),
//                     InkWell(
//                       onTap: (){
//                         agoraEngine.switchCamera();
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.all(10),
//                         decoration: const BoxDecoration(color: Colors.red,shape: BoxShape.circle),
//                         child: const Icon(Icons.camera_alt,color: Colors.white,),
//                       ),
//                     ),
//
//                   ],
//                 ),
//             ],
//           ),
//         ));
//   }
//
//
//   Widget _status(){
//     String statusText;
//
//     if (!_isJoined) {
//       statusText = 'Join a channel';
//     } else if (_remoteUid == null) {
//       statusText = 'Waiting for a remote user to join...';
//     } else {
//       statusText = 'Connected to remote user, uid:$_remoteUid';
//     }
//
//     return Text(
//       statusText,
//     );
//   }
// }
