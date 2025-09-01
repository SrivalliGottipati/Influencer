// package:influencer/data/repositories/video_repository.dart

import '../../config/env.dart';
import '../../core/services/api_client.dart';
import 'package:influencer/data/models/video_models.dart';

abstract class IVideoRepository {
  Future<void> add(VideoLinkRequest request);
  Future<VideoSummary> summary();
}

class VideoRepository implements IVideoRepository {
  VideoRepository(this.client);
  final ApiClient client;

  @override
  Future<void> add(VideoLinkRequest request) async {
    if (Env.useMocks) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      return;
    }
    await client.dio.post(Env.epUploadVideo, data: request.toJson());
  }

  @override
  Future<VideoSummary> summary() async {
    if (Env.useMocks) return VideoSummary.mock();
    final res = await client.dio.get(Env.epDashboard);
    // adapt to your backend response shape; keep null-safety in mind
    return VideoSummary(
      total: res.data['total'] as int,
      views: res.data['views'] as int,
      earnings: (res.data['earnings'] as num).toDouble(),
    );
  }
}
