import 'package:just_audio/just_audio.dart';

class MusicController {
  // 싱글톤 인스턴스 생성
  static final MusicController _instance = MusicController._internal();

  // factory 생성자로 항상 동일한 인스턴스를 리턴함
  factory MusicController() {
    return _instance;
  }

  // 내부 생성자
  MusicController._internal();

  // AudioPlayer 인스턴스
  final AudioPlayer _audioPlayer = AudioPlayer();

  // 파일 경로로 오디오 재생 함수
  Future<void> playFromFile(String filePath) async {
    await _audioPlayer.setLoopMode(LoopMode.one);
    await _audioPlayer.setUrl(filePath);
    await _audioPlayer.play();
  }

  // 오디오 정지 함수
  Future<void> stop() async {
    await _audioPlayer.stop();
  }
}
