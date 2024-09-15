import 'package:farm_tech/backend/model/review.dart';
import 'package:farm_tech/backend/services/review_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/widgets/widgets.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';

class FeedbackView extends StatefulWidget {
  FeedbackView(
      {required this.reviewModel, required this.checkOrderReviewExists});

  ReviewModel reviewModel;
  VoidCallback checkOrderReviewExists;

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  int starsCount = 0;

  final _formKey = GlobalKey<FormState>();

  final _textFieldController = TextEditingController();

  bool showStarsError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.getAppBar('Feedback', [], context),
      backgroundColor: Utils.whiteColor,
      body: _getBody(),
    );
  }

  _getBody() {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 120,
        // main screen column with padding
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  // divider
                  Utils.divider,

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                i + 1 <= starsCount
                                    ? Icons.star
                                    : Icons.star_outline,
                                color: i + 1 <= starsCount
                                    ? Utils.greenColor
                                    : Utils.greyColor,
                                size: 50,
                              ),
                            ),
                        ],
                      ),

                      // space
                      showStarsError
                          ? SizedBox(
                              height: 10,
                            )
                          : SizedBox(
                              height: 20,
                            ),

                      showStarsError
                          ? Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                'Rating is required',
                                style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 167, 46, 37),
                                    fontSize: 12),
                              ),
                            )
                          : SizedBox(),

                      // space
                      showStarsError
                          ? SizedBox(
                              height: 20,
                            )
                          : SizedBox(),

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
                                if (value!.trim().isEmpty) {
                                  return 'Review is required';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ])),

                      // space
                      // SizedBox(
                      //   height: 20,
                      // ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  // post feedback button
                  CustomButton(
                    onButtonPressed: () async {
                      if (starsCount == 0) {
                        setState(() {
                          showStarsError = true;
                        });
                      }
                      // if form is valid
                      if (_formKey.currentState!.validate() &&
                          starsCount != 0) {
                        setState(() {
                          showStarsError = false;
                        });
                        // show loading alert
                        Utils.showLoadingAlertDialog(context, 'post_feedback');

                        // create product review for this user
                        final result =
                            await ReviewServices().createReview(ReviewModel(
                          review: _textFieldController.text.toString().trim(),
                          starsCount: starsCount.toString(),
                          buyerId: widget.reviewModel.buyerId,
                          productId: widget.reviewModel.productId,
                          sellerId: widget.reviewModel.sellerId,
                          orderId: widget.reviewModel.orderId,
                        ));

                        if (result == null) {
                          floatingSnackBar(
                              message:
                                  'Error posting feedback. Please try again later.',
                              context: context);
                        } else {
                          floatingSnackBar(
                              message: 'Feedback posted successfully',
                              context: context);
                        }

                        // close loading alert
                        Navigator.pop(context);

                        // close screen
                        Navigator.pop(context);

                        // close order details bottom sheet
                        Navigator.pop(context);

                        // update order review exists status
                        widget.checkOrderReviewExists();
                      }
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
                  Center(
                    child: GestureDetector(
                        onTap: () {
                          // close feedback screen
                          Navigator.pop(context);
                          // close order details bottom sheet
                          // Navigator.pop(context);
                        },
                        child: Text(
                          'Back to Orders',
                          style: Utils.kAppBody2MediumStyle,
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
