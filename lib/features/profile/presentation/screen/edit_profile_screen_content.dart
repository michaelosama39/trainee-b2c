import 'dart:io';
import '../../../../generated/l10n.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:upgrade_traine_project/core/ui/error_ui/error_viewer/toast/show_error_toast.dart';
import 'package:upgrade_traine_project/core/ui/toast.dart';
import 'package:upgrade_traine_project/core/ui/widgets/waiting_widget.dart';
import 'package:upgrade_traine_project/features/profile/presentation/state_m/cubit/profile_cubit.dart';
import 'package:upgrade_traine_project/features/profile/presentation/state_m/provider/profile_screen_notifier.dart';
import '../../../../core/common/app_colors.dart';
import '../../../../core/common/style/gaps.dart';
import '../../../../core/constants/app/app_constants.dart';
import '../../../../core/navigation/nav.dart';
import '../../../../core/ui/widgets/custom_button.dart';
import '../../../../core/ui/widgets/custom_text.dart';
import '../../../../core/ui/widgets/custom_text_field.dart';
import '../../data/model/request/update_profile_model.dart';
import '../../data/model/response/profile_model.dart';
import '../screen/../state_m/provider/edit_profile_screen_notifier.dart';
import 'map.dart';

class EditProfileScreenContent extends StatefulWidget {
  const EditProfileScreenContent({super.key});

  @override
  State<EditProfileScreenContent> createState() =>
      _EditProfileScreenContentState();
}

class _EditProfileScreenContentState extends State<EditProfileScreenContent> {
  late EditProfileScreenNotifier sn;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  int? gender;
  String? countryCode;
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  LatLng? pos;
  int? id;
  String? url;

