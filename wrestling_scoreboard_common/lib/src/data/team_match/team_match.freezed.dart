// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_match.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TeamMatch _$TeamMatchFromJson(Map<String, dynamic> json) {
  return _TeamMatch.fromJson(json);
}

/// @nodoc
mixin _$TeamMatch {
  int? get id => throw _privateConstructorUsedError;
  Lineup get home => throw _privateConstructorUsedError;
  Lineup get guest => throw _privateConstructorUsedError;
  League? get league => throw _privateConstructorUsedError;
  Person? get matChairman => throw _privateConstructorUsedError;
  Person? get referee => throw _privateConstructorUsedError;
  Person? get judge => throw _privateConstructorUsedError;
  Person? get timeKeeper => throw _privateConstructorUsedError;
  Person? get transcriptWriter => throw _privateConstructorUsedError;
  String? get no => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  int? get visitorsCount => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TeamMatchCopyWith<TeamMatch> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamMatchCopyWith<$Res> {
  factory $TeamMatchCopyWith(TeamMatch value, $Res Function(TeamMatch) then) = _$TeamMatchCopyWithImpl<$Res, TeamMatch>;
  @useResult
  $Res call(
      {int? id,
      Lineup home,
      Lineup guest,
      League? league,
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
class _$TeamMatchCopyWithImpl<$Res, $Val extends TeamMatch> implements $TeamMatchCopyWith<$Res> {
  _$TeamMatchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? home = null,
    Object? guest = null,
    Object? league = freezed,
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
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      home: null == home
          ? _value.home
          : home // ignore: cast_nullable_to_non_nullable
              as Lineup,
      guest: null == guest
          ? _value.guest
          : guest // ignore: cast_nullable_to_non_nullable
              as Lineup,
      league: freezed == league
          ? _value.league
          : league // ignore: cast_nullable_to_non_nullable
              as League?,
      matChairman: freezed == matChairman
          ? _value.matChairman
          : matChairman // ignore: cast_nullable_to_non_nullable
              as Person?,
      referee: freezed == referee
          ? _value.referee
          : referee // ignore: cast_nullable_to_non_nullable
              as Person?,
      judge: freezed == judge
          ? _value.judge
          : judge // ignore: cast_nullable_to_non_nullable
              as Person?,
      timeKeeper: freezed == timeKeeper
          ? _value.timeKeeper
          : timeKeeper // ignore: cast_nullable_to_non_nullable
              as Person?,
      transcriptWriter: freezed == transcriptWriter
          ? _value.transcriptWriter
          : transcriptWriter // ignore: cast_nullable_to_non_nullable
              as Person?,
      no: freezed == no
          ? _value.no
          : no // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      visitorsCount: freezed == visitorsCount
          ? _value.visitorsCount
          : visitorsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LineupCopyWith<$Res> get home {
    return $LineupCopyWith<$Res>(_value.home, (value) {
      return _then(_value.copyWith(home: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $LineupCopyWith<$Res> get guest {
    return $LineupCopyWith<$Res>(_value.guest, (value) {
      return _then(_value.copyWith(guest: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $LeagueCopyWith<$Res>? get league {
    if (_value.league == null) {
      return null;
    }

    return $LeagueCopyWith<$Res>(_value.league!, (value) {
      return _then(_value.copyWith(league: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PersonCopyWith<$Res>? get matChairman {
    if (_value.matChairman == null) {
      return null;
    }

    return $PersonCopyWith<$Res>(_value.matChairman!, (value) {
      return _then(_value.copyWith(matChairman: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PersonCopyWith<$Res>? get referee {
    if (_value.referee == null) {
      return null;
    }

    return $PersonCopyWith<$Res>(_value.referee!, (value) {
      return _then(_value.copyWith(referee: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PersonCopyWith<$Res>? get judge {
    if (_value.judge == null) {
      return null;
    }

    return $PersonCopyWith<$Res>(_value.judge!, (value) {
      return _then(_value.copyWith(judge: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PersonCopyWith<$Res>? get timeKeeper {
    if (_value.timeKeeper == null) {
      return null;
    }

    return $PersonCopyWith<$Res>(_value.timeKeeper!, (value) {
      return _then(_value.copyWith(timeKeeper: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PersonCopyWith<$Res>? get transcriptWriter {
    if (_value.transcriptWriter == null) {
      return null;
    }

    return $PersonCopyWith<$Res>(_value.transcriptWriter!, (value) {
      return _then(_value.copyWith(transcriptWriter: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TeamMatchImplCopyWith<$Res> implements $TeamMatchCopyWith<$Res> {
  factory _$$TeamMatchImplCopyWith(_$TeamMatchImpl value, $Res Function(_$TeamMatchImpl) then) =
      __$$TeamMatchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      Lineup home,
      Lineup guest,
      League? league,
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
class __$$TeamMatchImplCopyWithImpl<$Res> extends _$TeamMatchCopyWithImpl<$Res, _$TeamMatchImpl>
    implements _$$TeamMatchImplCopyWith<$Res> {
  __$$TeamMatchImplCopyWithImpl(_$TeamMatchImpl _value, $Res Function(_$TeamMatchImpl) _then) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? home = null,
    Object? guest = null,
    Object? league = freezed,
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
    return _then(_$TeamMatchImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      home: null == home
          ? _value.home
          : home // ignore: cast_nullable_to_non_nullable
              as Lineup,
      guest: null == guest
          ? _value.guest
          : guest // ignore: cast_nullable_to_non_nullable
              as Lineup,
      league: freezed == league
          ? _value.league
          : league // ignore: cast_nullable_to_non_nullable
              as League?,
      matChairman: freezed == matChairman
          ? _value.matChairman
          : matChairman // ignore: cast_nullable_to_non_nullable
              as Person?,
      referee: freezed == referee
          ? _value.referee
          : referee // ignore: cast_nullable_to_non_nullable
              as Person?,
      judge: freezed == judge
          ? _value.judge
          : judge // ignore: cast_nullable_to_non_nullable
              as Person?,
      timeKeeper: freezed == timeKeeper
          ? _value.timeKeeper
          : timeKeeper // ignore: cast_nullable_to_non_nullable
              as Person?,
      transcriptWriter: freezed == transcriptWriter
          ? _value.transcriptWriter
          : transcriptWriter // ignore: cast_nullable_to_non_nullable
              as Person?,
      no: freezed == no
          ? _value.no
          : no // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      visitorsCount: freezed == visitorsCount
          ? _value.visitorsCount
          : visitorsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamMatchImpl extends _TeamMatch {
  const _$TeamMatchImpl(
      {this.id,
      required this.home,
      required this.guest,
      this.league,
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

  factory _$TeamMatchImpl.fromJson(Map<String, dynamic> json) => _$$TeamMatchImplFromJson(json);

  @override
  final int? id;
  @override
  final Lineup home;
  @override
  final Lineup guest;
  @override
  final League? league;
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

  @override
  String toString() {
    return 'TeamMatch(id: $id, home: $home, guest: $guest, league: $league, matChairman: $matChairman, referee: $referee, judge: $judge, timeKeeper: $timeKeeper, transcriptWriter: $transcriptWriter, no: $no, location: $location, date: $date, visitorsCount: $visitorsCount, comment: $comment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamMatchImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.home, home) || other.home == home) &&
            (identical(other.guest, guest) || other.guest == guest) &&
            (identical(other.league, league) || other.league == league) &&
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

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, home, guest, league, matChairman, referee, judge, timeKeeper,
      transcriptWriter, no, location, date, visitorsCount, comment);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamMatchImplCopyWith<_$TeamMatchImpl> get copyWith =>
      __$$TeamMatchImplCopyWithImpl<_$TeamMatchImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamMatchImplToJson(
      this,
    );
  }
}

abstract class _TeamMatch extends TeamMatch {
  const factory _TeamMatch(
      {final int? id,
      required final Lineup home,
      required final Lineup guest,
      final League? league,
      final Person? matChairman,
      final Person? referee,
      final Person? judge,
      final Person? timeKeeper,
      final Person? transcriptWriter,
      final String? no,
      final String? location,
      required final DateTime date,
      final int? visitorsCount,
      final String? comment}) = _$TeamMatchImpl;
  const _TeamMatch._() : super._();

  factory _TeamMatch.fromJson(Map<String, dynamic> json) = _$TeamMatchImpl.fromJson;

  @override
  int? get id;
  @override
  Lineup get home;
  @override
  Lineup get guest;
  @override
  League? get league;
  @override
  Person? get matChairman;
  @override
  Person? get referee;
  @override
  Person? get judge;
  @override
  Person? get timeKeeper;
  @override
  Person? get transcriptWriter;
  @override
  String? get no;
  @override
  String? get location;
  @override
  DateTime get date;
  @override
  int? get visitorsCount;
  @override
  String? get comment;
  @override
  @JsonKey(ignore: true)
  _$$TeamMatchImplCopyWith<_$TeamMatchImpl> get copyWith => throw _privateConstructorUsedError;
}
