import 'package:flutter/material.dart';
import '../models/sequence_report_model.dart';
import '../services/sequence_report_service.dart';
import 'package:frontend/core/api/api_client.dart';

class SequenceReportScreen extends StatelessWidget {
  const SequenceReportScreen({Key? key}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    final reportService = ReportService(ApiClient());

    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<SequenceReportData>(
        future: reportService.fetchReportData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('데이터 없음'));
          }

          final data = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('축하합니다!'),
                const SizedBox(height: 12),
                Text('${data.sequenceName}를 완료하였습니다!'),
              ]
        ),
      );
  })
  );
  }
}