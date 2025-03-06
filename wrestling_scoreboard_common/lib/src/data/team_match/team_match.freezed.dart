// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_match.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeamMatch {
  int? get id;
  String? get orgSyncId;
  Organization? get organization;
  Lineup get home;
  Lineup get guest;
  League? get league;
  int? get seasonPartition;
  Person? get matChairman;
  Person? get referee;
  Person? get judge;
  Person? get timeKeeper;
  Person? get transcriptWriter;
  String? get no;
  String? get location;
  DateTime get date;
  int? get visitorsCount;
  String? get comment;

  /// Create a copy of TeamMatch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TeamMatchCopyWith<TeamMatch> get copyWith => _$TeamMatchCopyWithImpl<TeamMatch>(this as TeamMatch, _$identity);

  /// Serializes this TeamMatch to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TeamMatch &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgSyncId, orgSyncId) || other.orgSyncId == orgSyncId) &&
            (identical(other.organization, organization) || other.organization == organization) &&
            (identical(other.home, home) || other.home == home) &&
            (identical(other.guest, guest) || other.guest == guest) &&
            (identical(other.league, league) || other.league == league) &&
            (identical(other.seasonPartition, seasonPartition) || other.seasonPartition == seasonPartition) &&
            (identical(other.matChairman, matChairman) || other.matChairman == matChairman) &&
            (identical(other.referee, referee) || other.referee == referee) &&
            (identical(other.judge, judge) || other.judge == judge) &&
            (identical(other.timeKeeper, timeKeeper) || other.timeKeeper == timeKeeper) &&
            (identical(other.transcriptWriter, transcriptWriter) || other.transcriptWriter == transcriptWriter) &&
            (identical(other.no, no) || other.no == no) &&
            (identical(other.location, location) || other.location == location) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.visitorsCount, visitorsCount) || other.visitorsCount == visitorsCount) &&
            (identical(other.comment, comment) || other.comment == comment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, orgSyncId, organization, home, guest, league, seasonPartition,
      matChairman, referee, judge, timeKeeper, transcriptWriter, no, location, date, visitorsCount, comment);

  @override
  String toString() {
    return 'TeamMatch(id: $id, orgSyncId: $orgSyncId, organization: $organization, home: $home, guest: $guest, league: $league, seasonPartition: $seasonPartition, matChairman: $matChairman, referee: $referee, judge: $judge, timeKeeper: $timeKeeper, transcriptWriter: $transcriptWriter, no: $no, location: $location, date: $date, visitorsCount: $visitorsCount, comment: $comment)';
  }
}

/// @nodoc
abstract mixin class $TeamMatchCopyWith<$Res> {
  factory $TeamMatchCopyWith(TeamMatch value, $Res Function(TeamMatch) _then) = _$TeamMatchCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      String? orgSyncId,
      Organization? organization,
      Lineup home,
      Lineup guest,
      League? league,
      int? seasonPartition,
      Person? matChairman,
      Person? referee,
      Person? judge,
      Person? timeKeeper,
      Person? transcriptWriter,
      String? no,
      String? location,
      DateTime date,
      int? visitorsCount,
      String? comment});

  $OrganizationCopyWith<$Res>? get organization;
  $LineupCopyWith<$Res> get home;
  $LineupCopyWith<$Res> get guest;
  $LeagueCopyWith<$Res>? get league;
  $PersonCopyWith<$Res>? get matChairman;
  $PersonCopyWith<$Res>? get referee;
  $PersonCopyWith<$Res>? get judge;
  $PersonCopyWith<$Res>? get timeKeeper;
  $PersonCopyWith<$Res>? get transcriptWriter;
}

/// @nodoc
class _$TeamMatchCopyWithImpl<$Res> implements $TeamMatchCopyWith<$Res> {
  _$TeamMatchCopyWithImpl(this._self, this._then);

  final TeamMatch _self;
  final $Res Function(TeamMatch) _then;

