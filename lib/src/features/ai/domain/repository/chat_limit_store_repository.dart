abstract class ChatLimitStoreRepository {
  Future<int> getCount();

  Future<void> increase(String today);
}
