import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/presentation/pages/landing/news_detail.dart';
import 'package:admin/presentation/pages/widgets/circular_arrow.dart';
import 'package:admin/presentation/pages/widgets/cta_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';
import '../../../data/models/news.dart';

class NewsTile extends StatelessWidget {
  final News news;
  const NewsTile({
    super.key,
    required this.news,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO
        Routemaster.of(context).replace(
          NewsDetail.routeName,
          queryParameters: {
            "title": news.title,
            "desc": news.description,
            "createdAt": news.createdAt.toString()
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircularArrow(),
              const SizedBox(
                width: 20,
              ),
              Column(
                children: [
                  SizedBox(
                    width: 400,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(news.title,
                          style: FontStyles.font14Semibold
                              .copyWith(color: AppColors.blueColor)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 400,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                          DateFormat('MM-dd-yyyy').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  news.createdAt! * 1000)),
                          // textAlign: TextAlign.start,
                          style: FontStyles.font14Bold
                              .copyWith(color: AppColors.blueColor)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