  /// Create a copy of TeamMatch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orgSyncId = freezed,
    Object? organization = freezed,
    Object? home = null,
    Object? guest = null,
    Object? league = freezed,
    Object? seasonPartition = freezed,
    Object? matChairman = freezed,
    Object? referee = freezed,
    Object? judge = freezed,
    Object? timeKeeper = freezed,
    Object? transcriptWriter = freezed,
    Object? no = freezed,
    Object? location = freezed,
    Object? date = null,
    Object? visitorsCount = freezed,
    Object? comment = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      orgSyncId: freezed == orgSyncId
          ? _self.orgSyncId
          : orgSyncId // ignore: cast_nullable_to_non_nullable
              as String?,
      organization: freezed == organization
          ? _self.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as Organization?,
      home: null == home
          ? _self.home
          : home // ignore: cast_nullable_to_non_nullable
              as Lineup,
      guest: null == guest
          ? _self.guest
          : guest // ignore: cast_nullable_to_non_nullable
              as Lineup,
      league: freezed == league
          ? _self.league
          : league // ignore: cast_nullable_to_non_nullable
              as League?,
      seasonPartition: freezed == seasonPartition
          ? _self.seasonPartition
          : seasonPartition // ignore: cast_nullable_to_non_nullable
              as int?,
      matChairman: freezed == matChairman
          ? _self.matChairman
          : matChairman // ignore: cast_nullable_to_non_nullable
              as Person?,
      referee: freezed == referee
          ? _self.referee
          : referee // ignore: cast_nullable_to_non_nullable
              as Person?,
      judge: freezed == judge
          ? _self.judge
          : judge // ignore: cast_nullable_to_non_nullable
              as Person?,
      timeKeeper: freezed == timeKeeper
          ? _self.timeKeeper
          : timeKeeper // ignore: cast_nullable_to_non_nullable
              as Person?,
      transcriptWriter: freezed == transcriptWriter
          ? _self.transcriptWriter
          : transcriptWriter // ignore: cast_nullable_to_non_nullable
              as Person?,
      no: freezed == no
          ? _self.no
          : no // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      visitorsCount: freezed == visitorsCount
          ? _self.visitorsCount
          : visitorsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      comment: freezed == comment
          ? _self.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of TeamMatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrganizationCopyWith<$Res>? get organization {
    if (_self.organization == null) {
      return null;
    }

    return $OrganizationCopyWith<$Res>(_self.organization!, (value) {
      return _then(_self.copyWith(organization: value));
    });
  }

