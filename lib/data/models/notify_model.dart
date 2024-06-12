class NotifyModel {
  final String key;
  final String value;

  NotifyModel({required this.key, required this.value});

  factory NotifyModel.mapToNotifyModel(Map<String, String> map) {
    return NotifyModel(
      key: map.entries.first.key,
      value: map.entries.first.value,
    );
  }
}
