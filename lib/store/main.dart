import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:read_zone_app/store/pages/book_list_page.dart';

class StoreHomepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 200,
                floating: false, // يختفي عند التمرير لأسفل
                pinned: false, //لا يبقي مثبتا
                snap: false, // يظهر فورا عند التمرير لأعلى ا
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: CustomAppBar(),
                ),
              ),
              BookListPage(),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(isDarkMode
                  ? 'images/appbar_dark.png'
                  : 'images/appbar_light.png'),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),
        ),
        Positioned(
          top: 50,
          left: -10,
          right: 0,
          child: Text(
            'READ ZONE',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
