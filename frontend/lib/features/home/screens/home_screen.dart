import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '오늘도 화이팅, 다이님! 🔥',
          style: TextStyle(fontFamily: 'Pretendard', 
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReportCard(context),
            _buildSectionWithSeeAll('최근', context, _buildRecentActivity()),
            _buildSectionWithSeeAll('즐겨찾기', context, _buildFavoriteWorkout()),
            _buildSectionWithSeeAll('커스텀 세트', context, _buildCustomSetGrid()),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildReportCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReportDetailPage()),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '리포트',
                  style: TextStyle(fontFamily: 'Pretendard', fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.chevron_right, color: Colors.black),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildReportItem(Icons.local_fire_department, '2일째'),
                _buildReportItem(Icons.self_improvement, '3193개'),
                _buildReportItem(Icons.access_time, '4시간'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Color(0xff7ECECA), size: 28),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSectionWithSeeAll(String title, BuildContext context, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 16, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontFamily: 'Pretendard', fontSize: 24, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailPage(title: title)),
                  );
                },
                child: Text(
                  '전체보기',
                  style: TextStyle(fontSize: 14, color: Color(0xffD9D9D9), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        content,
      ],
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      children: recentActivities.map((activity) {
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(activity['image'], width: 50, height: 50, fit: BoxFit.cover),
          ),
          title: Text(activity['title'], style: TextStyle(fontFamily: 'Pretendard', fontSize: 16, fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(activity['time'], style: TextStyle(fontFamily: 'Pretendard', fontSize: 14)),
              SizedBox(height: 4),
              LinearProgressIndicator(value: activity['progress'], color: Color(0xff7ECECA), backgroundColor: Color(0xffE8FAF1)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFavoriteWorkout() {
    return Column(
      children: favoriteWorkouts.map((workout) {
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(workout['image'], width: 50, height: 50, fit: BoxFit.cover),
          ),
          title: Text(workout['title'], style: TextStyle(fontFamily: 'Pretendard', fontSize: 16, fontWeight: FontWeight.bold)),
          subtitle: Row(
            children: workout['tags'].map<Widget>((tag) => _buildTag(tag)).toList(),
          ),
          trailing: Icon(Icons.star, color: Color(0xff7ECECA)),
        );
      }).toList(),
    );
  }

  Widget _buildCustomSetGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: customSets.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5)],
          ),
          child: Center(
            child: Text(customSets[index], style: TextStyle(fontFamily: 'Pretendard', fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: '둘러보기'),
        BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: '활동'),
        BottomNavigationBarItem(icon: Icon(Icons.videogame_asset), label: '게임하기'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: '내 정보'),
      ],
    );
  }

  Widget _buildTag(String text) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xffE8FAF1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(text, style: TextStyle(fontFamily: 'Pretendard', fontSize: 14)),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String title;

  DetailPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('$title 상세 페이지'),
      ),
    );
  }
}

class ReportDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('리포트 상세 페이지')),
      body: Center(
        child: Text('여기에 리포트 상세 내용을 표시하세요.'),
      ),
    );
  }
}