import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/providers.dart';
import '../models/home_model.dart';
import '../providers/detail_data_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeDataAsync = ref.watch(homeDataProvider);

    return homeDataAsync.when(
      data: (data) => _buildHomeUI(data, context),
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error:
          (error, stackTrace) => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('에러: ${error.toString()}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.refresh(homeDataProvider),
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildHomeUI(ReportResponse data, BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '오늘도 화이팅, ${data.report.nickname}님! 🔥',
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReportCard(data.report),
            _buildSectionWithSeeAll(
              '최근',
              context,
              _buildRecentActivity(data.recentList),
            ),
            _buildSectionWithSeeAll(
              '즐겨찾기',
              context,
              _buildFavoriteWorkout(data.starList),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(Report report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '리포트',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.black),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildReportItem(
                Icons.local_fire_department,
                '${report.streakDays}일째',
              ),
              _buildReportItem(
                Icons.self_improvement,
                '${report.totalYogaCnt}개',
              ),
              _buildReportItem(
                Icons.access_time,
                '${(report.totalTime / 60).floor()}분',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(List<RecentItem> list) {
    return Column(
      children:
          list.map((activity) {
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  activity.image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                activity.sequenceName,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatTimeAgo(activity.updatedAt),
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: activity.percent / 100,
                    color: const Color(0xff7ECECA),
                    backgroundColor: const Color(0xffE8FAF1),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildFavoriteWorkout(List<StarItem> list) {
    return Column(
      children:
          list.map((item) {
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child:
                    item.image != null
                        ? Image.network(
                          item.image!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                        : const Icon(Icons.image_not_supported),
              ),
              title: Text(
                item.sequenceName,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Row(
                children: item.tagList.map((tag) => _buildTag(tag)).toList(),
              ),
              trailing: const Icon(Icons.star, color: Color(0xff7ECECA)),
            );
          }).toList(),
    );
  }

  Widget _buildSectionWithSeeAll(
    String title,
    BuildContext context,
    Widget content,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(title: title),
                    ),
                  );
                },
                child: const Text(
                  '전체보기',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xffD9D9D9),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        content,
      ],
    );
  }

  Widget _buildReportItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xff7ECECA), size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTag(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xffE8FAF1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(  
        text,
        style: const TextStyle(fontFamily: 'Pretendard', fontSize: 14),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final Duration diff = DateTime.now().difference(dateTime);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}분 전';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}시간 전';
    } else {
      return '${diff.inDays}일 전';
    }
  }
}

class DetailPage extends ConsumerWidget {
  final String title;

  const DetailPage({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(detailDataProvider(title));

    return Scaffold(
      appBar: AppBar(title: Text('$title 전체보기')),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('에러 발생: ${error.toString()}'),
        ),
        data: (data) => data.content.isEmpty
            ? const Center(child: Text('데이터가 없습니다.'))
            : ListView.builder(
                itemCount: data.content.length,
                itemBuilder: (context, index) {
                  final item = data.content[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: item.image != null
                          ? Image.network(item.image!, width: 60, fit: BoxFit.cover)
                          : const Icon(Icons.image_not_supported),
                      title: Text(item.sequenceName),
                      subtitle: Text(item.tagList.join(' · ')),
                      trailing: Icon(
                        item.star ? Icons.star : Icons.star_border,
                        color: item.star ? Colors.orange : null,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}