String userEmail = '';
String userName = '';

class Contest {
  final int id;
  final String title;
  final String description;
  final String winner;
  final String prizeMoney;
  final String coverImage;
  final String startDate;
  final String endDate;
  final int status;
  final String createdAt;

  Contest({
    required this.id,
    required this.title,
    required this.description,
    required this.winner,
    required this.prizeMoney,
    required this.coverImage,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.createdAt,
  });

  factory Contest.fromJson(Map<String, dynamic> json) {
    return Contest(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? "",
      winner: json['winner'] ?? "",
      prizeMoney: json['prize_money'],
      coverImage: json['cover_image'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      status: json['status'],
      createdAt: json['created_at'],
    );
  }
}
