import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/presentation/pages/widgets/circular_arrow.dart';
import 'package:admin/presentation/pages/widgets/cta_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircularArrow(),
            Column(
              children: [
                SizedBox(
                  width: 400,
                  child: Text(news.title,
                      textAlign: TextAlign.left,
                      style: FontStyles.font14Semibold
                          .copyWith(color: AppColors.blackLightColor)),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        DateFormat('MM-dd-yyyy').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                news.createdAt! * 1000)),
                        // textAlign: TextAlign.start,
                        style: FontStyles.font14Bold
                            .copyWith(color: AppColors.blackLightColor)),
                    // const CTAButton(title: "Read More", radius: 100),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
