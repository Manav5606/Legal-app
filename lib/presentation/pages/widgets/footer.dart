import 'package:admin/core/constant/colors.dart';
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.blueColor,
      height: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Are you client wanting to connect with us?"),
              Text(
                  "Lorem ipsum dolor sit amet consectetur adipisicing elit. Assumenda placeat similique dolore aperiam ad a sunt molestiae debitis molestias. At id consequatur laudantium dolore quo asperiores earum cupiditate, maxime aperiam?"),
            ],
          ),
          Center(
              child:
                  TextButton(onPressed: () {}, child: Text("Log In / SignUp")))
        ],
      ),
    );
  }
}