  /// Create a copy of TeamMatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LineupCopyWith<$Res> get home {
    return $LineupCopyWith<$Res>(_self.home, (value) {
      return _then(_self.copyWith(home: value));
    });
  }

  /// Create a copy of TeamMatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LineupCopyWith<$Res> get guest {
    return $LineupCopyWith<$Res>(_self.guest, (value) {
      return _then(_self.copyWith(guest: value));
    });
  }

  /// Create a copy of TeamMatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LeagueCopyWith<$Res>? get league {
    if (_self.league == null) {
      return null;
    }

    return $LeagueCopyWith<$Res>(_self.league!, (value) {
      return _then(_self.copyWith(league: value));
    });
  }

  /// Create a copy of TeamMatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PersonCopyWith<$Res>? get matChairman {
    if (_self.matChairman == null) {
      return null;
    }

    return $PersonCopyWith<$Res>(_self.matChairman!, (value) {
      return _then(_self.copyWith(matChairman: value));
    });
  }

  /// Create a copy of TeamMatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PersonCopyWith<$Res>? get referee {
    if (_self.referee == null) {
      return null;
    }

    return $PersonCopyWith<$Res>(_self.referee!, (value) {
      return _then(_self.copyWith(referee: value));
    });
  }

  /// Create a copy of TeamMatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PersonCopyWith<$Res>? get judge {
    if (_self.judge == null) {
      return null;
    }

    return $PersonCopyWith<$Res>(_self.judge!, (value) {
      return _then(_self.copyWith(judge: value));
    });
  }

  /// Create a copy of TeamMatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PersonCopyWith<$Res>? get timeKeeper {
    if (_self.timeKeeper == null) {
      return null;
    }

    return $PersonCopyWith<$Res>(_self.timeKeeper!, (value) {
      return _then(_self.copyWith(timeKeeper: value));
    });
  }

  /// Create a copy of TeamMatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PersonCopyWith<$Res>? get transcriptWriter {
    if (_self.transcriptWriter == null) {
      return null;
    }

    return $PersonCopyWith<$Res>(_self.transcriptWriter!, (value) {
      return _then(_self.copyWith(transcriptWriter: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _TeamMatch extends TeamMatch {
  const _TeamMatch(
      {this.id,
      this.orgSyncId,
      this.organization,
      required this.home,
      required this.guest,
      this.league,
      this.seasonPartition,
      this.matChairman,
      this.referee,
      this.judge,
      this.timeKeeper,
      this.transcriptWriter,
      this.no,
      this.location,
      required this.date,
      this.visitorsCount,
      this.comment})
      : super._();
  factory _TeamMatch.fromJson(Map<String, dynamic> json) => _$TeamMatchFromJson(json);

  @override
  final int? id;
  @override
  final String? orgSyncId;
  @override
  final Organization? organization;
  @override
  final Lineup home;
  @override
  final Lineup guest;
  @override
  final League? league;
  @override
  final int? seasonPartition;
  @override
  final Person? matChairman;
  @override
  final Person? referee;
  @override
  final Person? judge;
  @override
  final Person? timeKeeper;
  @override
  final Person? transcriptWriter;
  @override
  final String? no;
  @override
  final String? location;
  @override
  final DateTime date;
  @override
  final int? visitorsCount;
  @override
  final String? comment;

  /// Create a copy of TeamMatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TeamMatchCopyWith<_TeamMatch> get copyWith => __$TeamMatchCopyWithImpl<_TeamMatch>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TeamMatchToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TeamMatch &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgSyncId, orgSyncId) || other.orgSyncId == orgSyncId) &&
            (identical(other.organization, organization) || other.organization == organization) &&
            (identical(other.home, home) || other.home == home) &&
            (identical(other.guest, guest) || other.guest == guest) &&
            (identical(other.league, league) || other.league == league) &&
            (identical(other.seasonPartition, seasonPartition) || other.seasonPartition == seasonPartition) &&
            (identical(other.matChairman, matChairman) || other.matChairman == matChairman) &&
            (identical(other.referee, referee) || other.referee == referee) &&
            (identical(other.judge, judge) || other.judge == judge) &&
            (identical(other.timeKeeper, timeKeeper) || other.timeKeeper == timeKeeper) &&
            (identical(other.transcriptWriter, transcriptWriter) || other.transcriptWriter == transcriptWriter) &&
            (identical(other.no, no) || other.no == no) &&
            (identical(other.location, location) || other.location == location) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.visitorsCount, visitorsCount) || other.visitorsCount == visitorsCount) &&
            (identical(other.comment, comment) || other.comment == comment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, orgSyncId, organization, home, guest, league, seasonPartition,
      matChairman, referee, judge, timeKeeper, transcriptWriter, no, location, date, visitorsCount, comment);

  @override
  String toString() {
    return 'TeamMatch(id: $id, orgSyncId: $orgSyncId, organization: $organization, home: $home, guest: $guest, league: $league, seasonPartition: $seasonPartition, matChairman: $matChairman, referee: $referee, judge: $judge, timeKeeper: $timeKeeper, transcriptWriter: $transcriptWriter, no: $no, location: $location, date: $date, visitorsCount: $visitorsCount, comment: $comment)';
  }
}

/// @nodoc
abstract mixin class _$TeamMatchCopyWith<$Res> implements $TeamMatchCopyWith<$Res> {
  factory _$TeamMatchCopyWith(_TeamMatch value, $Res Function(_TeamMatch) _then) = __$TeamMatchCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      String? orgSyncId,
      Organization? organization,
      Lineup home,
      Lineup guest,
      League? league,
      int? seasonPartition,
      Person? matChairman,
      Person? referee,
      Person? judge,
      Person? timeKeeper,
      Person? transcriptWriter,
      String? no,
      String? location,
      DateTime date,
      int? visitorsCount,
      String? comment});

  @override
  $OrganizationCopyWith<$Res>? get organization;
  @override
  $LineupCopyWith<$Res> get home;
  @override
  $LineupCopyWith<$Res> get guest;
  @override
  $LeagueCopyWith<$Res>? get league;
  @override
  $PersonCopyWith<$Res>? get matChairman;
  @override
  $PersonCopyWith<$Res>? get referee;
  @override
  $PersonCopyWith<$Res>? get judge;
  @override
  $PersonCopyWith<$Res>? get timeKeeper;
  @override
  $PersonCopyWith<$Res>? get transcriptWriter;
}

/// @nodoc
class __$TeamMatchCopyWithImpl<$Res> implements _$TeamMatchCopyWith<$Res> {
  __$TeamMatchCopyWithImpl(this._self, this._then);

  final _TeamMatch _self;
  final $Res Function(_TeamMatch) _then;