  @override
  void initState() {
    // TODO: implement initState

    nameController.text =
        BlocProvider.of<ProfileCubit>(context).profileModel!.result!.name ?? "";
    phoneController.text = BlocProvider.of<ProfileCubit>(context)
            .profileModel!
            .result!
            .phoneNumber ??
        "";
    birthDateController.text = BlocProvider.of<ProfileCubit>(context)
            .profileModel!
            .result!
            .birthDate ??
        "";
    gender =
        BlocProvider.of<ProfileCubit>(context).profileModel!.result!.gender ??
            1;
    // heightController.text =
    //     BlocProvider.of<ProfileCubit>(context).profileModel!.result!.length ??
    //         "";
    // weightController.text =
    //     BlocProvider.of<ProfileCubit>(context).profileModel!.result!.weight ??
    //         "";
    countryCode = BlocProvider.of<ProfileCubit>(context)
            .profileModel!
            .result!
            .countryCode ??
        "";
    id = BlocProvider.of<ProfileCubit>(context).profileModel!.result!.id;
    super.initState();
  }

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    sn = Provider.of<EditProfileScreenNotifier>(context);
    sn.context = context;
    return Form(
      key: formKey,
      child: SizedBox(
        height: 1.sh,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                _buildImageWidget(),
                SizedBox(
                  height: 55.h,
                ),
                _buildTextFiledWidget(
                    title: Translation.of(context).full_name,
                    textEditingController: nameController),
                Gaps.vGap24,
                _buildTextFiledWidget(
                    title: Translation.of(context).phone,
                    isPhoneNumber: true,
                    textEditingController: phoneController),
                Gaps.vGap24,
                Container(
                  height: 50,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.white,
                      ),
                      borderRadius:
                          BorderRadius.circular(AppConstants.borderRadius6)),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: AppColors.grey,
                    ),
                    child: DropdownButton(
                      value: gender,
                      items: ["male", "female"]
                          .map((e) => DropdownMenuItem(
                                value: e == "male" ? 1 : 2,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (c) {
                        setState(() {
                          gender = c;
                        });
                      },
                      isExpanded: true,
                      underline: const SizedBox.shrink(),
                    ),
                  ),
                ),
                Gaps.vGap24,
                _buildTextFiledWidget(
                    onTap: () async {
                      var date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          lastDate: DateTime(3000));
                      if (date != null) {
                        setState(() {
                          birthDateController.text =
                              date.toString().substring(0, 10);
                        });
                      }
                    },
                    title: Translation.of(context).date_of_birth,
                    textEditingController: birthDateController),
                Gaps.vGap24,
                // _buildTextFiledWidget(
                //     title: Translation.of(context).weight,
                //     textEditingController: weightController),
                // Gaps.vGap24,
                // _buildTextFiledWidget(
                //     title: Translation.of(context).height,
                //     textEditingController: heightController),
                // Gaps.vGap24,
                // _buildTextFiledWidget(title: Translation.of(context).bmi),
                // Gaps.vGap24,
                // Row(
                //   children: [
                //     InkWell(
                //       onTap: () async {
                //         pos = await Navigator.push(context,
                //             MaterialPageRoute(builder: (_) {
                //           return MapScreen();
                //         }));
                //       },
                //       child: CustomText(
                //         text: "حدد موقعك علي الخريطه ",
                //         color: AppColors.accentColorLight,
                //         fontSize: AppConstants.textSize16,
                //         fontWeight: FontWeight.w600,
                //       ),
                //     )
                //   ],
                // ),
                Gaps.vGap24,
                BlocProvider(
                  create: (context) => ProfileCubit(),
                  child: BlocConsumer<ProfileCubit, ProfileState>(
                    listener: (context, state) {
                      if (state is EditProfileSuccess) {
                        Navigator.of(context).pop();
                      }
                      if (state is EditProfileIMGSuccess) {
                        setState(() {
                          url = state.url;
                        });
                        Nav.pop();
                      }

                      if (state is EditProfileError) {}
                    },
                    builder: (context, state) {
                      if (state is! EditProfileLoading) {
                        return SizedBox(
                          height: 44.h,
                          width: 217.w,
                          child: CustomElevatedButton(
                            text: Translation.of(context).save,
                            onTap: () {
                              BlocProvider.of<ProfileCubit>(context)
                                  .updateProfile(UpdateProfileModel(
                                      weight: weightController.text,
                                      name: nameController.text,
                                      lat: '0.0',
                                      long: '0.0',
                                      birthDate: birthDateController.text,
                                      phone: phoneController.text,
                                      height: heightController.text,
                                      gender: gender,
                                      countryCode: countryCode,
                                      imageUrl: url,
                                      emailAddress: "",
                                      id: id));
                            },
                            textSize: AppConstants.textSize20,
                            borderRadius: AppConstants.borderRadius4,
                          ),
                        );
                      } else {
                        return WaitingWidget();
                      }
                    },
                  ),
                ),
                Gaps.vGap24,
              ],
            ),
          ),
        ),
      ),
    );
  }

  var image;

  Widget _buildImageWidget() {
    return Container(
      height: 0.52.sh,
      width: 1.sw,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius8),
        image: DecorationImage(
            image: sn.image != null
                ? FileImage(
                    File(sn.image!.path),
                  )
                : NetworkImage(BlocProvider.of<ProfileCubit>(context)
                        .profileModel!
                        .result!
                        .imageUrl ??
                    "") as ImageProvider,
            fit: BoxFit.cover),
      ),
      child: BlocProvider(
        create: (context) => ProfileCubit(),
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return Container(
              color: AppColors.primaryColorLight.withOpacity(0.7),
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    ImagePicker _picker = ImagePicker();
                    image = await _picker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      sn.image = image;
                      print("img:${image!.path}");
                      sn.profileCubit.updateImage(File(image.path));
                    });
                  },
                  child: ImageIcon(
                    const AssetImage(AppConstants.CAMERA_ICON),
                    color: AppColors.white,
                    size: 104.w,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextFiledWidget(
      {required String title,
      bool isPhoneNumber = false,
      Function()? onTap,
      required TextEditingController textEditingController}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          fontSize: AppConstants.textSize16,
        ),
        Gaps.vGap4,
        isPhoneNumber
            ? Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.white,
                    ),
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadius6)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: PhoneNumberTextField(
                    dialCode:
                        "+${BlocProvider.of<ProfileCubit>(context).profileModel!.result!.countryCode}",
                    onDialChanged: (d) {
                      setState(() {
                        countryCode = d;
                      });
                    },
                    border: InputBorder.none,
                    hint: false,
                    textEditingController: textEditingController,
                    onInputChanged: (p0) {},
                  ),
                ),
              )
            : TextFormField(
                onTap: onTap,
                controller: textEditingController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: AppColors.white,
                  )),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: AppColors.white,
                  )),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: AppColors.white,
                  )),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: AppColors.white,
                  )),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: AppColors.white,
                  )),
                ),
              ),
      ],
    );
  }
}
