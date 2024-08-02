import 'package:farm_tech/backend/model/review.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/seller/shop/widgets/widgets.dart';
import 'package:flutter/material.dart';

class RatingsReviewsView extends StatelessWidget {
  RatingsReviewsView({required this.reviews});

  List<ReviewModel> reviews;

  // time ago function to calculate and return how much time has passed since the review posted
  String timeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

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
    return Scaffold(
      appBar: Utils.getAppBar('Ratings & Reviews', [], context),
      body: _getBody(context),
      backgroundColor: Utils.whiteColor,
    );
  }

  _getBody(context) {
    // product ratings & reviews
    return Column(
        children: reviews.map((reviewModel) {
      return SingleUserRatingCard(
          reviewModel: reviewModel,
          timeAgo: timeAgo(reviewModel.createdAt!.toDate()));
    }).toList());
  }
}
