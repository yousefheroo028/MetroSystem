class Station {
  final String name;
  final double latitude;
  final double longitude;
  final int lineNumber;
  final int? branch;

  const Station({this.branch, required this.name, required this.lineNumber, required this.latitude, required this.longitude});
}
