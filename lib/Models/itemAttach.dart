class ItemAttach {
  final String tag;
  String url;
  List<String> title;
  String subTitle;
  String label;
  String type;
  bool bProgress;
  ItemAttach({
    required this.tag,
    this.title = const [],
    this.subTitle = "",
    this.url   = "",
    this.label = "",
    this.type  = "",
    this.bProgress = false
  });
}