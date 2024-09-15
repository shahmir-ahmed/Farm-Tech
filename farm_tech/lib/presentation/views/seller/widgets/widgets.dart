import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_tech/backend/model/buyer.dart';
import 'package:farm_tech/backend/model/review.dart';
import 'package:farm_tech/backend/services/buyer_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/seller/widgets/ratings_reviews_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ratings and reviews section inside item details view and seller profile tab
class RatingsReviewsSection extends StatefulWidget {
  RatingsReviewsSection({super.key});
  RatingsReviewsSection.forSellerProfileTab({this.forSellerProfileTab = true});

  bool? forSellerProfileTab;

  @override
  State<RatingsReviewsSection> createState() => _RatingsReviewsSectionState();
}

class _RatingsReviewsSectionState extends State<RatingsReviewsSection> {
  // time ago function to calculate and return how much time has passed since the review posted
  String timeAgo(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate(); // Convert Timestamp to DateTime

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}mo';
    } else {
      return '${(difference.inDays / 365).floor()}y';
    }
  }

  @override
  Widget build(BuildContext context) {
    // consume reviews stream here
    final reviews = Provider.of<List<ReviewModel>?>(context);

    return reviews == null
        ? const SizedBox(height: 100, child: Utils.circularProgressIndicator)
        : reviews.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  widget.forSellerProfileTab != null
                      ? ''
                      : 'No ratings & reviews for the product.',
                  style: Utils.kAppBody2MediumStyle,
                ),
              )
            // ratings and reviews
            : Column(
                children: [
                  // label
                  Padding(
                      padding: EdgeInsets.fromLTRB(
                          widget.forSellerProfileTab != null ? 25 : 30,
                          widget.forSellerProfileTab != null ? 15 : 20,
                          widget.forSellerProfileTab != null ? 25 : 30,
                          widget.forSellerProfileTab != null ? 15 : 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ratings & Reviews',
                            style: Utils.kAppBody3MediumStyle,
                          ),

                          // see all
                          GestureDetector(
                              onTap: () {
                                // show all ratings and reviews of product screen
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RatingsReviewsView(
                                              reviews: reviews,
                                            )));
                              },
                              child: Text(
                                'See all',
                                style: Utils.kAppCaptionRegularStyle
                                    .copyWith(color: Utils.greenColor),
                              )),
                        ],
                      )),

                  widget.forSellerProfileTab != null
                      ? Utils.divider
                      : SizedBox(),

                  // user reviews section
                  Column(
                    children: reviews.map((reviewModel) {
                      return SingleUserRatingCard(
                        reviewModel: reviewModel,
                        timeAgo: timeAgo(reviewModel.createdAt!),
                      );
                    }).toList(),
                  ),
                ],
              );
  }
}

// single user rating card
class SingleUserRatingCard extends StatefulWidget {
  SingleUserRatingCard(
      {required this.reviewModel,
      required this.timeAgo,
      this.noPadding,
      this.noBottomDivider});

  ReviewModel reviewModel;
  String timeAgo;
  bool? noPadding;
  bool? noBottomDivider;

  @override
  State<SingleUserRatingCard> createState() => _SingleUserRatingCardState();
}

class _SingleUserRatingCardState extends State<SingleUserRatingCard> {
  BuyerModel buyerModel = BuyerModel(profileImageUrl: "", name: "");

  getuserProfileImage() async {
    final result = await BuyerServices()
        .getProfileImage(BuyerModel(docId: widget.reviewModel.buyerId));

    if (result != null) {
      setState(() {
        buyerModel.profileImageUrl = result;
      });
    }
  }

  getuserName() async {
    final result = await BuyerServices()
        .getName(BuyerModel(docId: widget.reviewModel.buyerId));

    if (result != null) {
      setState(() {
        buyerModel.name = result;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuserProfileImage();
    getuserName();
  }

  @override
  Widget build(BuildContext context) {
    // individual user rating column
    return Column(
      children: [
        Padding(
          padding: widget.noPadding != null
              ? const EdgeInsets.all(0)
              : const EdgeInsets.all(30.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // user image
              buyerModel.profileImageUrl!.isEmpty
                  ? Utils.circularProgressIndicator
                  : CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(
                        buyerModel.profileImageUrl!,
                      ),
                    ),

              // space
              const SizedBox(
                width: 8,
              ),

              // column
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // user name
                        Text(
                          buyerModel.name!.isEmpty ? "..." : buyerModel.name!,
                          style: Utils.kAppBody3MediumStyle,
                        ),

                        // stars
                        Row(
                          children: List.generate(
                              int.parse(widget.reviewModel.starsCount!),
                              (index) {
                            return const Icon(
                              Icons.star,
                              color: Utils.greenColor,
                              size: 19,
                            );
                          }),
                          // children: [1, 2, 3, 4, 5].map((index) {
                          //   return const Icon(
                          //     Icons.star,
                          //     color: Utils.greenColor,
                          //     size: 19,
                          //   );
                          // }).toList(),
                        ),
                      ],
                    ),

                    // time
                    Text(
                      '${widget.timeAgo} ago',
                      style: Utils.kAppCaptionRegularStyle
                          .copyWith(color: Utils.greyColor),
                    ),

                    // space
                    const SizedBox(
                      height: 10,
                    ),

                    // review
                    Text(
                      widget.reviewModel.review as String,
                      style: Utils.kAppBody3RegularStyle,
                    )
                  ],
                ),
              )
            ],
          ),
        ),

        // divider
        // not show divider for last review
        // index == 4
        //     ? const SizedBox()
        //     :
        widget.noBottomDivider != null ? SizedBox() : Utils.divider
      ],
    );
  }
}
