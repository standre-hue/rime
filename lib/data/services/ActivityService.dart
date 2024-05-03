import 'package:rime/data/repositories/ActivityRepository.dart';

class ActivityService {
  ActivityRepository activityRepository = ActivityRepository();
  ActivityService() {}
  Future<bool?> createActivity(
      {int? supplyId, int? transactionId, int? userId, required String description}) async {
    try {
      final sucess = await activityRepository.createActivity(
          description: description,
          userId: userId,
          supplyId:supplyId,
          transactionId: transactionId);
      return sucess;
    } catch (e) {
      print(e);
    }
  }
}
