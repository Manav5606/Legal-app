import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/presentation/pages/landing/news_detail.dart';
import 'package:admin/presentation/pages/widgets/circular_arrow.dart';
import 'package:admin/presentation/pages/widgets/cta_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';
import '../../../data/models/news.dart';
// import 'dart:io' show Platform;

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
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: 900,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularArrow(),
                const SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 20,
                    children: [
                      Container(
                        // color: AppColors.yellowColor
                        width: 900,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            news.title,
                            style: FontStyles.font14Semibold
                                .copyWith(color: AppColors.blueColor),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          DateFormat('MM-dd-yyyy').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                news.createdAt! * 1000),
                          ),
                          style: FontStyles.font14Bold
                              .copyWith(color: AppColors.blueColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
