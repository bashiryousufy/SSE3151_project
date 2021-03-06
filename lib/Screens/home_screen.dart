import 'package:flutter/material.dart';
import 'package:project/Screens/cloud_docs_screen.dart';
import 'package:project/Screens/folders_screen.dart';
import 'package:project/Screens/signin_screen.dart';

class HomeScreen extends StatefulWidget {
  String? authUserEmail;

  HomeScreen({Key? key, this.authUserEmail}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            height: 50.0,
            child: new TabBar(
              indicatorColor: Colors.black,
              unselectedLabelColor: Colors.black38,
              labelColor: Colors.black,
              controller: tabController,
              tabs: [
                Tab(
                  text: "Local Docs",
                ),
                Tab(
                  text: "Cloud Docs",
                ),
              ],
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.person),
          color: Colors.black,
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
        ),
        title: Text("My Documents"),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: TabBarView(
        children: [
          FolderScreen(),
          CloudDocsScreen(
            authUserEmail: widget.authUserEmail,
          ),
        ],
        controller: tabController,
      ),
    );
  }
}
