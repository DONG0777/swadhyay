import '../models/community_place.dart';

class MyCommunityPlace {
  final CommunityPlace place;
  final DateTime joinedAt;

  const MyCommunityPlace({
    required this.place,
    required this.joinedAt,
  });

  factory MyCommunityPlace.fromMap(
    Map<String, dynamic> map,
  ) {
    return MyCommunityPlace(
      place: CommunityPlace.fromMap(
        Map<String, dynamic>.from(
          map['place'] as Map,
        ),
      ),
      joinedAt: DateTime.parse(
        map['joined_at'] as String,
      ),
    );
  }
}
