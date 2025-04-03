import 'dart:io';

import 'package:dio/dio.dart';
import 'package:frontend/core/api/api_client.dart';

class LearningService {
  final ApiClient _apiClient;

  LearningService(this._apiClient);

  //시퀀스 시작 시, userSequence 생성
  Future<int> startYoga(int sequenceId) async {
    final response = await _apiClient.post(
      '/yoga/start',
      body: {'sequenceId': sequenceId},
    );
    return response['userSequenceId'];
  }

  // 시퀀스 중 요가 시작 시, 해당 포인트를 저장
  Future<void> saveYogaPose(int userSequenceId) async {
    await _apiClient.post(
      '/yoga/pose',
      body: {'userSequenceId': userSequenceId},
    );
  }

  // 매 3초마다 피드백을 위한 API
  Future<String> sendLongFeedback({
    required int yogaId,
    required int userSequenceId,
    required File imageFile,
  }) async {
    final response = await _apiClient.postMultipart(
      '/feedback/long',
      fields: {'yogaId': yogaId, 'userSequenceId': userSequenceId},
      files: {'image': imageFile},
    );
    return response['data'];
  }

  // 매 0.5초마다 성공, 실패 여부를 판단하기 위한 API
  Future<String> sendShortFeedback({
    required int yogaId,
    required int userSequenceiD,
    required File imageFile,
  }) async {
    final response = await _apiClient.postMultipart(
      '/feedback/short',
      fields: {'yogaId': yogaId, 'userSequenceId': userSequenceiD},
      files: {'image': imageFile},
    );
    return response['data'];
  }

  // 시퀀스 진행 중, 요가 동작이 끝날때마다 피드백 저장  
  Future<void> saveAccuracyComplete({
    required int userSequenceId,
    required int yogaId,
    required int sequenceId 
  }) async {
    await _apiClient.post('/accuracy/complete', body:{
      'userSequenceId': userSequenceId,
      'yogaId': yogaId,
      'sequenceId': sequenceId
    });
    
  }
}
