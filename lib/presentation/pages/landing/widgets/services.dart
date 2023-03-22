import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/constant/resource.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/widgets/service_container.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Services extends StatelessWidget {
  final double height;
  Services({super.key, required this.height});
  final _category = [
    Category(
      id: "b",
      name: "Business",
      iconUrl: "",
      description:
          "I have used multiple offline & online CAs/ Lawyers. LegalRaasta clearly provided the best service and fast. Their team helped me protect my brand with trademark registration.",
      addedAt: DateTime.now().millisecondsSinceEpoch,
      addedBy: "",
    ),
    Category(
      id: "f",
      name: "finance",
      iconUrl: "",
      description:
          "I have used multiple offline & online CAs/ Lawyers. LegalRaasta clearly provided the best service and fast. Their team helped me protect my brand with trademark registration.",
      addedAt: DateTime.now().millisecondsSinceEpoch,
      addedBy: "",
    ),
    Category(
      id: "l",
      name: "legal",
      iconUrl: "",
      description:
          "I have used multiple offline & online CAs/ Lawyers. LegalRaasta clearly provided the best service and fast. Their team helped me protect my brand with trademark registration.",
      addedAt: DateTime.now().millisecondsSinceEpoch,
      addedBy: "",
    ),
    Category(
      id: "a",
      name: "Advertisment",
      iconUrl: "",
      description:
          "I have used multiple offline & online CAs/ Lawyers. LegalRaasta clearly provided the best service and fast. Their team helped me protect my brand with trademark registration.",
      addedAt: DateTime.now().millisecondsSinceEpoch,
      addedBy: "",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      desktop: (context) => SizedBox(
        height: height,
        child: Stack(
          children: [
            SizedBox(
              height: height * 0.55,
              width: double.infinity,
              child: Image.asset(
                Assets.servicesBGDesign,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: height * 1.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _title(),
                        const Spacer(),
                        _subtitle(),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _category
                          .map((category) => ServiceContainer(
                              category: category, width: height * 1.6))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      mobile: (context) => Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Assets.servicesBGDesign), fit: BoxFit.cover)),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: ListView(
            primary: false,
            shrinkWrap: true,
            children: [
              _title(mobile: true),
              const SizedBox(height: 8),
              _subtitle(mobile: true),
              const SizedBox(height: 14),
              ..._category
                  .map((category) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ServiceContainer(
                            category: category, width: double.infinity),
                      ))
                  .toList()
            ],
          ),
        ),
      ),
    );
  }

  Text _subtitle({bool mobile = false}) {
    return Text(
        "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem \nIpsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum",
        textAlign: TextAlign.left,
        style: FontStyles.font14Semibold.copyWith(
            color: AppColors.blackLightColor, fontSize: mobile ? 12 : 14));
  }

  Text _title({bool mobile = false}) {
    return Text("Get the best services ${mobile ? '' : '\n'}we offer",
        textAlign: TextAlign.left,
        style: FontStyles.font24Semibold
            .copyWith(color: AppColors.blackColor, fontSize: mobile ? 18 : 32));
  }
}
