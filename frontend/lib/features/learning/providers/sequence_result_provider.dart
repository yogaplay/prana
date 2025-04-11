import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/providers.dart';
import 'package:frontend/features/learning/models/sequence_result_response.dart';
import 'package:frontend/features/learning/services/sequence_result_service.dart';

final sequenceResultServiceProvider = Provider<SequenceResultService>(
  (ref) => SequenceResultService(ref.read(apiClientProvider)),
);

final sequenceResultProvider = FutureProvider.family<
  SequenceResultResponse,
  (int userSequenceId, int sequenceId)
>((ref, args) async {
  final service = ref.watch(sequenceResultServiceProvider);
  return service.fetchSequenceResult(
    userSequenceId: args.$1,
    sequenceId: args.$2,
  );
});
