import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/app_colors.dart';
import '../../../../core/common/style/gaps.dart';
import '../../../../core/constants/app/app_constants.dart';
import '../../../../core/models/courses_model.dart';
import '../../../../core/ui/widgets/blur_widget.dart';
import '../../../../core/ui/widgets/clock_widget.dart';
import '../../../../core/ui/widgets/custom_button.dart';
import '../../../../core/ui/widgets/custom_text.dart';
import '../../../../generated/l10n.dart';
import '../../../courses/presentation/course_view.dart';
import '../state_m/course_cubit/course_cubit.dart';

class AllCoursesScreen extends StatelessWidget {
  const AllCoursesScreen({Key? key, required this.courses}) : super(key: key);
  final List<CoursesList> courses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Translation.of(context).courses,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GridView.builder(
        itemCount: courses.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return BuildCourseItemWidget(
            courseModel: courses[index],
          );
        },
      ),
    );
  }
}

class BuildCourseItemWidget extends StatelessWidget {
  const BuildCourseItemWidget({Key? key, required this.courseModel})
      : super(key: key);
  final CoursesList courseModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return CourseView(
            courseModel: courseModel,
          );
        }));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadius12),
                image: courseModel.imageUrl == null
                    ? const DecorationImage(
                        image: AssetImage(AppConstants.COACH1_IMAGE),
                        fit: BoxFit.cover,
                      )
                    : DecorationImage(
                        image: NetworkImage(courseModel.imageUrl!),
                        fit: BoxFit.cover,
                      ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.white.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 0), // changes position of shadow
                  ),
                ],
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 80.h,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 8.h),
                        child: BlurWidget(
                          height: 63.h,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: courseModel.name!,
                                    fontWeight: FontWeight.w500,
                                    fontSize: AppConstants.textSize14,
                                  ),
                                  Gaps.vGap12,
                                  CustomText(
                                    text:
                                        '${courseModel.fee} ${Translation.of(context).saudi_riyal}',
                                    fontSize: AppConstants.textSize14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.accentColorLight,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16.w,
                        child: SizedBox(
                          height: 28.h,
                          child: BlocBuilder<CourseCubit, CourseState>(
                            builder: (context, state) {
                              return CustomElevatedButton(
                                textMaxLines: 1,
                                text: Translation.of(context).book_now,
                                textSize: AppConstants.textSize12,
                                onTap: () {
                                  CourseCubit.get(context)
                                      .bookCourse(courseId: courseModel.id!);
                                },
                                borderRadius: AppConstants.borderRadius4,
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                          left: 16.w,
                          bottom: 10.h,
                          child: ClockWidget(
                            duration:
                                courseModel.trainingHoursCount!.toDouble(),
                          ))
                    ],
                  ),
                ),
              ),
            ),
            PositionedDirectional(
              end: 10,
              top: 10,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 2.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentColorLight,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  "${courseModel.discountPercentage}%",
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
