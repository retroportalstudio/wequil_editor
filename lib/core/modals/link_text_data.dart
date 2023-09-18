class LinkTextData {
  final String text,link;

  const LinkTextData({
    required this.text,
    required this.link,
  });



  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinkTextData &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          link == other.link;

  @override
  int get hashCode => text.hashCode ^ link.hashCode;

  LinkTextData copyWith({
    String? text,
    String? link,
  }) {
    return LinkTextData(
      text: text ?? this.text,
      link: link ?? this.link,
    );
  }
}