  /// Create a copy of TeamMatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? orgSyncId = freezed,
    Object? organization = freezed,
    Object? home = null,
    Object? guest = null,
    Object? league = freezed,
    Object? seasonPartition = freezed,
    Object? matChairman = freezed,
    Object? referee = freezed,
    Object? judge = freezed,
    Object? timeKeeper = freezed,
    Object? transcriptWriter = freezed,
    Object? no = freezed,
    Object? location = freezed,
    Object? date = null,
    Object? visitorsCount = freezed,
    Object? comment = freezed,
  }) {
    return _then(_TeamMatch(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      orgSyncId: freezed == orgSyncId
          ? _self.orgSyncId
          : orgSyncId // ignore: cast_nullable_to_non_nullable
              as String?,
      organization: freezed == organization
          ? _self.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as Organization?,
      home: null == home
          ? _self.home
          : home // ignore: cast_nullable_to_non_nullable
              as Lineup,
      guest: null == guest
          ? _self.guest
          : guest // ignore: cast_nullable_to_non_nullable
              as Lineup,
      league: freezed == league
          ? _self.league
          : league // ignore: cast_nullable_to_non_nullable
              as League?,
      seasonPartition: freezed == seasonPartition
          ? _self.seasonPartition
          : seasonPartition // ignore: cast_nullable_to_non_nullable
              as int?,
      matChairman: freezed == matChairman
          ? _self.matChairman
          : matChairman // ignore: cast_nullable_to_non_nullable
              as Person?,
      referee: freezed == referee
          ? _self.referee
          : referee // ignore: cast_nullable_to_non_nullable
              as Person?,
      judge: freezed == judge
          ? _self.judge
          : judge // ignore: cast_nullable_to_non_nullable
              as Person?,
      timeKeeper: freezed == timeKeeper
          ? _self.timeKeeper
          : timeKeeper // ignore: cast_nullable_to_non_nullable
              as Person?,
      transcriptWriter: freezed == transcriptWriter
          ? _self.transcriptWriter
          : transcriptWriter // ignore: cast_nullable_to_non_nullable
              as Person?,
      no: freezed == no
          ? _self.no
          : no // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      visitorsCount: freezed == visitorsCount
          ? _self.visitorsCount
          : visitorsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      comment: freezed == comment
          ? _self.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of TeamMatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrganizationCopyWith<$Res>? get organization {
    if (_self.organization == null) {
      return null;
    }

    return $OrganizationCopyWith<$Res>(_self.organization!, (value) {
      return _then(_self.copyWith(organization: value));
    });
  }

  /// Create a copy of TeamMatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LineupCopyWith<$Res> get home {
    return $LineupCopyWith<$Res>(_self.home, (value) {
      return _then(_self.copyWith(home: value));
    });
  }

  /// Create a copy of TeamMatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LineupCopyWith<$Res> get guest {
    return $LineupCopyWith<$Res>(_self.guest, (value) {
      return _then(_self.copyWith(guest: value));
    });
  }

  /// Create a copy of TeamMatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LeagueCopyWith<$Res>? get league {
    if (_self.league == null) {
      return null;
    }

    return $LeagueCopyWith<$Res>(_self.league!, (value) {
      return _then(_self.copyWith(league: value));
    });
  }

  /// Create a copy of TeamMatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PersonCopyWith<$Res>? get matChairman {
    if (_self.matChairman == null) {
      return null;
    }

    return $PersonCopyWith<$Res>(_self.matChairman!, (value) {
      return _then(_self.copyWith(matChairman: value));
    });
  }

  /// Create a copy of TeamMatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PersonCopyWith<$Res>? get referee {
    if (_self.referee == null) {
      return null;
    }

    return $PersonCopyWith<$Res>(_self.referee!, (value) {
      return _then(_self.copyWith(referee: value));
    });
  }

  /// Create a copy of TeamMatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PersonCopyWith<$Res>? get judge {
    if (_self.judge == null) {
      return null;
    }

    return $PersonCopyWith<$Res>(_self.judge!, (value) {
      return _then(_self.copyWith(judge: value));
    });
  }

  /// Create a copy of TeamMatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PersonCopyWith<$Res>? get timeKeeper {
    if (_self.timeKeeper == null) {
      return null;
    }

    return $PersonCopyWith<$Res>(_self.timeKeeper!, (value) {
      return _then(_self.copyWith(timeKeeper: value));
    });
  }

  /// Create a copy of TeamMatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PersonCopyWith<$Res>? get transcriptWriter {
    if (_self.transcriptWriter == null) {
      return null;
    }

    return $PersonCopyWith<$Res>(_self.transcriptWriter!, (value) {
      return _then(_self.copyWith(transcriptWriter: value));
    });
  }
}

// dart format on
