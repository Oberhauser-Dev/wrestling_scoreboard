# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

## 2024-11-09

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`wrestling_scoreboard_client` - `v0.1.2`](#wrestling_scoreboard_client---v012)
 - [`wrestling_scoreboard_common` - `v0.1.2`](#wrestling_scoreboard_common---v012)
 - [`wrestling_scoreboard_server` - `v0.1.2`](#wrestling_scoreboard_server---v012)

---

#### `wrestling_scoreboard_client` - `v0.1.2`

 - **FIX**: Allow subclasses in home. ([e8ef7506](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/e8ef7506cbcef4e0ba28e891c1bdc11739899f7a))
 - **FIX**: Allow adjacent import only for admins. ([dbab8896](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/dbab889601f01649780505bbe558cbb6e350356f))
 - **FIX**: PersonEdit showing in edit mode. ([7a15086a](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/7a15086ac2c8ca982aa8ab7134d3882d01700509))
 - **FIX**: Ability to edit the injury timers after they ended. ([c8e7c543](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/c8e7c543359fdacfbc3980095eed6d9280c4c184))
 - **FIX**: Generate bouts ([#74](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/74)). ([ae10e354](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/ae10e354bba81a4b54fce7083514dd6dc96ee30c))
 - **FIX**: Calculation of persons age. ([9b4e59cb](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/9b4e59cb0e8a4ce9c5803a874561ac8a23306685))
 - **FIX**: Use common searchable data types. ([896e3bee](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/896e3bee9f1a4e3367392a331908c767eb99328e))
 - **FEAT**: Add verbal warning to bout display. ([122b3cca](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/122b3ccab6c0e9c3172354677c0f9b8dd1b18509))
 - **FEAT**: Hide filter options. ([707b93f7](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/707b93f74260cff198a0136c17db28f9cd70c891))
 - **FEAT**: Import subjacent data (closes [#96](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/96)). ([b109f8d0](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/b109f8d0766650825473ea845b6353e343ba755c))
 - **FEAT**: Warning for overriding database. ([ee4cbacc](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/ee4cbacc9ece615262a14425c97020c162115df3))
 - **FEAT**: Tooltips for keyboard shortcuts (closes [#21](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/21)). ([3a9db165](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/3a9db1651683502a030ef0fdba60f33544f9fe27))
 - **FEAT**: User administration. ([9ef4776c](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/9ef4776c5ea8ab2d56f6924f240170b405ddceb4))
 - **FEAT**: Material duration picker (closes [#86](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/86)). ([7c1cd5f6](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/7c1cd5f689c23fe31a02912f3cb34bbea30b9887))
 - **FEAT**: Support count down (international) time (closes [#48](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/48)). ([f0c7b967](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/f0c7b96753e3aa4b6a4d38ed74840c2b18419883))
 - **FEAT**: Propose import on Lineup edit. ([4e10a6d8](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/4e10a6d89b3b1d28d9d253146fa0b240c6eb869d))
 - **FEAT**: Disable team import until ready. ([ddaa3e01](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/ddaa3e016c6a42484c957be1259a27775ed46507))
 - **FEAT**: Bleeding Injury Duration (closes [#58](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/58)). ([34a462dd](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/34a462dd1a48f7b82915fce3e272ea10dbade343))
 - **FEAT**: Edit & Save BoutResultRule. ([6abdbdb1](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/6abdbdb1c0f76dde56c566430f2fcc12aca8ab52))
 - **FEAT**: TeamClubAffiliation (closes [#59](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/59)). ([d88bf4ce](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/d88bf4ceaf9f6c36c1ea899904edb374d94fc3bc))
 - **FEAT**: Suggest to import from API ([#74](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/74)). ([689923a1](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/689923a16f79a8bc7d21aab8c0844e5fdf135230))
 - **FEAT**: TeamMatchBouts of membership. ([34228e5f](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/34228e5f5bba04b0f30a06b9f7f3e41b1dc315d3))
 - **FEAT**(client): Sort lists, display year for league & division. ([7c53d376](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/7c53d376935708f85d16386f46a33ee57931f859))
 - **FEAT**(client): Fill lineup with previous match lineup. ([495583d3](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/495583d30468915e128851c19b88589f17e3d07b))
 - **FEAT**(client): Umbrella organization of organization. ([c9be1366](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/c9be1366aa1f774c8a9001768dde917aa641ee5c))
 - **FEAT**: Adapt bout display layout. ([3f4b5bf6](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/3f4b5bf6909f794aec732d28974b8659ff6ae43d))
 - **FEAT**: Replace vsu1 and vpo1 in database, dynamic bout result calculation, update single bout pdf ([#76](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/76)). ([06bfb4d7](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/06bfb4d7f14ecbdf03516b2f863ac72173a419fd))
 - **DOCS**: Link to the olympic wrestling rules. ([e0c1e319](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/e0c1e319305c9f1cc9a6e86d124e9bb5ab09332a))

#### `wrestling_scoreboard_common` - `v0.1.2`

 - **FIX**: By API import fixes. ([52da79fe](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/52da79fe4470fca5e14e8c89f7dda68245d51f77))
 - **FIX**: RDB Report. ([9af9f2c4](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/9af9f2c4abd86ad549e3d69c50721046a56665a2))
 - **FIX**: Ability to edit the injury timers after they ended. ([c8e7c543](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/c8e7c543359fdacfbc3980095eed6d9280c4c184))
 - **FIX**: Import dates as Utc. ([d619fd00](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/d619fd00773232370bbffb4004d54f522c104e21))
 - **FIX**: Calculation of persons age. ([9b4e59cb](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/9b4e59cb0e8a4ce9c5803a874561ac8a23306685))
 - **FIX**: Import of Bayern region in ByGermanyWrestlingApi. ([bca31173](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/bca31173fea1f829aa0ec453fab24d3d70e965db))
 - **FIX**: Use common searchable data types. ([896e3bee](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/896e3bee9f1a4e3367392a331908c767eb99328e))
 - **FEAT**: Import subjacent data (closes [#96](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/96)). ([b109f8d0](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/b109f8d0766650825473ea845b6353e343ba755c))
 - **FEAT**: User administration. ([9ef4776c](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/9ef4776c5ea8ab2d56f6924f240170b405ddceb4))
 - **FEAT**: Support count down (international) time (closes [#48](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/48)). ([f0c7b967](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/f0c7b96753e3aa4b6a4d38ed74840c2b18419883))
 - **FEAT**: Bleeding Injury Duration (closes [#58](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/58)). ([34a462dd](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/34a462dd1a48f7b82915fce3e272ea10dbade343))
 - **FEAT**: Edit & Save BoutResultRule. ([6abdbdb1](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/6abdbdb1c0f76dde56c566430f2fcc12aca8ab52))
 - **FEAT**: TeamClubAffiliation (closes [#59](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/59)). ([d88bf4ce](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/d88bf4ceaf9f6c36c1ea899904edb374d94fc3bc))
 - **FEAT**: Propagate errors on import failure. ([9d073f4b](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/9d073f4bdbcc4c901baf45c33ea33aa797bd61e7))
 - **FEAT**: Replace vsu1 and vpo1 in database, dynamic bout result calculation, update single bout pdf ([#76](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/76)). ([06bfb4d7](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/06bfb4d7f14ecbdf03516b2f863ac72173a419fd))

#### `wrestling_scoreboard_server` - `v0.1.2`

 - **FIX**: Allow adjacent import only for admins. ([dbab8896](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/dbab889601f01649780505bbe558cbb6e350356f))
 - **FIX**: Add new bout result rules in migration. ([73602c94](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/73602c94a1c39b07333ba3c707f3f3ad90410525))
 - **FIX**: Import dates as Utc. ([d619fd00](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/d619fd00773232370bbffb4004d54f522c104e21))
 - **FIX**: UTF8 export on Windows. ([50ccdcd2](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/50ccdcd29b872f1210c6e25eb819cf703cad3355))
 - **FIX**: Generate bouts ([#74](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/74)). ([ae10e354](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/ae10e354bba81a4b54fce7083514dd6dc96ee30c))
 - **FIX**(server): Drop club no index. ([7dd173f8](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/7dd173f8a1cbbe416e7e5c1097080b2c67cf7557))
 - **FIX**: Use common searchable data types. ([896e3bee](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/896e3bee9f1a4e3367392a331908c767eb99328e))
 - **FEAT**: Cache subjacent import data. ([339de0a2](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/339de0a26415669d5f22669c30440a245b03fe7d))
 - **FEAT**: Import subjacent data (closes [#96](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/96)). ([b109f8d0](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/b109f8d0766650825473ea845b6353e343ba755c))
 - **FEAT**: User administration. ([9ef4776c](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/9ef4776c5ea8ab2d56f6924f240170b405ddceb4))
 - **FEAT**: updateOrCreate on API import ([#71](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/71)). ([f194dd7e](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/f194dd7e95fdf4da80296946031089de844f2465))
 - **FEAT**: Bleeding Injury Duration (closes [#58](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/58)). ([34a462dd](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/34a462dd1a48f7b82915fce3e272ea10dbade343))
 - **FEAT**: Edit & Save BoutResultRule. ([6abdbdb1](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/6abdbdb1c0f76dde56c566430f2fcc12aca8ab52))
 - **FEAT**: TeamClubAffiliation (closes [#59](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/59)). ([d88bf4ce](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/d88bf4ceaf9f6c36c1ea899904edb374d94fc3bc))
 - **FEAT**: Propagate errors on import failure. ([9d073f4b](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/9d073f4bdbcc4c901baf45c33ea33aa797bd61e7))
 - **FEAT**: Suggest to import from API ([#74](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/74)). ([689923a1](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/689923a16f79a8bc7d21aab8c0844e5fdf135230))
 - **FEAT**: TeamMatchBouts of membership. ([34228e5f](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/34228e5f5bba04b0f30a06b9f7f3e41b1dc315d3))
 - **FEAT**: Replace vsu1 and vpo1 in database, dynamic bout result calculation, update single bout pdf ([#76](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/76)). ([06bfb4d7](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/06bfb4d7f14ecbdf03516b2f863ac72173a419fd))
 - **FEAT**: Database migration improvements and tests ([#71](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/71)). ([9e8b58be](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/9e8b58bed5586edd7a3038041bb2b52fb6f9685c))


## 2024-11-09

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`wrestling_scoreboard_client` - `v0.1.1`](#wrestling_scoreboard_client---v011)
 - [`wrestling_scoreboard_common` - `v0.1.1`](#wrestling_scoreboard_common---v011)
 - [`wrestling_scoreboard_server` - `v0.1.1`](#wrestling_scoreboard_server---v011)

---

#### `wrestling_scoreboard_client` - `v0.1.1`

 - **FIX**: Allow subclasses in home. ([e8ef7506](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/e8ef7506cbcef4e0ba28e891c1bdc11739899f7a))
 - **FIX**: Allow adjacent import only for admins. ([dbab8896](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/dbab889601f01649780505bbe558cbb6e350356f))
 - **FIX**: PersonEdit showing in edit mode. ([7a15086a](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/7a15086ac2c8ca982aa8ab7134d3882d01700509))
 - **FIX**: Ability to edit the injury timers after they ended. ([c8e7c543](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/c8e7c543359fdacfbc3980095eed6d9280c4c184))
 - **FIX**: Generate bouts ([#74](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/74)). ([ae10e354](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/ae10e354bba81a4b54fce7083514dd6dc96ee30c))
 - **FIX**: Calculation of persons age. ([9b4e59cb](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/9b4e59cb0e8a4ce9c5803a874561ac8a23306685))
 - **FIX**: Use common searchable data types. ([896e3bee](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/896e3bee9f1a4e3367392a331908c767eb99328e))
 - **FEAT**: Hide filter options. ([707b93f7](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/707b93f74260cff198a0136c17db28f9cd70c891))
 - **FEAT**: Import subjacent data (closes [#96](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/96)). ([b109f8d0](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/b109f8d0766650825473ea845b6353e343ba755c))
 - **FEAT**: Warning for overriding database. ([ee4cbacc](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/ee4cbacc9ece615262a14425c97020c162115df3))
 - **FEAT**: Tooltips for keyboard shortcuts (closes [#21](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/21)). ([3a9db165](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/3a9db1651683502a030ef0fdba60f33544f9fe27))
 - **FEAT**: User administration. ([9ef4776c](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/9ef4776c5ea8ab2d56f6924f240170b405ddceb4))
 - **FEAT**: Material duration picker (closes [#86](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/86)). ([7c1cd5f6](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/7c1cd5f689c23fe31a02912f3cb34bbea30b9887))
 - **FEAT**: Support count down (international) time (closes [#48](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/48)). ([f0c7b967](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/f0c7b96753e3aa4b6a4d38ed74840c2b18419883))
 - **FEAT**: Propose import on Lineup edit. ([4e10a6d8](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/4e10a6d89b3b1d28d9d253146fa0b240c6eb869d))
 - **FEAT**: Disable team import until ready. ([ddaa3e01](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/ddaa3e016c6a42484c957be1259a27775ed46507))
 - **FEAT**: Bleeding Injury Duration (closes [#58](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/58)). ([34a462dd](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/34a462dd1a48f7b82915fce3e272ea10dbade343))
 - **FEAT**: Edit & Save BoutResultRule. ([6abdbdb1](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/6abdbdb1c0f76dde56c566430f2fcc12aca8ab52))
 - **FEAT**: TeamClubAffiliation (closes [#59](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/59)). ([d88bf4ce](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/d88bf4ceaf9f6c36c1ea899904edb374d94fc3bc))
 - **FEAT**: Suggest to import from API ([#74](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/74)). ([689923a1](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/689923a16f79a8bc7d21aab8c0844e5fdf135230))
 - **FEAT**: TeamMatchBouts of membership. ([34228e5f](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/34228e5f5bba04b0f30a06b9f7f3e41b1dc315d3))
 - **FEAT**(client): Sort lists, display year for league & division. ([7c53d376](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/7c53d376935708f85d16386f46a33ee57931f859))
 - **FEAT**(client): Fill lineup with previous match lineup. ([495583d3](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/495583d30468915e128851c19b88589f17e3d07b))
 - **FEAT**(client): Umbrella organization of organization. ([c9be1366](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/c9be1366aa1f774c8a9001768dde917aa641ee5c))
 - **FEAT**: Adapt bout display layout. ([3f4b5bf6](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/3f4b5bf6909f794aec732d28974b8659ff6ae43d))
 - **FEAT**: Replace vsu1 and vpo1 in database, dynamic bout result calculation, update single bout pdf ([#76](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/76)). ([06bfb4d7](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/06bfb4d7f14ecbdf03516b2f863ac72173a419fd))
 - **DOCS**: Link to the olympic wrestling rules. ([e0c1e319](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/e0c1e319305c9f1cc9a6e86d124e9bb5ab09332a))

#### `wrestling_scoreboard_common` - `v0.1.1`

 - **FIX**: By API import fixes. ([52da79fe](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/52da79fe4470fca5e14e8c89f7dda68245d51f77))
 - **FIX**: RDB Report. ([9af9f2c4](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/9af9f2c4abd86ad549e3d69c50721046a56665a2))
 - **FIX**: Ability to edit the injury timers after they ended. ([c8e7c543](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/c8e7c543359fdacfbc3980095eed6d9280c4c184))
 - **FIX**: Import dates as Utc. ([d619fd00](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/d619fd00773232370bbffb4004d54f522c104e21))
 - **FIX**: Calculation of persons age. ([9b4e59cb](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/9b4e59cb0e8a4ce9c5803a874561ac8a23306685))
 - **FIX**: Import of Bayern region in ByGermanyWrestlingApi. ([bca31173](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/bca31173fea1f829aa0ec453fab24d3d70e965db))
 - **FIX**: Use common searchable data types. ([896e3bee](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/896e3bee9f1a4e3367392a331908c767eb99328e))
 - **FEAT**: Import subjacent data (closes [#96](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/96)). ([b109f8d0](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/b109f8d0766650825473ea845b6353e343ba755c))
 - **FEAT**: User administration. ([9ef4776c](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/9ef4776c5ea8ab2d56f6924f240170b405ddceb4))
 - **FEAT**: Support count down (international) time (closes [#48](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/48)). ([f0c7b967](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/f0c7b96753e3aa4b6a4d38ed74840c2b18419883))
 - **FEAT**: Bleeding Injury Duration (closes [#58](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/58)). ([34a462dd](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/34a462dd1a48f7b82915fce3e272ea10dbade343))
 - **FEAT**: Edit & Save BoutResultRule. ([6abdbdb1](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/6abdbdb1c0f76dde56c566430f2fcc12aca8ab52))
 - **FEAT**: TeamClubAffiliation (closes [#59](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/59)). ([d88bf4ce](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/d88bf4ceaf9f6c36c1ea899904edb374d94fc3bc))
 - **FEAT**: Propagate errors on import failure. ([9d073f4b](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/9d073f4bdbcc4c901baf45c33ea33aa797bd61e7))
 - **FEAT**: Replace vsu1 and vpo1 in database, dynamic bout result calculation, update single bout pdf ([#76](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/76)). ([06bfb4d7](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/06bfb4d7f14ecbdf03516b2f863ac72173a419fd))

#### `wrestling_scoreboard_server` - `v0.1.1`

 - **FIX**: Allow adjacent import only for admins. ([dbab8896](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/dbab889601f01649780505bbe558cbb6e350356f))
 - **FIX**: Add new bout result rules in migration. ([73602c94](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/73602c94a1c39b07333ba3c707f3f3ad90410525))
 - **FIX**: Import dates as Utc. ([d619fd00](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/d619fd00773232370bbffb4004d54f522c104e21))
 - **FIX**: UTF8 export on Windows. ([50ccdcd2](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/50ccdcd29b872f1210c6e25eb819cf703cad3355))
 - **FIX**: Generate bouts ([#74](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/74)). ([ae10e354](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/ae10e354bba81a4b54fce7083514dd6dc96ee30c))
 - **FIX**(server): Drop club no index. ([7dd173f8](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/7dd173f8a1cbbe416e7e5c1097080b2c67cf7557))
 - **FIX**: Use common searchable data types. ([896e3bee](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/896e3bee9f1a4e3367392a331908c767eb99328e))
 - **FEAT**: Cache subjacent import data. ([339de0a2](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/339de0a26415669d5f22669c30440a245b03fe7d))
 - **FEAT**: Import subjacent data (closes [#96](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/96)). ([b109f8d0](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/b109f8d0766650825473ea845b6353e343ba755c))
 - **FEAT**: User administration. ([9ef4776c](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/9ef4776c5ea8ab2d56f6924f240170b405ddceb4))
 - **FEAT**: updateOrCreate on API import ([#71](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/71)). ([f194dd7e](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/f194dd7e95fdf4da80296946031089de844f2465))
 - **FEAT**: Bleeding Injury Duration (closes [#58](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/58)). ([34a462dd](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/34a462dd1a48f7b82915fce3e272ea10dbade343))
 - **FEAT**: Edit & Save BoutResultRule. ([6abdbdb1](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/6abdbdb1c0f76dde56c566430f2fcc12aca8ab52))
 - **FEAT**: TeamClubAffiliation (closes [#59](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/59)). ([d88bf4ce](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/d88bf4ceaf9f6c36c1ea899904edb374d94fc3bc))
 - **FEAT**: Propagate errors on import failure. ([9d073f4b](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/9d073f4bdbcc4c901baf45c33ea33aa797bd61e7))
 - **FEAT**: Suggest to import from API ([#74](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/74)). ([689923a1](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/689923a16f79a8bc7d21aab8c0844e5fdf135230))
 - **FEAT**: TeamMatchBouts of membership. ([34228e5f](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/34228e5f5bba04b0f30a06b9f7f3e41b1dc315d3))
 - **FEAT**: Replace vsu1 and vpo1 in database, dynamic bout result calculation, update single bout pdf ([#76](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/76)). ([06bfb4d7](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/06bfb4d7f14ecbdf03516b2f863ac72173a419fd))
 - **FEAT**: Database migration improvements and tests ([#71](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/71)). ([9e8b58be](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/9e8b58bed5586edd7a3038041bb2b52fb6f9685c))


## 2024-09-09

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`wrestling_scoreboard_common` - `v0.1.0`](#wrestling_scoreboard_common---v010)
 - [`wrestling_scoreboard_server` - `v0.1.0`](#wrestling_scoreboard_server---v010)
 - [`wrestling_scoreboard_client` - `v0.1.0`](#wrestling_scoreboard_client---v010)

---

#### `wrestling_scoreboard_common` - `v0.1.0`

 - **REFACTOR**: Organizational interface. ([49c415d9](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/49c415d9a4c36acca5ae3ec3fd73a425c75eb9fb))
 - **FIX**: Improve database imports. ([a60d3610](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/a60d3610c6fa766cb6b9e5e0b33caa0aacc50e63))
 - **FIX**: Restore data types order. ([17e63c1f](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/17e63c1fa830fcece8b96a4b5159c45e40eed447))
 - **FIX**: SecuredUserController init after database reset. ([9020dfb4](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/9020dfb4554e1caa5f0769d0ea18151b29c8197a))
 - **FIX**: Classification points and match display improvements (closes [#49](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/49)). ([061fdbb8](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/061fdbb83fa36493d5bf904651ff7930e930dcbd))
 - **FIX**: Refactor whereNotNull to nonNulls. ([890e5e64](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/890e5e6492d35821a13f79d02b81074966b1ae89))
 - **FIX**: Parse empty bout result. ([fedf1ead](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/fedf1ead2beef8d33b748adf8cba2a5453a30805))
 - **FIX**: User german adaption for passivity P / activity period A. ([21413365](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/214133650943d297fd950aae3d6a595469befac1))
 - **FEAT**: Obfuscate personal information without privileges. ([14dec0ac](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/14dec0ac1c2ae84ae03c7df35aebf2afcf331159))
 - **FEAT**: Authentication (closes [#2](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/2)). ([35aa99fe](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/35aa99feaefe94d7e5de17b9f13f1debc5e72f64))
 - **FEAT**: Split into OrganizationalController, reinit prepared statements (closes [#44](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/44)). ([af15ca77](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/af15ca773a55be781800bc53a9c3bfe6a9de6ff5))
 - **FEAT**: Duration for bouts. ([fca0bb2e](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/fca0bb2e5a5dc017d9c874ec436c292e27352b75))
 - **FEAT**: Logging. ([fffac49e](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/fffac49e2f482e944b89d21d46409d620b1b9d56))
 - **FEAT**: League boutDays, orgSyncId for DivisionWeightClass, organization for Bout. ([e956f37c](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/e956f37c9c6f75870af98b91733316a8b7e430ee))
 - **FEAT**: Force id on toRaw. ([a2646697](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/a26466971c6b7802d7bb5d9b67d681e3753b110e))
 - **FEAT**: Club, Bout and BoutAction imports. ([1a99ec91](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/1a99ec914434362651d46e595891991222a553b9))
 - **FEAT**: Activity period and five points. ([eb9c0801](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/eb9c080166c02abd45144e67cfe5fb4dc600615b))
 - **FEAT**: Search API provider (closes [#51](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/51)). ([0e90e1da](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/0e90e1da48ea64a9315819e062ecf5a40907c5de))

#### `wrestling_scoreboard_server` - `v0.1.0`

 - **REFACTOR**: Organizational interface. ([49c415d9](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/49c415d9a4c36acca5ae3ec3fd73a425c75eb9fb))
 - **REFACTOR**: id to organizationId. ([4175e8f2](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/4175e8f26e33dda4b45ccd8fd44b287e2049ee1d))
 - **FIX**: Improve database imports. ([a60d3610](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/a60d3610c6fa766cb6b9e5e0b33caa0aacc50e63))
 - **FIX**: Division weight class foreign constraint. ([f64f9e9a](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/f64f9e9af75919c97be0d4961d3c29b42a4172ab))
 - **FIX**: SecuredUserController init after database reset. ([9020dfb4](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/9020dfb4554e1caa5f0769d0ea18151b29c8197a))
 - **FIX**: Default value for `includeApiProviderResults` on build modes release, profile. ([70a47628](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/70a476281e1547bdf04afa91c358b3436da73484))
 - **FEAT**: Database migration (closes [#29](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/29)). ([b2d9c3d3](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/b2d9c3d322fb4639161aa4c731ec75253404f306))
 - **FEAT**: Improved logging (closes [#62](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/62)). ([e7568c88](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/e7568c8825c3f953a00b84650fb6f03014f2fbe3))
 - **FEAT**: Obfuscate personal information without privileges. ([14dec0ac](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/14dec0ac1c2ae84ae03c7df35aebf2afcf331159))
 - **FEAT**: Authentication (closes [#2](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/2)). ([35aa99fe](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/35aa99feaefe94d7e5de17b9f13f1debc5e72f64))
 - **FEAT**: Split into OrganizationalController, reinit prepared statements (closes [#44](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/44)). ([af15ca77](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/af15ca773a55be781800bc53a9c3bfe6a9de6ff5))
 - **FEAT**: Logging. ([fffac49e](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/fffac49e2f482e944b89d21d46409d620b1b9d56))
 - **FEAT**: toString for InvalidParameterException. ([9881390b](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/9881390b80aa39c1408a36558610ef298006f040))
 - **FEAT**: League boutDays, orgSyncId for DivisionWeightClass, organization for Bout. ([e956f37c](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/e956f37c9c6f75870af98b91733316a8b7e430ee))
 - **FEAT**: Club, Bout and BoutAction imports. ([1a99ec91](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/1a99ec914434362651d46e595891991222a553b9))
 - **FEAT**: Search API provider (closes [#51](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/51)). ([0e90e1da](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/0e90e1da48ea64a9315819e062ecf5a40907c5de))
 - **FEAT**: Edit persons and their memberships. ([cc30df7d](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/cc30df7d81c489bf390a2c70b4f60890830a7296))
 - **FEAT**: Support Search ([#51](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/51)). ([d1f5c305](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/d1f5c305e1c4a6351c3d6f8bf71ecb991493ac19))
 - **FEAT**(server): Add About section. ([86f5be84](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/86f5be844e5921136f3c6751522558e601fde0d6))
 - **DOCS**: Deployment and Nginx as Web server. ([8b105094](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/8b105094749cd2ec847a119a3ddcf8ed3ff952cd))

#### `wrestling_scoreboard_client` - `v0.1.0`

 - **REFACTOR**: Parallelize LoadingBuilders in Settings. ([48f5cc2b](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/48f5cc2b6515bbad0eb87838c6e9712062ad1604))
 - **REFACTOR**: Move settings up in hierachy. ([811847f2](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/811847f20b56bf0a396c4a127ddb256803b2d123))
 - **REFACTOR**: Remove redundant streams for providers. ([b3c90ca6](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/b3c90ca6d06b1891034a139f9d99b5d2aeb0cd6e))
 - **FIX**: Web package on native platforms. ([c36f3e22](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/c36f3e22b6a59ec95571f3630aed70c8ab194465))
 - **FIX**: Classification points and match display improvements (closes [#49](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/49)). ([061fdbb8](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/061fdbb83fa36493d5bf904651ff7930e930dcbd))
 - **FIX**: Routing and popping. ([35169211](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/3516921140f52cf2698279d26d9af96a546bfca2))
 - **FIX**: Info route in displays (closes [#54](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/54)). ([15f88a66](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/15f88a669ee4832d1734e03adffe94b68f3204db))
 - **FIX**: Analysis errors. ([2d7f491f](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/2d7f491fad59712479f7d2a9cdc81ccc4dedcca0))
 - **FIX**: Improve database imports. ([a60d3610](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/a60d3610c6fa766cb6b9e5e0b33caa0aacc50e63))
 - **FIX**: Exit fullscreen on Firefox ([#52](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/52), dart-lang/sdk[#50857](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/50857)). ([298b91f0](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/298b91f05c45672af6b060bc0dfe751318681c4d))
 - **FIX**: Default value for `includeApiProviderResults` on build modes release, profile. ([70a47628](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/70a476281e1547bdf04afa91c358b3436da73484))
 - **FIX**: Extensions for exporting files. ([36e42df9](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/36e42df982af286c7466c4d0afc63852857a705e))
 - **FIX**: Avoid recreating router on change font, theme or locale. ([79bd89bd](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/79bd89bd0592876448c00da4b443870bbde4b66a))
 - **FIX**: SecuredUserController init after database reset. ([9020dfb4](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/9020dfb4554e1caa5f0769d0ea18151b29c8197a))
 - **FIX**(client): Exception widget for organization drop down. ([580d5df3](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/580d5df317001f8a1c280a389b2bef6c6625a022))
 - **FIX**: Make home grid scrollable. ([fadb4708](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/fadb470879b63a83440faebe03990381480cda71))
 - **FIX**: Remove Expanded around TabBarView. ([eaf3081f](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/eaf3081f29637314a03327fdf59a52f6efd3d598))
 - **FEAT**: Dedicated utility file for exporting PNG, SQL, RDB and CSV data. ([014b3e94](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/014b3e9467f6e65a4271ea47ad75cdbcf4fd4ba7))
 - **FEAT**(client): Tab groups (closes [#65](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/65)). ([01426b9c](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/01426b9cafac137a7b92421145c4804913a9e904))
 - **FEAT**: League boutDays, orgSyncId for DivisionWeightClass, organization for Bout. ([e956f37c](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/e956f37c9c6f75870af98b91733316a8b7e430ee))
 - **FEAT**: Club, Bout and BoutAction imports. ([1a99ec91](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/1a99ec914434362651d46e595891991222a553b9))
 - **FEAT**: Activity period and five points. ([eb9c0801](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/eb9c080166c02abd45144e67cfe5fb4dc600615b))
 - **FEAT**: Replace go with push route. ([3d98b453](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/3d98b453a05a9bc749c72a01ae01a934715632ca))
 - **FEAT**: Search API provider (closes [#51](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/51)). ([0e90e1da](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/0e90e1da48ea64a9315819e062ecf5a40907c5de))
 - **FEAT**: Transcript for team matches ([#50](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/50)). ([523678da](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/523678dac320f0cd4f98fcbde83175df22018f0a))
 - **FEAT**: Change primary color. ([c1829ecd](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/c1829ecd8854eba0d3cfe78550a20969234fe5d5))
 - **FEAT**: Improve type localization. ([9d81d091](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/9d81d0911441303e5aa2fb0442b16f74076954a4))
 - **FEAT**: Edit persons and their memberships. ([cc30df7d](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/cc30df7d81c489bf390a2c70b4f60890830a7296))
 - **FEAT**: Support Search ([#51](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/51)). ([d1f5c305](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/d1f5c305e1c4a6351c3d6f8bf71ecb991493ac19))
 - **FEAT**: Lazy load fonts ([#57](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/57)). ([5507578f](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/5507578fd1ca1133e72ca7be5c446d892cf92eb4))
 - **FEAT**: Obfuscate personal information without privileges. ([14dec0ac](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/14dec0ac1c2ae84ae03c7df35aebf2afcf331159))
 - **FEAT**: Authentication (closes [#2](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/2)). ([35aa99fe](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/35aa99feaefe94d7e5de17b9f13f1debc5e72f64))
 - **FEAT**: Bundle Roboto font, fix dark text theme. ([4df0e5ec](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/4df0e5ec43714417a4b2d1104d60fff5cb4eb2df))
 - **FEAT**: Loading dialog. ([2c79d8dc](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/2c79d8dc66899098150af29653a68bc1cdb7eacd))
 - **DOCS**: Deployment and Nginx as Web server. ([8b105094](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/8b105094749cd2ec847a119a3ddcf8ed3ff952cd))

# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

## 2024-04-24

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`wrestling_scoreboard_client` - `v0.0.1-beta.12`](#wrestling_scoreboard_client---v001-beta12)
 - [`wrestling_scoreboard_common` - `v0.0.1-beta.12`](#wrestling_scoreboard_common---v001-beta12)
 - [`wrestling_scoreboard_server` - `v0.0.1-beta.12`](#wrestling_scoreboard_server---v001-beta12)

---

#### `wrestling_scoreboard_client` - `v0.0.1-beta.12`

 - **REFACTOR**: Remove unused `navigateTo` method. ([053275b0](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/053275b0e498cc7d385f3cb5cb555164690d87b6))
 - **FEAT**: Favorite remove option (closes [#53](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/53)). ([e5f5c92e](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/e5f5c92e2b061c058d2997d9a6dfa1c4196d0d31))
 - **FEAT**: Add privacy policy. ([58b8fb35](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/58b8fb3593696453da4b8300e1f4b8587e14af71))

#### `wrestling_scoreboard_common` - `v0.0.1-beta.12`

 - **FEAT**: BRV bout scheme integration. ([51297973](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/51297973a0fafcfe73a7982c3ae8c551ec30105b))

#### `wrestling_scoreboard_server` - `v0.0.1-beta.12`

 - **FEAT**: BRV bout scheme integration. ([51297973](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/51297973a0fafcfe73a7982c3ae8c551ec30105b))

# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

## 2024-04-20

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`wrestling_scoreboard_client` - `v0.0.1-beta.11`](#wrestling_scoreboard_client---v001-beta11)
 - [`wrestling_scoreboard_common` - `v0.0.1-beta.11`](#wrestling_scoreboard_common---v001-beta11)
 - [`wrestling_scoreboard_server` - `v0.0.1-beta.11`](#wrestling_scoreboard_server---v001-beta11)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `wrestling_scoreboard_server` - `v0.0.1-beta.11`

---

#### `wrestling_scoreboard_client` - `v0.0.1-beta.11`

 - **FIX**: Searchable dropdown filters. ([edfd27cf](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/edfd27cfb4ec6882568cc4baabb3a4e9d4883b8d))
 - **FEAT**: Exit fullscreen mechanism (closes [#52](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/52)). ([ec20df3b](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/ec20df3bb6efdb1b5aa037860916938383dd566a))

#### `wrestling_scoreboard_common` - `v0.0.1-beta.11`

 - **FIX**: Searchable dropdown filters. ([edfd27cf](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/edfd27cfb4ec6882568cc4baabb3a4e9d4883b8d))


## 2024-04-05

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`wrestling_scoreboard_client` - `v0.0.1-beta.10`](#wrestling_scoreboard_client---v001-beta10)
 - [`wrestling_scoreboard_common` - `v0.0.1-beta.10`](#wrestling_scoreboard_common---v001-beta10)
 - [`wrestling_scoreboard_server` - `v0.0.1-beta.10`](#wrestling_scoreboard_server---v001-beta10)

---

#### `wrestling_scoreboard_client` - `v0.0.1-beta.10`

 - **FIX**: Download on web. ([b51b493e](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/b51b493ee6fe9363b90c937325d4f7073152ee95))
 - **FIX**: Show body on import operation exception. ([50190efd](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/50190efd60dd7f360f37f27c34191a3de28bb3a8))
 - **FIX**: Scroll on dialogs. ([10494eec](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/10494eecd2ec441225e063eb1854ea81faeafef5))
 - **FEAT**: Append year of divisions and leagues. ([055fe1b0](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/055fe1b07e8aefc91c78716021a898a769966a37))
 - **FEAT**: Improve colors of favorite cards. ([97e9e2dd](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/97e9e2ddc5d030df64c1e18d3a03f57380fa537d))
 - **FEAT**: Enable signing for Android. ([ff525e37](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/ff525e377cb60bf00182ef698d74700439dd7006))
 - **FEAT**: Add organization info when editing. ([25ea14be](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/25ea14be3afe92b32e281727b9762b47b2fabc5d))
 - **FEAT**: Favorites (closes [#28](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/28)). ([77aa0f7d](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/77aa0f7de83299d3702a28d5c83f5afc9ae5c9bd))

#### `wrestling_scoreboard_common` - `v0.0.1-beta.10`

 - **REFACTOR**: Replace switch case with expression. ([2c1ac540](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/2c1ac5407fb433bb6b331e965952df013be86f9f))
 - **FIX**: Live organization import. ([e5d12c06](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/e5d12c065b379dde396ce727175ae69341212f8e))
 - **FIX**: Make BasicAuthService nullable. ([3c771214](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/3c77121451bab9240ffe9a1fb318788175a94cf3))

#### `wrestling_scoreboard_server` - `v0.0.1-beta.10`

 - **FIX**: Live organization import. ([e5d12c06](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/e5d12c065b379dde396ce727175ae69341212f8e))
 - **FEAT**(server): Order team matches by date. ([8743d117](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/8743d117a153d881b5be085242752cb398a52186))
 - **FEAT**: Add organization info when editing. ([25ea14be](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/25ea14be3afe92b32e281727b9762b47b2fabc5d))


## 2024-03-24

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`wrestling_scoreboard_client` - `v0.0.1-beta.9`](#wrestling_scoreboard_client---v001-beta9)
 - [`wrestling_scoreboard_common` - `v0.0.1-beta.9`](#wrestling_scoreboard_common---v001-beta9)
 - [`wrestling_scoreboard_server` - `v0.0.1-beta.9`](#wrestling_scoreboard_server---v001-beta9)

---

#### `wrestling_scoreboard_client` - `v0.0.1-beta.9`

 - **REFACTOR**: Dart format. ([ace81ead](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/ace81eadbd6d7a1c5eb6cb62435229e78bddee49))
 - **FIX**: Height of exception widgets. ([fb62a31e](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/fb62a31ed7dd4b141d5bd7f24f98d32c09abe638))
 - **FIX**: Use stopwatch for bout action duration. ([5152595f](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/5152595fb280fb6f65976094fe35ddade4ae447e))
 - **FIX**: Save empty membership no as null. ([5891d59e](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/5891d59ea258cbc8926a1fc21255dbbd8a4f8500))
 - **FIX**(client): Saving Lineup. ([3bc02dac](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/3bc02dacc12b6de2b17b2f125188ca59286100fd))
 - **FIX**: Minor fixes and improvements. ([832aee56](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/832aee5606a301a5a6d4cd3c939a12af908d3dea))
 - **FEAT**: Basic support for API providers ([#47](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/47)). ([fea89a89](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/fea89a893043198566f9bda9052940308ae8ba20))
 - **FEAT**: Exception Dialogs, Shortcuts and Navigation. ([c4ab7fea](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/c4ab7feaddb4e82bc8de604d4e5e1516059e29cb))
 - **FEAT**: Improve output of RestException. ([97a94441](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/97a94441da7684e278478f030865a250c1ff8d77))
 - **FEAT**(client): GUI for organizations, divisions, favorites. ([ab30f8ac](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/ab30f8ac2b5943ad17f6e122a889dc2723b6eb87))
 - **FEAT**: Use exception dialog when websocket connection closed. ([1a727f2b](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/1a727f2b30d2be5d6f2faae58c82a18b6ed0d8b7))
 - **FEAT**: Division and Organization. ([bf182c22](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/bf182c22687c8d42c7843e41aab9e5e232ee9a9b))
 - **FEAT**: StackTrace for ExceptionWidget. ([c0b1231b](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/c0b1231bec25d8aad44103e446725c0e8efde466))
 - **FEAT**: Async exception widget. ([64c524b7](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/64c524b7ce2d069c602f10c804869b767b841053))
 - **FEAT**: Feedback on reset / restore DB, simplify Dialogs. ([a45e8463](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/a45e846321e727cd1c0eb4a28ac2514ad1922fdc))
 - **FEAT**: Results report for germany NRW ([#1](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/1)). ([5d57411a](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/5d57411a77e0af92bbe9fd121c2a11a8380fc413))
 - **FEAT**: Language and Font settings (closes [#24](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/24)). ([86c8bcbd](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/86c8bcbdaa0ce21e9bd1c9331820568bf62b05c5))
 - **FEAT**: Add network timeout setting, reorder settings. ([d63e7ce9](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/d63e7ce9459d774a6b44586a5d57be16caa49897))
 - **FEAT**: Database export and restore from client. ([3bec47a0](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/3bec47a0b471b80520f4bf2618d7875f17d6ec37))
 - **FEAT**: Show network timeout ([#44](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/44)). ([bdbda2ae](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/bdbda2aec4739bca52ce1658e7a26adc5fcbbfb4))
 - **FEAT**: Format seconds to readable string. ([b1d58e10](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/b1d58e105958a7e86dc56010b1065a65b3435d62))
 - **FEAT**: Edit duration. ([e3b12f46](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/e3b12f460a44a9d900f5f972e50435681e6f389a))
 - **FEAT**: Apply duration picker. ([94e07d29](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/94e07d294e5251e7bdfa13c017c90ec4edb78241))
 - **FEAT**: Delete button for bout action (closes [#38](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/38)). ([471126c2](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/471126c24b9614bb7829bc9a731aa6991a53f823))
 - **FEAT**: Adding season partition (closes [#3](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/3)). ([b7836868](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/b78368684ff49e81b30eb35a2cb7a4d41236a141))
 - **DOCS**: Update READMEs. ([91786fad](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/91786fad183eb139892284a5b86666eb85112782))

#### `wrestling_scoreboard_common` - `v0.0.1-beta.9`

 - **REFACTOR**: Convert enum names. ([a4eaa319](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/a4eaa319d1417dc3167966981e68e27c001b3143))
 - **REFACTOR**: Run build_runner. ([bb1a8e05](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/bb1a8e05d74ac1d97ed368e4612769005965cb34))
 - **FIX**(server): Throw exception on null values in getSingle. ([2da48fe5](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/2da48fe5be8243c7d707fce507dcefddf694d245))
 - **FIX**: Minor fixes and improvements. ([832aee56](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/832aee5606a301a5a6d4cd3c939a12af908d3dea))
 - **FEAT**: Basic support for API providers ([#47](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/47)). ([fea89a89](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/fea89a893043198566f9bda9052940308ae8ba20))
 - **FEAT**(client): GUI for organizations, divisions, favorites. ([ab30f8ac](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/ab30f8ac2b5943ad17f6e122a889dc2723b6eb87))
 - **FEAT**: Division and Organization. ([bf182c22](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/bf182c22687c8d42c7843e41aab9e5e232ee9a9b))
 - **FEAT**: Results report for germany NRW ([#1](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/1)). ([5d57411a](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/5d57411a77e0af92bbe9fd121c2a11a8380fc413))
 - **FEAT**: Edit duration. ([e3b12f46](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/e3b12f460a44a9d900f5f972e50435681e6f389a))
 - **FEAT**: Delete button for bout action (closes [#38](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/38)). ([471126c2](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/471126c24b9614bb7829bc9a731aa6991a53f823))
 - **FEAT**: Adding season partition (closes [#3](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/3)). ([b7836868](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/b78368684ff49e81b30eb35a2cb7a4d41236a141))

#### `wrestling_scoreboard_server` - `v0.0.1-beta.9`

 - **FIX**: Update bout actions on editing time. ([50242488](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/50242488ff5efb1f4e49665d90c4dbf75707925a))
 - **FIX**(server): Update bouts in match ([#40](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/40)). ([1dbb9ef6](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/1dbb9ef6bddf864a36aded31f0bcfe5cd6b66fc2))
 - **FIX**(server): Throw exception on null values in getSingle. ([2da48fe5](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/2da48fe5be8243c7d707fce507dcefddf694d245))
 - **FIX**(server): Delete bout dependencies. ([d34e088f](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/d34e088f25ae4bf610695deca7e1a59df5893716))
 - **FEAT**: Basic support for API providers ([#47](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/47)). ([fea89a89](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/fea89a893043198566f9bda9052940308ae8ba20))
 - **FEAT**: Division and Organization. ([bf182c22](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/bf182c22687c8d42c7843e41aab9e5e232ee9a9b))
 - **FEAT**: Results report for germany NRW ([#1](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/1)). ([5d57411a](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/5d57411a77e0af92bbe9fd121c2a11a8380fc413))
 - **FEAT**: Database export and restore from client. ([3bec47a0](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/3bec47a0b471b80520f4bf2618d7875f17d6ec37))
 - **FEAT**(server): Restore default. ([e78e02ea](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/e78e02ea45c853a3e1904a2bd3fa96c1be81a627))
 - **FEAT**: Adding season partition (closes [#3](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/3)). ([b7836868](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/b78368684ff49e81b30eb35a2cb7a4d41236a141))
 - **DOCS**: Update READMEs. ([91786fad](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/91786fad183eb139892284a5b86666eb85112782))

# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

## 2024-02-26

### Changes

---

Packages with breaking changes:

 - [`wrestling_scoreboard_client` - `v0.0.1-beta.8`](#wrestling_scoreboard_client---v001-beta8)
 - [`wrestling_scoreboard_common` - `v0.0.1-beta.8`](#wrestling_scoreboard_common---v001-beta8)
 - [`wrestling_scoreboard_server` - `v0.0.1-beta.8`](#wrestling_scoreboard_server---v001-beta8)

Packages with other changes:

 - There are no other changes in this release.

---

#### `wrestling_scoreboard_client` - `v0.0.1-beta.8`

 - **REFACTOR**: regenerate windows directory. ([63326f29](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/63326f2999dbf89a6e6426411c77e03632817e20))
 - **REFACTOR**: Minor improvements to the DateTime formatter ([#31](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/31)). ([5821c960](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/5821c96084f28df3f872670666e4c9c0df7e13d4))
 - **REFACTOR**: Dart format. ([bca92c11](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/bca92c11d84f66ca42966275729936f8ebf603f1))
 - **REFACTOR**: Adapt LoadingBuilder functionality. ([4534f11c](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/4534f11c53d0961ebf32dea6693f153c9bb5a04c))
 - **REFACTOR**: Extensions for localizations. ([ae0f0deb](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/ae0f0deb87e3aad3ee22a3d86de63d629aa790e1))
 - **REFACTOR**: Adapt folder structure. ([d9ae8db7](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/d9ae8db75fac7fc2f3faddb968e1f51e72c09d5c))
 - **REFACTOR**: Split clubs and leagues view from home. ([edfaa001](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/edfaa001ab794869947bb5e33e9acb7a747408b1))
 - **REFACTOR**: Move more screen. ([62e1eb05](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/62e1eb05d5563c1792dbb23e48d5b6b338ed83f4))
 - **REFACTOR**: DataProvider to DataManager. ([c109b377](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/c109b3770c0fbc599d2e127768df2acea6e16321))
 - **REFACTOR**: DataManagerNotifier. ([cc31e580](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/cc31e5807720e3a86a9d1c81c00c71ee1d1381af))
 - **REFACTOR**: Bout actions as riverpod many stream provider (closes [#25](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/25)). ([e7f9f651](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/e7f9f6513910dd3741adb3685de115032f39133a))
 - **REFACTOR**: Move team_match screens. ([72751af6](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/72751af64f005a3eae9cd3feffa4ad9e7299e141))
 - **REFACTOR**: Move team_match screens. ([613b4572](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/613b45725ac9753c9c852ac39e8c7dd2e92b70aa))
 - **REFACTOR**: Move settings into 'more'. ([85477aa7](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/85477aa7aa213c900f35d46275f56c14c32c01ea))
 - **REFACTOR**: Apply linter rule always_use_package_imports. ([ff7444de](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/ff7444dee497276150276d70724b1f74c5f5eded))
 - **REFACTOR**: Move display screens in subfolder. ([a7c47238](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/a7c47238426543ee4d6dfa71778d93fcc6e4c41b))
 - **REFACTOR**: Replace default cases. ([62bc9b2f](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/62bc9b2f057c6ccdb4f9796e89c747ef98233e64))
 - **REFACTOR**: full package names. ([8dfa2e58](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/8dfa2e5843ee2a4ed1a4336943e94f90b0356ffb))
 - **REFACTOR**: Make analyzer happy. ([0fb50aba](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/0fb50abae1f1701fe9bc5ef877df86857379a2c6))
 - **REFACTOR**: Environment variables. ([cf38fa4e](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/cf38fa4ea691547f9a95fa5f9ee967226f122ff3))
 - **REFACTOR**: move to folder prefixed with `wrestling_scoreboard`. ([e44109c7](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/e44109c7b02663d32d228226db25c1f721d1b0ee))
 - **REFACTOR**: Rename route ids. ([c19186fb](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/c19186fb66c3eb238ca2260d4cf45fa5a6b05cb9))
 - **REFACTOR**: fight_screen to fight_display, match_sequence to match_display. ([5ab4607e](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/5ab4607e5bfa7bd7dfea2482278ec1980cd44ce2))
 - **FIX**: Set initial period. ([ff9deee2](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/ff9deee2186a7aefb0eecaeda18993eb21843d6d))
 - **FIX**: Text scaling for FittedText. ([589c8d2b](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/589c8d2b327f5ef377952f05cc2d53104b93de53))
 - **FIX**: Properly handle saving on leaving bout display. ([cd4dbd34](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/cd4dbd34db0c6e47cabcdde83460399c74c6719f))
 - **FIX**: Resolve linter issues. ([5f4e2c24](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/5f4e2c24a82a32aa0794880a21dc971d902584be))
 - **FIX**: Updating time, after disposing (closes [#22](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/22)). ([28c5a819](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/28c5a819a01782c3d7d725461be858e6d76c76af))
 - **FIX**: Nullable ParticipationState. ([73cffeb0](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/73cffeb01d3667394edce623390cd419f4da071b))
 - **FIX**: Yield initial data. ([05b5d626](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/05b5d6266a444dd6a21236d495b82a824de9e68b))
 - **FIX**: Equality of ProviderData. ([67bf7f7f](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/67bf7f7f2283955956fb7262b415ee1199f9465c))
 - **FIX**: Show empty bout actions. ([dba37bc3](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/dba37bc3039277483b0414f584a62efcf209fd46))
 - **FIX**(client): Avoid progress indicator if data is available while loading. ([a66dfbd0](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/a66dfbd089f0b384e5e4238ada23f6ce616c22c3))
 - **FIX**(client): remove textScaleFactor from TextSpan. ([1ebc7499](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/1ebc7499c0d01a4247503b6e4d6f8f180c677fc3))
 - **FIX**: Light theme inconsistencies in colored containers (closes [#18](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/18)). ([79c2bfdb](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/79c2bfdb252166504390b6162db1512bf9a3c002))
 - **FIX**: Load theme from preferences. ([c06fa53b](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/c06fa53b1a3f5fb9378b1e608e187ef97f32a4fe))
 - **FIX**(linux): Use correct application name. ([81e813cb](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/81e813cb69b843476d4c797775d16e7e4d925a51))
 - **FIX**: Handle exceptions for server connection (closes [#27](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/27)). ([e1824744](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/e1824744e69aacd86467ab3d5bbcfeb18539db9c))
 - **FIX**: Missing generics in riverpod generation. ([40a53709](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/40a537093bd1233a97299d16696d6f5948cf14a4))
 - **FIX**: Async initialization. ([43c208b5](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/43c208b5e47385c9d4acfdc69d2e1e14351e06c8))
 - **FIX**(client): Use Null for unfiltered DataObjects. ([e8c0544c](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/e8c0544c6872e4815e86c04927c9d20a763dbb61))
 - **FIX**: translations. ([eaaa4135](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/eaaa4135f5939ea3a9e25a852e10f8151847ca65))
 - **FIX**: DSQ2 should not be available if vacant. ([1609267c](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/1609267c1608a40225c28e1695cd37c6160702b7))
 - **FIX**: Add data types for deletion. ([af612806](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/af6128068f95689681fbf4838fb39bd2f2255b2e))
 - **FIX**: add internet permission for Android release. ([f7e6a9b5](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/f7e6a9b50d67dd928137e46750f8947d401606ae))
 - **FIX**: Use try parse int. ([ba52d68b](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/ba52d68b59ed2ee634e5bd68553a1d711f7d39d7))
 - **FIX**(linux): launcher icon not shown. ([a06cae49](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/a06cae49c6099cc5371a3ac8cf6d65ffaa64367d))
 - **FIX**: Icon alignments (closes [#6](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/6)). ([aa659983](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/aa65998352b6e4a8e3b0cc8293d7c0029ad10802))
 - **FIX**(web): Style for dark theme mode. ([861473d2](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/861473d2fbaccc965fcf950fbb3572eff6210555))
 - **FIX**: Update team matches on add to league. ([a3ae6ec2](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/a3ae6ec291985398456f41f9d334171bbb2bd6d5))
 - **FIX**: Replace runtimeType with generic Type. ([239d951d](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/239d951dc24da50153aa32da8291979bc9655e12))
 - **FIX**(client): Update correct id. ([9b582961](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/9b582961e8121d3c50f8e85229d732cb20fcc064))
 - **FIX**(client): Fix networking, icons, labels. ([2cc1497b](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/2cc1497b83c0904c459eec40647eabd161c153f6))
 - **FIX**: Make league_team_participation working. ([853a5c04](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/853a5c04213473e88a3096acbfdb6422a9aa8877))
 - **FIX**(client): Make generic requests work. ([b5968055](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/b5968055ce5a14a903db9d56b9aabd4e22636630))
 - **FIX**(client): lints. ([3e699c20](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/3e699c20f5adec318909ceea8e45d3d7effcf520))
 - **FIX**: platform execution. ([ae78b0f5](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/ae78b0f5df062737ae573eedc1540a92aa139bf2))
 - **FIX**(android): main activity. ([72105dfd](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/72105dfdac55cb302f91ce56f378d551e8b152b9))
 - **FIX**: set initialData to null on ManyConsumer. ([044674d7](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/044674d723c099feeb848c739f1b021a8e67b731))
 - **FEAT**: Rewrite audio handling. ([7bd6f9df](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/7bd6f9df1cef692f6763f14478c69269ad9b361d))
 - **FEAT**: Change Theme mode via Settings. ([c7b39db7](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/c7b39db732560a95a99550b60d9364d766498bfd))
 - **FEAT**: Duration Edit for Bout. ([9c341918](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/9c341918c7aebee15ffa8f8ff0312c888617e873))
 - **FEAT**: Rename App to Wrestling Scoreboard. ([38580cb9](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/38580cb913499a5460bbb7910368bd19f4815086))
 - **FEAT**: Add ic_launcher. ([ed8fe12a](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/ed8fe12aa6acb50173aeb183d5d08b5b542507a3))
 - **FEAT**: Differentiate Save and Generate Bouts from Lineups ([#26](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/26)). ([a26798f9](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/a26798f981e7e00a13fcf959b5eeeffb5f7b2dba))
 - **FEAT**: Update texts of fight result. ([56039063](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/560390630d75aa2c47e84f693f0dcd228d670c62))
 - **FEAT**: Show fights in match overview. ([93a48b8c](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/93a48b8cf26f2c28f79ea7464bf1a0ffb1b82715))
 - **FEAT**: Add persons to match overview. ([bd4e8294](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/bd4e8294bd7f6a732ba0d4d5b84a2da1db29352e))
 - **FEAT**: Limit width of overview and edit screens (closes [#20](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/20)). ([d95339c5](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/d95339c5475be8ca0787664c8ef35f7156880c7f))
 - **FEAT**: Show error message in AlterDialog. ([4e060811](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/4e0608115a80b3c70354439a68579dcdfae1c1e0))
 - **FEAT**: Ability to edit league_team_participation. ([466b8159](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/466b815977b421234b399f51ccad3422b5b91efb))
 - **FEAT**: Use system theme. ([de15f4d6](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/de15f4d6aad76f8d26fbc4fba3c5c38a5093b5e7))
 - **FEAT**: Add Dropdowns. ([61746f73](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/61746f7317e2d7854fcf74841ea45239f083fe88))
 - **FEAT**: Move AppBar action in fight display. ([f8cf86fa](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/f8cf86faf336bb39bf41d2b22183f1703816bfa4))
 - **FEAT**: Scaled text in fight display. ([190fb853](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/190fb853d1a8f533aca002f517227c459eb4e662))
 - **FEAT**: Adaptive fight list. ([f3ed1273](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/f3ed12733fc835ae8e2afc79ef841214e6b1ab76))
 - **FEAT**: Adapt style for settings, more (closes [#17](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/17)). ([27f3c3b8](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/27f3c3b852e75db580901ea9d6a96080b4d96e35))
 - **FEAT**: NullableSingleConsumer. ([b008366b](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/b008366be74c753360ea57d6afd13b0efa8853d7))
 - **FEAT**(server): Make WeightClass nullable. ([c0f69526](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/c0f6952607422e2a89608873b02e7bd53ec853f8))
 - **FEAT**: Make FightDisplay available via route. ([62cebf33](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/62cebf3338579e1c2033c0a6d38528112f6b8061))
 - **FEAT**: Use Roboto font. ([8c0d4b50](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/8c0d4b508f688999847205995aaf3aaf1d80e0cc))
 - **FEAT**: Handling unavailable data. ([0e163ec1](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/0e163ec1d2615050883dd81c8cb4dd8114f43f9c))
 - **FEAT**: AppBar title styling. ([1044d319](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/1044d3190d5bb2879395a9c72f40c44cf9883ed4))
 - **FEAT**: Button for Display match sequence. ([8af9410f](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/8af9410f0db6fef40afea009d4a4ae13f749079d))
 - **FEAT**: Url Routing. ([a77a0cde](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/a77a0cde598f95703dbfc40da9e0a93e9c4d8bae))
 - **FEAT**: Show Changelog in app. ([008f8807](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/008f88079ee48ae01332a104e266028b41ad0fb6))
 - **FEAT**: Imprint, About, Licenses, Changelog. ([7f21dab8](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/7f21dab88f55e7c53abfd433d8d3646d84716ced))
 - **FEAT**: SingleStreamProvider. ([0e8b2984](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/0e8b2984e3165d3853e92742cd92bdd35b0fea53))
 - **FEAT**: Show match-up list in the league page (closes [#5](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/5)). ([01eacea7](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/01eacea7bd2c509971a7d9eeaf77a963627b9328))
 - **FEAT**: enable GoRouter.optionURLReflectsImperativeAPIs to reflect url. ([4c357fea](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/4c357fea861b9d203808793d84861e234a593ec9))
 - **FEAT**: generate score sheet pdf. ([3f7ac05c](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/3f7ac05c07f4e47d17e50543d648c667fea42cbe))
 - **FEAT**: split TeamMatch from Bout Screen. ([320c34d9](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/320c34d9a3b17054a6897ffbc58d92633d178d00))
 - **FEAT**: Bout overview and edit ([#26](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/26)). ([a07ec1e4](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/a07ec1e457d560551d25e436445970dcf9660e60))
 - **FEAT**: Add fullscreen in web. ([c229460f](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/c229460f276bd1365683024c9f432247cb86578f))
 - **FEAT**: Handle error message on displays. ([8cd154e3](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/8cd154e38dc4fd294ce42408d0ef75570521156d))
 - **FEAT**: Add riverpod state management. ([425849cd](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/425849cd01e6a94d83a9e343ade5cbbdfb809c4e))
 - **FEAT**: Implement full screen mode. ([2569bfde](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/2569bfde594f88b430f7a65083f2c18ffb7831f7))
 - **FEAT**: Wrap dataManager in provider. ([bbc3e97b](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/bbc3e97bf667780ba7fb898306f2d04983d7c4a1))
 - **FEAT**: run build_runner, adapt lint naming conventions. ([56589559](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/565895597550717c3c85e47cecca8d786566a518))
 - **FEAT**: replace ManyConsumer with ManyStreamConsumer. ([ff7186b3](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/ff7186b318ca3431b751cb655fb309e6f522bd37))
 - **FEAT**: Add CompetitionsView. ([e39198df](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/e39198df295c86688297f89deba6b55699b3758e))
 - **FEAT**: Regenerate launcher icons. ([b92cb550](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/b92cb55053d554c9d0169b6c572c48d8969ae400))
 - **FEAT**: Move locale preferences to riverpod. ([3cca2a02](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/3cca2a0248103061532dd992aacd21ac81672a15))
 - **FEAT**: Adapt the fight action controls. ([b6654ba1](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/b6654ba177e3885122788ab858ea5fdf84945247))
 - **DOCS**(client): Replace flutter_dotenv docs. ([60bb219c](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/60bb219cb7b989642b897a39651d1f8b9ca7f8db))
 - **DOCS**: Add UWW wrestling rules. ([8a4dcc1c](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/8a4dcc1c6270e2a702acd1acab8a0d1ad2d7835e))
 - **DOCS**: Add uww score sheet for competitions. ([5f6112fa](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/5f6112fac18d931c4ecfeca6da67ea381aa1be6a))
 - **BREAKING** **REFACTOR**: remove flutter_dotenv. ([87dea399](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/87dea399f7eb5f47779ff630b92d0b66bd8d0844))
 - **BREAKING** **REFACTOR**: Fight to Bout ([#4](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/4)). ([22e4e2c7](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/22e4e2c7a69a2c2b379bf71ab34bdfd53f1d6a1e))
 - **BREAKING** **REFACTOR**: Tournament to Competition ([#4](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/4)). ([6d0ea4b4](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/6d0ea4b4af1f2507dfdb6a0571eb13af8f2c8704))

#### `wrestling_scoreboard_common` - `v0.0.1-beta.8`

 - **REFACTOR**: Dart format. ([bca92c11](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/bca92c11d84f66ca42966275729936f8ebf603f1))
 - **REFACTOR**(common): Remove unnecessary conversion to json. ([5ae2d275](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/5ae2d275bb83d3d5dd89fc2a61b8f0ef0be39ad1))
 - **REFACTOR**: move to folder prefixed with `wrestling_scoreboard`. ([e44109c7](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/e44109c7b02663d32d228226db25c1f721d1b0ee))
 - **FIX**: Show empty bout actions. ([dba37bc3](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/dba37bc3039277483b0414f584a62efcf209fd46))
 - **FIX**: Add pos to raw TeamMatchFight. ([ecf3f62c](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/ecf3f62ceb46dbe7ed5a5496f774100c6121d5b0))
 - **FIX**: Update team matches on add to league. ([a3ae6ec2](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/a3ae6ec291985398456f41f9d334171bbb2bd6d5))
 - **FIX**: Make league_team_participation working. ([853a5c04](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/853a5c04213473e88a3096acbfdb6422a9aa8877))
 - **FIX**(common): updateClassificationPoints. ([d412da91](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/d412da91b86bc9fd2d9af64c480c77a5276795d0))
 - **FIX**(common): parse nullable Gender of Person. ([d24a97d4](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/d24a97d4c957e032de635fa4aa21cd2969421390))
 - **FIX**: JsonSerializable not recognizing static variables. ([b0d2c554](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/b0d2c55484ad7bf37363a9334e837915d6ec32d6))
 - **FEAT**(server): Reset, Restore and Upgrade database. ([a7ac6fbd](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/a7ac6fbd2a5d4c35a75a12774ee7af21bdbdd333))
 - **FEAT**(server): Make WeightClass nullable. ([c0f69526](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/c0f6952607422e2a89608873b02e7bd53ec853f8))
 - **FEAT**: Bout overview and edit ([#26](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/26)). ([a07ec1e4](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/a07ec1e457d560551d25e436445970dcf9660e60))
 - **FEAT**: Update texts of fight result. ([56039063](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/560390630d75aa2c47e84f693f0dcd228d670c62))
 - **FEAT**(common): Use getter with freezed. ([cde5241f](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/cde5241ffc27b173862f4ff5e035364efbfba6e9))
 - **FEAT**(common): Replace JsonAnnotation with Freezed. ([28f04b70](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/28f04b7018041ec399e535a94ed3c41efd409dba))
 - **FEAT**(common): Tournament team participation. ([63ec7c79](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/63ec7c790c84fa26718b7b18b85c2327b8cf084b))
 - **FEAT**(common): Tournament team participation. ([beeb7010](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/beeb7010207dc06d524a375d9d8a2349cfdb3336))
 - **FEAT**: run build_runner, adapt lint naming conventions. ([56589559](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/565895597550717c3c85e47cecca8d786566a518))
 - **BREAKING** **REFACTOR**: Tournament to Competition ([#4](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/4)). ([6d0ea4b4](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/6d0ea4b4af1f2507dfdb6a0571eb13af8f2c8704))
 - **BREAKING** **REFACTOR**: Fight to Bout ([#4](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/4)). ([22e4e2c7](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/22e4e2c7a69a2c2b379bf71ab34bdfd53f1d6a1e))

#### `wrestling_scoreboard_server` - `v0.0.1-beta.8`

 - **REFACTOR**: Add ignores. ([83d1a2ab](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/83d1a2ab74ec3243af65349c977b34d4f9234243))
 - **REFACTOR**: Dart format. ([bca92c11](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/bca92c11d84f66ca42966275729936f8ebf603f1))
 - **REFACTOR**: full package names. ([8dfa2e58](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/8dfa2e5843ee2a4ed1a4336943e94f90b0356ffb))
 - **REFACTOR**: move to folder prefixed with `wrestling_scoreboard`. ([e44109c7](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/e44109c7b02663d32d228226db25c1f721d1b0ee))
 - **FIX**(server): Handle prepared statements correctly (closes [#32](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/32)). ([9f96c133](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/9f96c133d50746c80f4e635ed35df2637da33851))
 - **FIX**(server): Restore database. ([10dccec4](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/10dccec4760c0bad12504e4453cbe103a93df797))
 - **FIX**: Show empty bout actions. ([dba37bc3](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/dba37bc3039277483b0414f584a62efcf209fd46))
 - **FIX**: Update team matches on add to league. ([a3ae6ec2](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/a3ae6ec291985398456f41f9d334171bbb2bd6d5))
 - **FIX**: Replace runtimeType with generic Type. ([239d951d](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/239d951dc24da50153aa32da8291979bc9655e12))
 - **FIX**: Make league_team_participation working. ([853a5c04](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/853a5c04213473e88a3096acbfdb6422a9aa8877))
 - **FIX**(server): lints. ([1ee137c9](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/1ee137c9d171315faf6d3279fe6b8e070556f8e3))
 - **FIX**(linux): launcher icon not shown. ([a06cae49](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/a06cae49c6099cc5371a3ac8cf6d65ffaa64367d))
 - **FIX**(server): enable pingInterval for WebSocket to keep connection alive (close [#10](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/10)). ([3474e86f](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/3474e86f3e9ea82b2514824c37de8b5758848db2))
 - **FIX**: adapt_database schema. ([1c67adc5](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/1c67adc5a99e4960ee75feea5e30b8abf6012c3c))
 - **FEAT**(server): Export database. ([6e17086b](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/6e17086b8a79873abfe702c950bb90bfa7bfc31e))
 - **FEAT**(server): Reset, Restore and Upgrade database. ([a7ac6fbd](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/a7ac6fbd2a5d4c35a75a12774ee7af21bdbdd333))
 - **FEAT**: Migrate to postgres v3. ([c015233e](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/c015233e3857c423a6d1898fb3fcd95a5d09f007))
 - **FEAT**(server): Make WeightClass nullable. ([c0f69526](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/c0f6952607422e2a89608873b02e7bd53ec853f8))
 - **FEAT**: split TeamMatch from Bout Screen. ([320c34d9](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/320c34d9a3b17054a6897ffbc58d92633d178d00))
 - **FEAT**(server): Add default pos to team_match_bout. ([1dc5f618](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/1dc5f6183690586e6c2157553b0d7e3ecd9ee2ba))
 - **FEAT**(server): Allow ordering by multiple features. ([91712f7b](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/91712f7b89fef2c509abfb3d1806ad48a14bd68d))
 - **FEAT**: Show match-up list in the league page (closes [#5](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/5)). ([01eacea7](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/01eacea7bd2c509971a7d9eeaf77a963627b9328))
 - **FEAT**(database): Adapt database schema. ([ef904283](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/ef904283b3f9ed38a361789d266f9e77751f73d6))
 - **DOCS**(server): Update README.md. ([d72f6213](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/d72f6213bcff616e4f4bd37f009f118146e7e279))
 - **DOCS**(server): Make wrestling-scoreboard-server executable. ([48f4b94b](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/48f4b94b94f9f8fef8f914ee90931cdd68a1cbfb))
 - **DOCS**(server): Connect to psql via peer authentication. ([db3875c6](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/db3875c6afce5199b73c0a90419eae2b90f8f58a))
 - **DOCS**(server): Update database README. ([91c13809](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/91c138095403ed304e57a455ccfdd385e8beb939))
 - **DOCS**: adapt to new paths. ([2dca9685](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/2dca9685bd687d84730fd9e4eaa83db5a678fdc8))
 - **BREAKING** **REFACTOR**: Tournament to Competition ([#4](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/4)). ([6d0ea4b4](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/6d0ea4b4af1f2507dfdb6a0571eb13af8f2c8704))
 - **BREAKING** **REFACTOR**: Fight to Bout ([#4](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/4)). ([22e4e2c7](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/22e4e2c7a69a2c2b379bf71ab34bdfd53f1d6a1e))

## 2023-04-29

- Initial version.
