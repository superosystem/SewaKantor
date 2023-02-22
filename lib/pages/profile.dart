import 'package:flutter/material.dart';

import '../widgets/item_info.dart';
import '../widgets/item_story.dart';
import '../widgets/item_tab.dart';
import '../widgets/profile_picture.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        title: Row(
          children: const [
            Text(
              "gusrylmubarok",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.black),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_box_outlined, color: Colors.black),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu, color: Colors.black),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                const ProfilePicture(),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      ItemInfo(title: 'Posts', value: '212'),
                      ItemInfo(title: 'Followers', value: '1.7k'),
                      ItemInfo(title: 'Following', value: '700'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "Agus S. Mubarok",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: RichText(
              text: TextSpan(
                  text: "Professional Problem Solver | ",
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: "#Developer",
                      style: TextStyle(color: Colors.blue),
                    )
                  ]),
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text("Link goes here", style: TextStyle(color: Colors.blue)),
          ),
          SizedBox(height: 5),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: OutlinedButton(
              onPressed: () {},
              child: Text(
                "Edit profile",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 5),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ItemStory(title: "Story 1"),
                    ItemStory(title: "Story 2"),
                    ItemStory(title: "Story 3"),
                    ItemStory(title: "Story 4"),
                    ItemStory(title: "Story 5"),
                    ItemStory(title: "Story 6"),
                  ],
                ),
              ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ItemTab(active: true, icon: Icons.grid_on_outlined,),
              ItemTab(active: false, icon: Icons.person_pin_outlined,),
            ],
          ),
          GridView.builder(
            shrinkWrap: true, // not work if in scroll view
            physics: NeverScrollableScrollPhysics(),
            itemCount: 212,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              itemBuilder: (context, index) => Image.network(
                  "https://picsum.photos/536/354",
                fit: BoxFit.cover
              ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label : "Home",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), label : "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_filter_rounded), label : "Feed",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_rounded), label : "Shop",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), label : "Account",
          ),
        ],
      ),
    );
  }
}


