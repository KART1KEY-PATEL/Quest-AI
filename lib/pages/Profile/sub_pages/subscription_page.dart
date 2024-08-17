import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questias/providers/subscription_provider.dart';
import 'package:questias/utils/color.dart';
import 'package:questias/utils/customAppBar.dart';
import 'package:questias/utils/textUtil.dart';
import 'package:questias/widget/subscription_detail_widget.dart';

class SubscriptionPage extends StatelessWidget {
  SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    double sH = MediaQuery.of(context).size.height;
    double sW = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: customAppBar(
        title: "Subscription",
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios,            color: AppColors.backButtonColor,
),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: sW * 0.02,
          vertical: sH * 0.02,
        ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SubscriptionDetailsWidget(sH: sH, sW: sW),
            )
          ],
        ),
      ),
      floatingActionButton: Consumer<SubscriptionProvider>(
        builder: (context, controller, child) {
          return controller.selectedPlan != controller.currentPlan
              ? Container(
                  height: sH * 0.07,
                  width: sW * 0.9,
                  decoration: BoxDecoration(
                    color: AppColors.primaryButtonColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                      child: txt(
                    "Proceed To Payment",
                    weight: FontWeight.w600,
                    size: 20,
                  )),
                )
              : SizedBox();
        },
      ),
    );
  }
}
