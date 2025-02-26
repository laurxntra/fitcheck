import 'package:flutter/material.dart';
  import 'home_page.dart'; 


class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildTopBar(context),
          Expanded(
            child: ListView(
              children: [
                Column(
                  children: [
                    _buildHeader(),
                    _buildProfileInfo(),
                    _buildButtons(),
                    _buildTabBar(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


Widget _buildTopBar(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 70, left: 16, right: 16, bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.group, color: Color(0xffd0addc), size: 28),
          onPressed: () {
            // Add functionality if needed
          },
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
          child: Image.asset(
            'assets/FitCheck.png',
            height: 75,
            fit: BoxFit.contain,
          ),
        ),
        GestureDetector(
          onTap: () {
            // Add functionality if needed
          },
          child: const CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xffd0addc),
            child: Icon(Icons.person, color: Colors.white, size: 26),
          ),
        ),
      ],
    ),
  );
}


  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Color(0xffd0addc),
            child: Icon(Icons.person, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                'name display',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Text(
                '@username',
                style: TextStyle(fontSize: 15),
              ),
              Text('Insert bio here'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildProfileInfoItem('Posts', '120'),
          _buildProfileInfoItem('Followers', '1.2M'),
          _buildProfileInfoItem('Following', '1'),
          _buildProfileInfoItem('Awards', '1000'),
        ],
      ),
    );
  }

  Widget _buildProfileInfoItem(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(label),
      ],
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff872626),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Edit Profile',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            indicatorColor: Color(0xff872626),
            labelColor: Color(0xff872626),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(icon: Icon(Icons.grid_on)),
              Tab(icon: Icon(Icons.favorite)),
            ],
          ),
          SizedBox(
            height: 400,
            child: TabBarView(
              children: [
                _buildProfileGrid(),
                const Center(child: Text('Favorites')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: 30,
      itemBuilder: (context, index) {
        return Container(
          color: Colors.grey[300],
        );
      },
    );
  }
}
