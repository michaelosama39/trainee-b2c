import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:upgrade_traine_project/features/account/data/model/request/create_feedback_request.dart';
import '../../../../core/common/app_colors.dart';
import '../../../../generated/l10n.dart';

import '../../../../core/common/style/gaps.dart';
import '../../../../core/constants/app/app_constants.dart';
import '../../../../core/ui/widgets/custom_button.dart';
import '../../../../core/ui/widgets/custom_text.dart';
import '../../../../core/ui/widgets/custom_text_field.dart';
import '../../../account/presentation/state_m/bloc/account_cubit.dart';
import '../screen/../state_m/provider/feedback_screen_notifier.dart';

class FeedbackScreenContent extends StatefulWidget {
  @override
  State<FeedbackScreenContent> createState() => _FeedbackScreenContentState();
}

class _FeedbackScreenContentState extends State<FeedbackScreenContent> {
  late FeedbackScreenNotifier sn;

  @override
  Widget build(BuildContext context) {
    sn = Provider.of<FeedbackScreenNotifier>(context);
    sn.context = context;
    return Padding(
      padding: EdgeInsets.only(top: 12.w, left: 12.w, right: 12.w),
      child: SingleChildScrollView(
        child: SizedBox(
          width: 1.sw,
          child: Column(
            children: [
              SizedBox(
                height: 0.6.sh,
                child: Column(
                  children: [
                    Gaps.vGap16,
                    Image.asset(
                      AppConstants.APP_LOGO_IMG,
                      width: 117.w,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    _buildTextFieldFullBorderWithTitle(
                      title: Translation.of(context).subject,
                      focusNode: sn.subjectFocusNode,
                      controller: sn.subjectController,
                      textInputAction: TextInputAction.next,
                      onSubmitted: () {
                        FocusScope.of(context).requestFocus();
                      },
                    ),
                    Gaps.vGap24,
                    _buildTextFieldFullBorderWithTitle(
                        title: Translation.of(context).details,
                        focusNode: sn.detailsFocusNode,
                        controller: sn.detailsController,
                        textInputAction: TextInputAction.done,
                        onSubmitted: () {},
                        maxLines: 5),
                  ],
                ),
              ),
              SizedBox(
                height: 0.2.sh,
                child: Column(
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: 0.7.sw,
                      height: 44.h,
                      child: CustomElevatedButton(
                        text: Translation.of(context).send,
                        onTap: () {
                          BlocProvider.of<AccountCubit>(context).createFeedback(
                            context,
                            CraeteFeedbackRequest(
                              description: sn.detailsController.text,
                              subject: sn.subjectController.text,
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldFullBorderWithTitle(
      {required String title,
      required FocusNode focusNode,
      required TextEditingController controller,
      required TextInputAction textInputAction,
      required Function onSubmitted,
      int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          fontSize: AppConstants.textSize16,
        ),
        Gaps.vGap4,
        NormalTextField(
          controller: controller,
          focusNode: focusNode,
          inputBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.white,
            ),
          ),
          textInputAction: textInputAction,
          onFieldSubmitted: onSubmitted,
          maxLines: maxLines,
        )
      ],
    );
  }
}
