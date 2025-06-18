import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:read_zone_app/data/repos/home_rep_impl.dart';
import 'package:read_zone_app/data/sections/Science.dart';
import 'package:read_zone_app/data/sections/business_section.dart';
import 'package:read_zone_app/data/sections/children.dart';
import 'package:read_zone_app/data/sections/children_content.dart';
import 'package:read_zone_app/data/sections/fiction_content.dart';
import 'package:read_zone_app/data/sections/home_tabs.dart';
import 'package:read_zone_app/data/sections/newarrival_section.dart';
import 'package:read_zone_app/data/sections/popular_books_section.dart';
import 'package:read_zone_app/data/sections/fiction.dart';
import 'package:read_zone_app/data/sections/science_content.dart';
import 'package:read_zone_app/screens/Popular_books.dart';
import 'package:read_zone_app/screens/business_content.dart';
import 'package:read_zone_app/services/Api_service.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:read_zone_app/widgets/newarrival_content.dart';
import 'package:read_zone_app/widgets/search_view.dart';

class HomepageContent extends StatelessWidget {
  const HomepageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : const Color(0xff4A536B);

    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          length: 5,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildAppTitle()),
              SliverToBoxAdapter(child: _buildSearchBar(context)),
              _buildSectionHeader(
                title: 'Popular now',
                onSeeAll: () => _navigateTo(const PopularBooks()),
                textColor: textColor,
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.23,
                  child: const PopularBooksSection(),
                ),
              ),
              SliverToBoxAdapter(child: const HomeTabs()), // تم نقل التابز هنا
              _buildSectionHeader(
                title: 'Fiction',
                onSeeAll: () => _navigateTo(FictionContent()),
                textColor: textColor,
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.23,
                  child: FicitionSection(),
                ),
              ),
              _buildSectionHeader(
                title: 'Children',
                onSeeAll: () => _navigateTo(ChildrenContent()),
                textColor: textColor,
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.23,
                  child: Children(),
                ),
              ),
              _buildSectionHeader(
                title: 'Science',
                onSeeAll: () => _navigateTo(scienceContent()),
                textColor: textColor,
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.23,
                  child: science(),
                ),
              ),
              _buildSectionHeader(
                title: 'New arrivals',
                onSeeAll: () => _navigateTo(NewarrivalContent(
                  homeRepo: HomeRepoImpl(ApiService2(Dio())),
                )),
                textColor: getGreyColor(context),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 200,
                  child: const NewArrivalsSection(),
                ),
              ),
              _buildSectionHeader(
                title: 'Classics',
                onSeeAll: () => _navigateTo(const BusinessContent()),
                textColor: getGreyColor(context),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: const BusinessSection(),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Center(
        child: Text(
          'READ ZONE',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final hintColor =
        isDarkMode ? Colors.black : const Color.fromARGB(116, 74, 83, 107);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        readOnly: true,
        onTap: () =>
            Get.to(() => const SearchView(), transition: Transition.topLevel),
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.search, color: hintColor),
          hintText: 'Search',
          hintStyle: GoogleFonts.inter(
            color: hintColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          filled: true,
          fillColor: isDarkMode ? Colors.white : Colors.transparent,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSectionHeader({
    required String title,
    required VoidCallback onSeeAll,
    required Color textColor,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: onSeeAll,
              child: Text(
                'See all >',
                style: GoogleFonts.inter(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateTo(Widget page) {
    Get.to(
      () => page,
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }
}
