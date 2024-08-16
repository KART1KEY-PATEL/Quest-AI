import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questias/providers/subscription_provider.dart';
import 'package:questias/utils/color.dart';
import 'package:questias/utils/custom_string.dart';
import 'package:questias/utils/textUtil.dart';

class SubscriptionDetailsWidget extends StatelessWidget {
  SubscriptionDetailsWidget({
    super.key,
    required this.sH,
    required this.sW,
  });

  final double sH;
  final double sW;

  List<Map<String, dynamic>> features = CustomString.features;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return SizedBox(
          height: sH * 0.02,
        );
      },
      shrinkWrap: true,
      itemCount: features.length,
      itemBuilder: (context, index) {
        return Consumer<SubscriptionProvider>(
            builder: (context, controller, child) {
          return Stack(
            children: [
              InkWell(
                onTap: () {
                  controller.changePlan(features[index]['plan']);
                  // setState(() {
                  //   selectedPlan = features[index]['plan'];
                  // });
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: controller.selectedPlan == features[index]['plan']
                        ? Border.all(
                            color: AppColors.currentPlanBorder,
                            width: 3,
                          )
                        : null,
                    color: index == 0
                        ? AppColors.basicPlanColor
                        : index == 1
                            ? AppColors.plusPlanColor
                            : AppColors.advancedPlanColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          txt(
                            features[index]['title'],
                            weight: FontWeight.w600,
                            size: sH * 0.025,
                          ),
                          txt(
                            features[index]['price'],
                            weight: FontWeight.w600,
                            size: sH * 0.025,
                          ),
                        ],
                      ),
                      const Divider(
                        color: AppColors.borderColor,
                      ),
                      SizedBox(
                        height: sH * 0.03 * features[index]['features'].length,
                        child: ListView.separated(
                          // shrinkWrap: true,
                          itemBuilder: (context, featuresIndex) {
                            return Row(
                              children: [
                                Container(
                                  height: sH * 0.015,
                                  width: sW * 0.015,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.borderColor,
                                  ),
                                ),
                                SizedBox(
                                  width: sW * 0.02,
                                ),
                                SizedBox(
                                  width: sW * 0.8,
                                  child: txt(
                                    features[index]['features'][featuresIndex],
                                  ),
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: sH * 0.005,
                            );
                          },
                          itemCount: features[index]['features'].length,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              controller.currentPlan == features[index]['plan']
                  ? Positioned(
                      bottom: sW * 0.02,
                      right: sW * 0.02,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: sW * 0.02,
                          vertical: sH * 0.005,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.currentPlanBorder,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: txt(
                          "Current Plan",
                          weight: FontWeight.bold,
                          color: AppColors.whiteTextColor,
                        ),
                      ),
                    )
                  : Container(),
            ],
          );
        });
      },
    );
  }
}
