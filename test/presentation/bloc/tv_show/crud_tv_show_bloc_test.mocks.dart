// Mocks generated by Mockito 5.4.4 from annotations
// in movie_tv_level_maximum/test/presentation/bloc/tv_show/crud_tv_show_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:dartz/dartz.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:movie_tv_level_maximum/common/failure.dart' as _i6;
import 'package:movie_tv_level_maximum/domain/entities/tv_show/tv_show_detail.dart'
    as _i7;
import 'package:movie_tv_level_maximum/domain/repositories/tv_show_repository.dart'
    as _i2;
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_watchlist_tv_show_status.dart'
    as _i9;
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/remove_watchlist_tv_show.dart'
    as _i8;
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/save_watchlist_tv_show.dart'
    as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeTvShowRepository_0 extends _i1.SmartFake
    implements _i2.TvShowRepository {
  _FakeTvShowRepository_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeEither_1<L, R> extends _i1.SmartFake implements _i3.Either<L, R> {
  _FakeEither_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [SaveWatchlistTvShow].
///
/// See the documentation for Mockito's code generation for more information.
class MockSaveWatchlistTvShow extends _i1.Mock
    implements _i4.SaveWatchlistTvShow {
  MockSaveWatchlistTvShow() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.TvShowRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeTvShowRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.TvShowRepository);

  @override
  _i5.Future<_i3.Either<_i6.Failure, String>> execute(
          _i7.TvShowDetail? tvShow) =>
      (super.noSuchMethod(
        Invocation.method(
          #execute,
          [tvShow],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, String>>.value(
            _FakeEither_1<_i6.Failure, String>(
          this,
          Invocation.method(
            #execute,
            [tvShow],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, String>>);
}

/// A class which mocks [RemoveWatchlistTvShow].
///
/// See the documentation for Mockito's code generation for more information.
class MockRemoveWatchlistTvShow extends _i1.Mock
    implements _i8.RemoveWatchlistTvShow {
  MockRemoveWatchlistTvShow() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.TvShowRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeTvShowRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.TvShowRepository);

  @override
  _i5.Future<_i3.Either<_i6.Failure, String>> execute(
          _i7.TvShowDetail? tvShow) =>
      (super.noSuchMethod(
        Invocation.method(
          #execute,
          [tvShow],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, String>>.value(
            _FakeEither_1<_i6.Failure, String>(
          this,
          Invocation.method(
            #execute,
            [tvShow],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, String>>);
}

/// A class which mocks [GetWatchListTvShowStatus].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetWatchListTvShowStatus extends _i1.Mock
    implements _i9.GetWatchListTvShowStatus {
  MockGetWatchListTvShowStatus() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.TvShowRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeTvShowRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.TvShowRepository);

  @override
  _i5.Future<bool> execute(int? id) => (super.noSuchMethod(
        Invocation.method(
          #execute,
          [id],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);
}
