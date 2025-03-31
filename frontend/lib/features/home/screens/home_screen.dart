import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/providers.dart';
import 'package:go_router/go_router.dart';
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
              _buildRecentActivity(data.recentList, context),
            ),
            _buildSectionWithSeeAll(
              '즐겨찾기',
              context,
              _buildFavoriteWorkout(data.starList, context),
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
          BoxShadow(
            color: Colors.grey.withValues(
              red: 128,
              green: 128,
              blue: 128,
              alpha: 0.2,
            ),
            blurRadius: 5,
          ),
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

  Widget _buildRecentActivity(List<RecentItem> list, BuildContext context) {
    return Column(
      children:
          list.map((activity) {
            return InkWell(
              onTap: () {
                context.push('/sequence/${activity.sequenceId}');
              },
              child: ListTile(
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
              ),
            );
          }).toList(),
    );
  }

  Widget _buildFavoriteWorkout(List<StarItem> list, BuildContext context) {
    return Column(
      children:
          list.map((item) {
            return InkWell(
              onTap: () {
                context.push('/sequence/${item.sequenceId}');
              },
              child: ListTile(
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
              ),
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
                  context.push('/home/detail/$title');
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) =>
                Center(child: Text('에러 발생: ${error.toString()}')),
        data:
            (data) =>
                data.content.isEmpty
                    ? const Center(child: Text('데이터가 없습니다.'))
                    : ListView.builder(
                      itemCount: data.content.length,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemBuilder: (context, index) {
                        final item = data.content[index];

                        // 최근 시퀀스용 UI
                        if (title == '최근') {
                          return InkWell(
                            onTap: () {
                              context.push('/sequence/${item.sequenceId}');
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 24),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          item.image ?? '',
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: CircleAvatar(
                                          radius: 10,
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            item.resultStatus == 'Y'
                                                ? Icons.check_circle
                                                : Icons.more_horiz,
                                            size: 16,
                                            color:
                                                item.resultStatus == 'Y'
                                                    ? const Color(0xff7ECECA)
                                                    : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.sequenceName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _formatTimeAgo(item.updatedAt),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Text(
                                              '${item.percent}%',
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: LinearProgressIndicator(
                                                value:
                                                    (item.percent ?? 0) / 100,
                                                color: const Color(0xff7ECECA),
                                                backgroundColor: const Color(
                                                  0xffE8FAF1,
                                                ),
                                                minHeight: 4,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        // 즐겨찾기 UI
                        return InkWell(
                          onTap: () {
                            context.push('/sequence/${item.sequenceId}');
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child:
                                      item.image != null
                                          ? Image.network(
                                            item.image!,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                          )
                                          : Container(
                                            width: 60,
                                            height: 60,
                                            color: Colors.grey[300],
                                            child: const Icon(
                                              Icons.image_not_supported,
                                            ),
                                          ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.sequenceName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 4,
                                        children:
                                            item.tagList
                                                .map(
                                                  (tag) => Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFFE8FAF1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      tag,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(
                                    item.star ? Icons.star : Icons.star_border,
                                    color:
                                        item.star
                                            ? const Color(0xff7ECECA)
                                            : Colors.grey,
                                  ),
                                  onPressed: () async {
                                    try {
                                      final homeService = ref.read(
                                        homeServiceProvider,
                                      );
                                      await homeService.toggleStar(
                                        item.sequenceId,
                                      );

                                      // UI 토글 (리스트를 setState처럼 갱신해야 할 경우)
                                      ref.invalidate(detailDataProvider(title));
                                    } catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('즐겨찾기 변경에 실패했습니다.'),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
      ),
    );
  }
}

String _formatTimeAgo(DateTime? dateTime) {
  if (dateTime == null) return '날짜 없음';
  final diff = DateTime.now().difference(dateTime);
  if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
  if (diff.inHours < 24) return '${diff.inHours}시간 전';
  return '${diff.inDays}일 전';
}
