import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:upgrade_traine_project/core/common/utils.dart';

import '../../../../core/common/app_colors.dart';
import '../../../../core/common/style/gaps.dart';
import '../../../../core/constants/app/app_constants.dart';
import '../../../../core/navigation/nav.dart';
import '../../../../core/ui/widgets/blur_widget.dart';
import '../../../../core/ui/widgets/custom_image_widget.dart';
import '../../../../core/ui/widgets/custom_rating_bar_widget.dart';
import '../../../../core/ui/widgets/custom_text.dart';
import '../../domain/entity/coach_entity.dart';
import '../screen/../state_m/provider/coaches_list_screen_notifier.dart';
import 'coach_profile_screen.dart';

class CoachesListScreenContent extends StatefulWidget {
  @override
  State<CoachesListScreenContent> createState() =>
      _CoachesListScreenContentState();
}

class _CoachesListScreenContentState extends State<CoachesListScreenContent> {
  late CoachesListScreenNotifier sn;

  @override
  Widget build(BuildContext context) {
    sn = Provider.of<CoachesListScreenNotifier>(context);
    sn.context = context;
    return SizedBox(
      height: 1.sh,
      width: 1.sw,
      child: Padding(
        padding: EdgeInsets.only(top: 12.h, right: 12.w, left: 12.w),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Stack(
            //   children: [
            //     BlurWidget(
            //       borderRadius: AppConstants.borderRadius4,
            //       child: Center(
            //         child: SearchTextField(
            //           controller: sn.searchController,
            //           hintText: Translation.of(context).search_coach,
            //           textInputAction: TextInputAction.search,
            //           onFieldSubmitted: () {
            //             sn.fetchData(0, text: sn.searchController.text);
            //           },
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // Gaps.vGap8,
            sn.categoryEntity != null
                ? Row(
                    children: [
                      Container(
                        height: 32.h,
                        width: 90.w,
                        decoration: BoxDecoration(
                            color: AppColors.accentColorLight,
                            borderRadius: BorderRadius.circular(
                                AppConstants.borderRadius24)),
                        child: Center(
                          child: CustomText(
                            text: getTranslation(
                                context: context,
                                arText: sn.categoryEntity?.arName,
                                enText: sn.categoryEntity?.enName,
                                alternativeText: sn.categoryEntity?.name),
                            color: AppColors.primaryColorLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            Gaps.vGap24,
            Expanded(
              child: _buildCoachesList(),
              // child: PaginationWidget<CoachEntity>(
              //   child: _buildCoachesList(),
              //   getItems: (unit) async {
              //     return sn.returnData(unit);
              //   },
              //   items: sn.coaches,
              //   onDataFetched: sn.onDataFetched,
              //   refreshController: sn.refreshController,
              // ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItemWidget(CoachEntity coachModel) {
    return GestureDetector(
      onTap: () {
        _toCoachProfile(coachModel);
      },
      child: SizedBox(
        width: 1.sw,
        height: 116.h,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
                child: BlurWidget(
              borderRadius: AppConstants.borderRadius10,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 28.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: coachModel.name ?? '',
                          fontSize: AppConstants.textSize16,
                        ),
                        CustomText(
                          text: coachModel.specialization?.text ?? '',
                          fontSize: AppConstants.textSize12,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: AppColors.white,
                              size: 14.w,
                            ),
                            Gaps.hGap4,
                            CustomText(
                              text: coachModel.address ?? '',
                              fontSize: AppConstants.textSize10,
                            ),
                          ],
                        ),
                        Gaps.vGap4,
                        Row(
                          children: [
                            SizedBox(
                              height: 16.h,
                              child: CustomRatingBarWidget(
                                itemSize: 12.w,
                                rate: coachModel.rate ?? 0.0,
                              ),
                            ),
                            Gaps.hGap4,
                            CustomText(
                              text: coachModel.rate.toString(),
                              fontSize: AppConstants.textSize12,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadius10),
                    child: CustomImageWidget(
                      imgPath: coachModel.imageUrl ?? '',
                      width: 96.w,
                      height: 116.h,
                    ),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  void _toCoachProfile(CoachEntity coachModel) {
    Nav.to(CoachProfileScreen.routeName,
        arguments: coachModel, context: context);
  }

  Widget _buildCoachesList() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) =>
          _buildListItemWidget(sn.coaches.elementAt(index)),
      separatorBuilder: (context, index) => Gaps.vGap16,
      itemCount: sn.coaches.length,
    );
  }
}
