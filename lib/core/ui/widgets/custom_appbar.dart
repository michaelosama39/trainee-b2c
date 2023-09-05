import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:upgrade_traine_project/features/notification/presentation/view/notification_screen.dart';
import '../../../core/common/app_colors.dart';
import '../../../core/common/style/gaps.dart';
import '../../../core/constants/app/app_constants.dart';
import '../../../core/ui/widgets/blur_widget.dart';
import '../../../core/ui/widgets/custom_text_field.dart';
import '../../../features/home/presentation/state_m/bloc/maps_cubit.dart';
import '../../../generated/l10n.dart';
import 'package:uuid/uuid.dart';

import 'custom_text.dart';

// class HomeAppbar extends StatefulWidget with PreferredSizeWidget {
//   final TextEditingController controller;
//
//   const HomeAppbar({Key? key, required this.controller}) : super(key: key);
//
//   @override
//   State<HomeAppbar> createState() => _HomeAppbarState();
//
//   @override
//   // TODO: implement preferredSize
//   Size get preferredSize => throw UnimplementedError();
// }
//
// class _HomeAppbarState extends State<HomeAppbar> {
//   Widget buildFloatingSearchBar() {
//     final isPortrait =
//         MediaQuery.of(context).orientation == Orientation.portrait;
//
//     return buildFloatingSearchBar();
//     //   FloatingSearchBar(
//     //   controller: widget.controller,
//     //   elevation: 6,
//     //   hintStyle: TextStyle(fontSize: 18),
//     //   queryStyle: TextStyle(fontSize: 18),
//     //   hint: 'Find a place..',
//     //   border: BorderSide(style: BorderStyle.none),
//     //   margins: EdgeInsets.fromLTRB(20, 70, 20, 0),
//     //   padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
//     //   height: 52,
//     //   iconColor: Colors.blue,
//     //   scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
//     //   transitionDuration: const Duration(milliseconds: 600),
//     //   transitionCurve: Curves.easeInOut,
//     //   physics: const BouncingScrollPhysics(),
//     //   axisAlignment: isPortrait ? 0.0 : -1.0,
//     //   openAxisAlignment: 0.0,
//     //   width: isPortrait ? 600 : 500,
//     //   debounceDelay: const Duration(milliseconds: 500),
//     //   onQueryChanged: (query) {
//     //     getPlacesSuggestions(query);
//     //   },
//     //   onFocusChanged: (_) {
//     //     // hide distance and time row
//     //     setState(() {
//     //       isTimeAndDistanceVisible = false;
//     //     });
//     //   },
//     //   transition: CircularFloatingSearchBarTransition(),
//     //   actions: [
//     //     FloatingSearchBarAction(
//     //       showIfOpened: false,
//     //       child: CircularButton(
//     //           icon: Icon(Icons.place, color: Colors.black.withOpacity(0.6)),
//     //           onPressed: () {}),
//     //     ),
//     //   ],
//     //   builder: (context, transition) {
//     //     return ClipRRect(
//     //       borderRadius: BorderRadius.circular(8),
//     //       child: Column(
//     //         mainAxisAlignment: MainAxisAlignment.start,
//     //         mainAxisSize: MainAxisSize.min,
//     //         children: [
//     //           buildSuggestionsBloc(),
//     //           buildSelectedPlaceLocationBloc(),
//     //           buildDiretionsBloc(),
//     //         ],
//     //       ),
//     //     );
//     //   },
//     // );
//   }
//
//   // Widget buildDiretionsBloc() {
//   //   // return BlocListener<MapsCubit, MapsState>(
//   //   //   listener: (context, state) {
//   //   //     if (state is DirectionsLoaded) {
//   //   //       placeDirections = (state).placeDirections;
//   //   //
//   //   //       getPolylinePoints();
//   //   //     }
//   //   //   },
//   //   //   child: Container(),
//   //   // );
//   // }
//
//   void getPolylinePoints() {
//     // polylinePoints = placeDirections!.polylinePoints
//     //     .map((e) => LatLng(e.latitude, e.longitude))
//     //     .toList();
//   }
//   //
//   // Widget buildSelectedPlaceLocationBloc() {
//   //   return BlocListener<MapsCubit, MapsState>(
//   //     listener: (context, state) {
//   //       if (state is PlaceLocationLoaded) {
//   //         selectedPlace = (state).place;
//   //
//   //         goToMySearchedForLocation();
//   //         getDirections();
//   //       }
//   //     },
//   //     child: Container(),
//   //   );
//   // }
//
//   // void getDirections() {
//   //   BlocProvider.of<MapsCubit>(context).emitPlaceDirections(
//   //     LatLng(position!.latitude, position!.longitude),
//   //     LatLng(selectedPlace.result.geometry.location.lat,
//   //         selectedPlace.result.geometry.location.lng),
//   //   );
//   // }
//   //
//   // Future<void> goToMySearchedForLocation() async {
//   //   buildCameraNewPosition();
//   //   final GoogleMapController controller = await _mapController.future;
//   //   controller
//   //       .animateCamera(CameraUpdate.newCameraPosition(goToSearchedForPlace));
//   //   buildSearchedPlaceMarker();
//   // }
//   //
//   // void buildSearchedPlaceMarker() {
//   //   searchedPlaceMarker = Marker(
//   //     position: goToSearchedForPlace.target,
//   //     markerId: MarkerId('1'),
//   //     onTap: () {
//   //       buildCurrentLocationMarker();
//   //       // show time and distance
//   //       setState(() {
//   //         isSearchedPlaceMarkerClicked = true;
//   //         isTimeAndDistanceVisible = true;
//   //       });
//   //     },
//   //     infoWindow: InfoWindow(title: "${placeSuggestion.description}"),
//   //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//   //   );
//   //
//   //   addMarkerToMarkersAndUpdateUI(searchedPlaceMarker);
//   // }
//   //
//   // void buildCurrentLocationMarker() {
//   //   currentLocationMarker = Marker(
//   //     position: LatLng(position!.latitude, position!.longitude),
//   //     markerId: MarkerId('2'),
//   //     onTap: () {},
//   //     infoWindow: InfoWindow(title: "Your current Location"),
//   //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//   //   );
//   //   addMarkerToMarkersAndUpdateUI(currentLocationMarker);
//   // }
//   //
//   // void addMarkerToMarkersAndUpdateUI(Marker marker) {
//   //   setState(() {
//   //     markers.add(marker);
//   //   });
//   // }
//   //
//   // void getPlacesSuggestions(String query) {
//   //   final sessionToken = Uuid().v4();
//   //   BlocProvider.of<MapsCubit>(context)
//   //       .emitPlaceSuggestions(query, sessionToken);
//   // }
//   //
//   // Widget buildSuggestionsBloc() {
//   //   return BlocBuilder<MapsCubit, MapsState>(
//   //     builder: (context, state) {
//   //       if (state is PlacesLoaded) {
//   //         places = (state).places;
//   //         if (places.length != 0) {
//   //           return buildPlacesList();
//   //         } else {
//   //           return Container();
//   //         }
//   //       } else {
//   //         return Container();
//   //       }
//   //     },
//   //   );
//   // }
//   //
//   // Widget buildPlacesList() {
//   //   return ListView.builder(
//   //       itemBuilder: (ctx, index) {
//   //         return InkWell(
//   //           onTap: () async {
//   //             placeSuggestion = places[index];
//   //             widget.controller.close();
//   //             getSelectedPlaceLocation();
//   //             polylinePoints.clear();
//   //             removeAllMarkersAndUpdateUI();
//   //           },
//   //           child: PlaceItem(
//   //             suggestion: places[index],
//   //           ),
//   //         );
//   //       },
//   //       itemCount: places.length,
//   //       shrinkWrap: true,
//   //       physics: const ClampingScrollPhysics());
//   // }
//   //
//   // void removeAllMarkersAndUpdateUI() {
//   //   setState(() {
//   //     markers.clear();
//   //   });
//   // }
//   //
//   // void getSelectedPlaceLocation() {
//   //   final sessionToken = Uuid().v4();
//   //   BlocProvider.of<MapsCubit>(context)
//   //       .emitPlaceLocation(placeSuggestion.placeId, sessionToken);
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: AppColors.transparent,
//       shadowColor: AppColors.transparent,
//       title: InkWell(
//         child: Padding(
//           padding: EdgeInsetsDirectional.only(start: 4.w),
//           child: SizedBox(
//             width: 1.sw,
//             height: 40.w,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 Positioned.fill(
//                   child: BlurWidget(
//                     borderRadius: AppConstants.borderRadius4,
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () {
//                     debugPrint("ff");
//                   },
//                   child: SearchTextField(
//                     hintText: Translation.of(context).search,
//                     controller: widget.controller,
//                     onChanged: (String s) {
//                       Home;
//                       debugPrint("$s");
//                     },
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//       actions: [
//         InkWell(
//           onTap: () {
//             debugPrint("ff");
//             Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//               return Home();
//             }));
//           },
//           child: const Icon(Icons.notifications),
//         ),
//         Gaps.hGap16
//       ],
//     );
//   }
//
//   @override
//   Size get preferredSize => const Size.fromHeight(56);
// }
//
// class TransparentAppBar extends StatelessWidget with PreferredSizeWidget {
//   final String title;
//   final List<Widget>? actions;
//
//   const TransparentAppBar({Key? key, required this.title, this.actions})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: AppColors.transparent,
//       shadowColor: AppColors.transparent,
//       title: CustomText(
//         text: title,
//         fontSize: AppConstants.textSize18,
//         fontWeight: FontWeight.bold,
//       ),
//       actions: actions,
//     );
//   }
//
//   @override
//   Size get preferredSize => const Size.fromHeight(56);
// }
//
// class Home extends StatefulWidget {
//   @override
//   _HomeState createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   String googleApikey = "AIzaSyC3omLdU3qLrhCHEp34jLFJf_GZfTssvCU";
//   GoogleMapController? mapController; //contrller for Google map
//   CameraPosition? cameraPosition;
//   LatLng startLocation = LatLng(27.6602292, 85.308027);
//   String location = "Search Location";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Place Search Autocomplete Google Map"),
//           backgroundColor: Colors.deepPurpleAccent,
//         ),
//         body: Stack(children: [
//           GoogleMap(
//             //Map widget from google_maps_flutter package
//             zoomGesturesEnabled: true, //enable Zoom in, out on map
//             initialCameraPosition: CameraPosition(
//               //innital position in map
//               target: startLocation, //initial position
//               zoom: 14.0, //initial zoom level
//             ),
//             mapType: MapType.normal, //map type
//             onMapCreated: (controller) {
//               //method called when map is created
//               setState(() {
//                 mapController = controller;
//               });
//             },
//           ),
//
//           //search autoconplete input
//           Positioned(
//               //search input bar
//               top: 10,
//               child: InkWell(
//                   onTap: () async {
//                     var place = await PlacesAutocomplete.show(
//                         context: context,
//                         apiKey: googleApikey,
//                         mode: Mode.overlay,
//                         types: [],
//                         strictbounds: false,
//                         components: [Component(Component.country, 'np')],
//                         //google_map_webservice package
//                         onError: (err) {
//                           print(err);
//                         });
//
//                     if (place != null) {
//                       setState(() {
//                         location = place.description.toString();
//                       });
//
//                       //form google_maps_webservice package
//                       final plist = GoogleMapsPlaces(
//                         apiKey: googleApikey,
//                         apiHeaders: await GoogleApiHeaders().getHeaders(),
//                         //from google_api_headers package
//                       );
//                       String placeid = place.placeId ?? "0";
//                       final detail = await plist.getDetailsByPlaceId(placeid);
//                       final geometry = detail.result.geometry!;
//                       final lat = geometry.location.lat;
//                       final lang = geometry.location.lng;
//                       var newlatlang = LatLng(lat, lang);
//                       //move map camera to selected place with animation
//                       mapController?.animateCamera(
//                           CameraUpdate.newCameraPosition(
//                               CameraPosition(target: newlatlang, zoom: 17)));
//                     }
//                   },
//                   child: Padding(
//                     padding: EdgeInsets.all(15),
//                     child: Card(
//                       child: Container(
//                           padding: EdgeInsets.all(0),
//                           width: MediaQuery.of(context).size.width - 40,
//                           child: ListTile(
//                             title: Text(
//                               location,
//                               style: TextStyle(fontSize: 18),
//                             ),
//                             trailing: Icon(Icons.search),
//                             dense: true,
//                           )),
//                     ),
//                   )))
//         ]));
//   }
// }
class HomeAppbar extends StatelessWidget with PreferredSizeWidget {
  final TextEditingController controller;

  const HomeAppbar({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.transparent,
      shadowColor: AppColors.transparent,
      title: Padding(
        padding: EdgeInsetsDirectional.only(start: 4.w),
        child: SizedBox(
          width: 1.sw,
          height: 40.w,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: BlurWidget(
                  borderRadius: AppConstants.borderRadius4,
                ),
              ),
              BlocConsumer<MapsCubit, MapsState>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  return SearchTextField(
                    hintText: Translation.of(context).search,
                    controller: controller,
                    onChanged: (String query) {
                      final sessionToken =  const Uuid().v4();
                      BlocProvider.of<MapsCubit>(context)
                          .emitPlaceSuggestion(query, sessionToken);
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
      actions: [InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen(),));
        },
          child: const Icon(Icons.notifications)), Gaps.hGap16],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class TransparentAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const TransparentAppBar({Key? key, required this.title, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.transparent,
      shadowColor: AppColors.transparent,
      title: CustomText(
        text: title,
        fontSize: AppConstants.textSize18,
        fontWeight: FontWeight.bold,
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
