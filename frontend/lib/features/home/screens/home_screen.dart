import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/core/providers/providers.dart';
import 'package:frontend/features/alarm/widgets/alarm_icon_button.dart';
import 'package:frontend/widgets/tag.dart';
import 'package:go_router/go_router.dart';

import '../models/home_model.dart';
import '../providers/detail_data_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 홈화면 진입 시 최신 데이터로 invalidate
    ref.invalidate(homeDataProvider);
  }

  @override
  Widget build(BuildContext context) {
    final homeDataAsync = ref.watch(homeDataProvider);

    return homeDataAsync.when(
      data: (data) => _buildHomeUI(data, context),
      loading:
          () => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: Colors.transparent,
          toolbarHeight: 80,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              '오늘도 화이팅, ${data.report.nickname}님! 🔥',
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: AlarmIconButton(),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReportCard(data.report, context),
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
      ),
    );
  }

  Widget _buildReportCard(Report report, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.boxWhite,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '리포트',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // 외부 스크롤뷰와 충돌 방지
      itemCount: list.length,
      itemBuilder: (context, index) {
        final activity = list[index];
        return InkWell(
          onTap: () {
            context.push('/sequence/${activity.sequenceId}');
          },
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
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
      },
    );
  }

  Widget _buildFavoriteWorkout(List<StarItem> list, BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return InkWell(
          onTap: () {
            context.push('/sequence/${item.sequenceId}');
          },
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
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
            title: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                item.sequenceName,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            subtitle: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Row(
                    children:
                        item.tagList
                            .map(
                              (tag) => Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Tag(label: tag),
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),
            trailing: const Icon(Icons.star_rounded, color: Color(0xff7ECECA)),
          ),
        );
      },
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
          padding: const EdgeInsets.only(top: 32, bottom: 16),
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

class DetailPage extends ConsumerStatefulWidget {
  final String title;

  const DetailPage({super.key, required this.title});

  @override
  ConsumerState<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 진입 시마다 최신화
    ref.invalidate(detailDataProvider(widget.title));
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(detailDataProvider(widget.title));

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          toolbarHeight: 80,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 25),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
              onPressed: () => context.pop(),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 24,
              ),
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
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemBuilder: (context, index) {
                          final item = data.content[index];

                          if (widget.title == '최근') {
                            return _buildRecentItem(context, item);
                          } else {
                            return _buildStarItem(context, item);
                          }
                        },
                      ),
        ),
      ),
    );
  }

  Widget _buildRecentItem(BuildContext context, dynamic item) {
    return InkWell(
      onTap: () {
        context.push('/sequence/${item.sequenceId}');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 25, left: 25, right: 25),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      item.sequenceName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTimeAgo(item.updatedAt),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${item.percent}%',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: (item.percent ?? 0) / 100,
                          color: const Color(0xff7ECECA),
                          backgroundColor: const Color(0xffE8FAF1),
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

  Widget _buildStarItem(BuildContext context, dynamic item) {
    return InkWell(
      onTap: () {
        context.push('/sequence/${item.sequenceId}');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 25, left: 25, right: 25),
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
                        child: const Icon(Icons.image_not_supported),
                      ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      item.sequenceName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          item.tagList
                              .map<Widget>(
                                (tag) => Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffE8FAF1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    tag,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                item.star ? Icons.star_rounded : Icons.star_border_rounded,
                color: item.star ? const Color(0xff7ECECA) : Colors.grey,
              ),
              onPressed: () async {
                try {
                  final homeService = ref.read(homeServiceProvider);
                  await homeService.toggleStar(item.sequenceId);

                  ref.invalidate(detailDataProvider(widget.title));
                  ref.invalidate(homeDataProvider);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('즐겨찾기 변경에 실패했습니다.')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return '날짜 없음';
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    return '${diff.inDays}일 전';
  }
}
