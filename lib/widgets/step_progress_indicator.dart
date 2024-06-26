import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';

class ExampleStepProgressIndicator extends StatelessWidget {
  final int step;
  const ExampleStepProgressIndicator({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 24,right: 24),
            child: StepProgressIndicator(
              padding:6,
               roundedEdges: const Radius.circular(10),
              customSize:(p0, p1) => 3,
              totalSteps: 2,
              currentStep: step,
              selectedColor: Theme.of(context).brightness == Brightness.dark
                              ? Color(0xff2CC36B)
                              : AppColors.confirmValid,
              unselectedColor:Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkTextInput
                              :  AppColors.nondotcolor,
            ),
          ),
        ],
     
    );
  }
}
