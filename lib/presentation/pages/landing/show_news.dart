import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/provider.dart';
import 'package:intl/intl.dart';
import 'package:admin/presentation/pages/landing/landing_page_view_model.dart';
import 'package:admin/presentation/pages/widgets/banner.dart';
import 'package:admin/presentation/pages/widgets/custom_mobile_drawer.dart';
import 'package:admin/presentation/pages/widgets/footer.dart';
import 'package:admin/presentation/pages/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../widgets/circular_arrow.dart';
import '../widgets/freeze_header.dart';
import '../widgets/news_tile.dart';

final landingScaffold = GlobalKey<ScaffoldState>();

class ShowNews extends ConsumerStatefulWidget {
  static const String routeName = "/news";

  const ShowNews({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShowNewsState();
}

class _ShowNewsState extends ConsumerState<ShowNews> {
  late bool isAuthenticated;

  late final LandingPageViewModel _viewModel;

  @override
  void initState() {
    _viewModel = ref.read(LandingPageViewModel.provider);
    _viewModel.fetchNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isAuthenticated = ref.watch(AppState.auth).isAuthenticated;
    ref.watch(LandingPageViewModel.provider);
    return Scaffold(
      key: landingScaffold,
      endDrawerEnableOpenDragGesture: false,
      endDrawer: CustomMobileDrawer(categories: _viewModel.getCategories),
      backgroundColor: AppColors.whiteColor,
      body: _viewModel.isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : ScreenTypeLayout.builder(
              mobile: (context) => CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    delegate:
                        CustomSliverPersistentHeaderDelegate(mobile: true),
                    floating: false,
                    pinned: true,
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                  // Visibility(
                  //   visible: _viewModel.getBanners.isNotEmpty,
                  //   child: BannerSlides(
                  //     mobile: true,
                  //     height: 250,
                  //     bannerDetails: _viewModel.getBanners,
                  //   ),
                  // ),

                  _newsAndUpdates(800),

                  // const ContactUs(height: 250, mobile: true),
                  const Footer(),
                    ],),),
                ],
              ),
              desktop: (context) => CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    delegate:
                        CustomSliverPersistentHeaderDelegate(mobile: false),
                    floating: false,
                    pinned: true,
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                  // Visibility(
                  //   visible: _viewModel.getBanners.isNotEmpty,
                  //   child: BannerSlides(
                  //     mobile: false,
                  //     height: 700,
                  //     bannerDetails: _viewModel.getBanners,
                  //   ),
                  // ),

                  _newsAndUpdates(800),

                  // const ContactUs(height: 250),
                  // ContactUsCard(
                  //     contactDetails: _viewModel.getContacts, height: 250),
                  const Footer(),
                      ],),),
                ],
              ),
            ),
    );
  }

  Widget _newsAndUpdates(double height) {
    return SizedBox(
      height: height,
      width: height * 1.6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(height: 18),
                  Text("Recent news and updates",
                      textAlign: TextAlign.center,
                      style: FontStyles.font24Semibold
                          .copyWith(color: AppColors.blackColor, fontSize: 32)),
                  const SizedBox(height: 18),
                  ..._viewModel.getNews.map((e) => NewsTile(news: e)).toList(),
                  const SizedBox(height: 18),
                  // const CTAButton(title: "Show all", radius: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
