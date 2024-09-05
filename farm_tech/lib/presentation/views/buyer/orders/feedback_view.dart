import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/widgets/widgets.dart';
import 'package:flutter/material.dart';

class FeedbackView extends StatefulWidget {
  const FeedbackView({super.key});

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  int starsCount = 0;

  final _formKey = GlobalKey<FormState>();

  final _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.getAppBar('Feedback', [], context),
      backgroundColor: Utils.whiteColor,
      body: _getBody(),
    );
  }

  _getBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // divider
        Utils.divider,

        // space
        SizedBox(
          height: 20,
        ),

        // text
        Text(
          'Rate your experience with this seller',
          style: Utils.kAppBody3MediumStyle,
        ),

        // space
        SizedBox(
          height: 20,
        ),

        // stars
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < 5; i++)
              GestureDetector(
                onTap: () {
                  setState(() {
                    starsCount = i + 1;
                  });
                },
                child: Icon(
                  Icons.star_outline,
                  color:
                      i + 1 <= starsCount ? Utils.greenColor : Utils.greyColor,
                  size: 40,
                ),
              ),
          ],
        ),

        // space
        SizedBox(
          height: 20,
        ),

        // review text field
        Form(
            key: _formKey,
            child: Column(children: [
              // address field with initial value as current address
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                controller: _textFieldController,
                decoration: Utils.inputFieldDecoration
                    .copyWith(hintText: "Submit your reviews"),
                minLines: 4,
                maxLines: 4,
                style: Utils.kAppBody3MediumStyle,
                validator: (value) {
                  // if (value!.isEmpty) {
                  //   return 'Review is required';
                  // } else {
                  //   return null;
                  // }
                  return null;
                },
              ),
            ])),

        CustomButton(
          onButtonPressed: () {
            // close screen
            Navigator.pop(context);
          },
          buttonText: 'Post Feedback',
          primaryButton: true,
          secondaryButton: false,
          buttonHeight: 60,
          buttonWidth: MediaQuery.of(context).size.width,
        ),

        // space
        SizedBox(
          height: 28,
        ),

        // back to home button
        GestureDetector(
            onTap: () {
              // close feedback screen
              Navigator.pop(context);
              // close order details bottom sheet
              Navigator.pop(context);
            },
            child: Text(
              'Back to Orders',
              style: Utils.kAppBody2MediumStyle,
            )),
      ],
    );
  }
}
