import 'package:flutter/material.dart';
import 'package:roadwise_application/features/presentation/pages/Notification_page/notification_page.dart';
import 'package:roadwise_application/features/presentation/pages/home_page/home_page.dart';
import 'package:roadwise_application/features/presentation/pages/jobs_page/jobs_page.dart';
import 'package:roadwise_application/features/presentation/pages/my_network_page/my_network_page.dart';
import 'package:roadwise_application/features/presentation/pages/post_page/post_page.dart';
import 'package:roadwise_application/features/presentation/widgets/app_bar_widget.dart';
import 'package:roadwise_application/features/presentation/widgets/drawer_widget.dart';
import 'package:roadwise_application/global/style.dart';
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentPageIndex = 0;
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      drawer: const DrawerWidget(),
      appBar: _currentPageIndex ==4?appBarWidget(title: "Search Jobs",isJobTab: true,onTap: (){setState(() {
        _scaffoldState.currentState!.openDrawer();
      });}): appBarWidget(
        title: "Search",
        isJobTab: false,
          onTap: (){setState(() {
            _scaffoldState.currentState!.openDrawer();
          });}
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (index){
          setState(() {
            _currentPageIndex = index;
          });
        },
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor:primaryBlueColor,
        selectedLabelStyle: TextStyle(color: primaryBlueColor,fontSize: 12,fontWeight: FontWeight.bold),
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: const TextStyle(color: Colors.grey,fontSize: 12),
        showUnselectedLabels: false,

        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Network",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Post",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notification",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: "Jobs",
          ),
        ],
      ),
      body: _switchPage(_currentPageIndex),
    );
  }
  _switchPage(int index){
    switch (index) {
      case 0:
        {
          return const HomePage();
        }case 1:
        {
          return const MyNetworkPage();
        }case 2:
        {
          return const PostPage(
          );
        }case 3:
        {
          return const NotificationPage();
        }case 4:
        {
          return const JobsPage();
        }
    }
  }
}
