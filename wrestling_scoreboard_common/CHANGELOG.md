## 0.3.6

 - **FIX**: Disallow starting ObservableStopwatch, if hasEnded. ([6f61c5cd](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/6f61c5cda0cf1ed5be93de67d330cddbbafd3846))
 - **FIX**: Always handle 'V' as 'P' on german RDB export ([#222](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/222)). ([50df097f](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/50df097f4a10eccca27bbf6c690daf138c8609fe))
 - **FIX**: Keep single providers of many lists alive ([#222](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/222)). ([3f042ca0](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/3f042ca0f5d416dbdaf66add320744083d0296b2))
 - **FIX**: Sort chronologically or by weight class ([#222](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/222)). ([780280e8](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/780280e826679779b13c37476637ad5a0cf006e8))
 - **FIX**: Avoid calling timers onEnd twice ([#222](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/222)). ([566cf8fd](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/566cf8fdb61f412d2adcfc112b43aac83375df2a))
 - **FEAT**: Save import metadata in database. ([525b50bd](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/525b50bd83d00b601201767f5b35be608b8d446f))
 - **FEAT**: Order by properties on server (closes [#195](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/195)). ([dd289936](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/dd2899364fe4c19f767f10d5913e5681a248610c))
 - **FEAT**: Live activity and injury times (closes [#41](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/41)). ([a270c328](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/a270c3286a6a4dd7d50b3b2be1ef64af5038f47d))
 - **FEAT**: Support visitors count and end date ([#222](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/222)). ([e6db6fd2](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/e6db6fd25fcb6735383198e226905717279fb482))
 - **FEAT**: Automatic bout actions (closes [#91](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/91), closes [#43](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/43)). ([7779c729](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/7779c72927622222e1ea6fe8b23c3a50ff0cd213))
 - **FEAT**: Support comments in bout ([#1](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/1)). ([a81fc79b](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/a81fc79bc8a2400109687e71e61293cc3db4ad4b))

## 0.3.5+1

 - **REFACTOR**: Move wrestling API to server package. ([9e6e7a7c](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/9e6e7a7c70276fd3c970027a5ddeca893594ac47))
 - **FIX**: Use existing person for referee if available. ([918d0a4a](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/918d0a4a62806a63db318e08fd53b7b2549a51e9))
 - **FIX**: Also consider league weight classes on import. ([3d9f7f8e](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/3d9f7f8ed1f7f345870551efb0fd133724635f4a))
 - **FIX**: Use first club of team as fallback when clubId was not found on import. ([afc5f168](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/afc5f168ec01cd61ed185635adb9d89ded138070))
 - **FIX**: Stop stopwatch at precisely the limit (closes [#201](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/201)). ([6a29f87c](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/6a29f87c0b7c47cca6df0767c4a6a780365e6e63))

## 0.3.5

 - **FIX**: Avoid updating stop watch after being disposed. ([83647e15](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/83647e151be5e1a749407fab5fa6a299d0c45982))
 - **FEAT**: Show deci second in bout display. ([d474e195](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/d474e19556aeae9ab9db7660233c894d097bfcd8))

## 0.3.3+1

 - **FIX**: Parse lowercase role of BoutAction on API import (closes [#208](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/208)). ([ff99b217](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/ff99b217bed2dc78a09f82dbc7567dce308fe1c3))

## 0.3.3

 - **FIX**: Update bout rules to allow winning on tie (closes [#202](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/202)). ([82330453](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/82330453b1b6393a0e76643d12a6f627b7d8ebc9))
 - **FIX**: Disallow duplicate team lineup participations (closes [#196](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/196)). ([3ec26522](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/3ec2652271d6b92d342996c725acab9edf2068ba))
 - **FIX**: Restrict User creation parameters. ([f1893b65](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/f1893b651a0dc9c156dab41514c56224bf3a5dc8))
 - **FEAT**: Separate data migration from table migration (closes [#188](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/188)). ([ccf923a3](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/ccf923a315bf16063636780757d9f63c58b82247))
 - **FEAT**: Separate Official Persons from event / bout (closes [#169](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/169), closes [#181](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/181)). ([7352a3b5](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/7352a3b5fc65ee098b430de087cbbf6a0ebbc5c8))

## 0.3.2

 - **FEAT**: Check API provider credentials on save (closes [#166](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/166)). ([5e3d5442](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/5e3d544205d701c4606a68ddcb4aa0c4f6b7b602))
 - **FEAT**: Improve data object search capabilities (closes [#165](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/165)). ([397bf9a5](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/397bf9a55f0b7a3112d5e6541fad811d3cc27090))

## 0.3.1

 - **REFACTOR**: Adapt analysis_options (closes [#85](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/85)). ([09f7f25a](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/09f7f25abad009716a604888d2a7b106ce4238a8))
 - **FIX**: Apply analysis options. ([890ac5f2](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/890ac5f2680bfd41dfd492a926d6b41ff813036e))
 - **FIX**: Allow changing wrestling style of BoutResultRule. ([51c847c6](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/51c847c6bed272219d48da9f7df0df9424389106))
 - **FEAT**: Support Local backups for admins ([#37](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/37)). ([24ad9d8d](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/24ad9d8da312adf02f8281145f2b53f4a374c714))
 - **FEAT**: Write client logs into file (closes [#143](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/143)). ([a97b025f](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/a97b025f31a2a99e8b593641f776c09f8ce348e0))
 - **FEAT**: Scratch Bout Screen (closes [#142](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/142)). ([486a53ad](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/486a53ad369976db789f749463af6dbb3f3d6422))
 - **FEAT**: Export tournament as RDB report ([#1](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/1)). ([3a7e8ccd](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/3a7e8ccdde1231b75bef2003762e9ad1229babcc))
 - **FEAT**: Cycle Management ([#35](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/35)). ([0d17e25e](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/0d17e25e8b83674d2b33291b0e57fa7c0779ede4))

## 0.3.0

 - **REFACTOR**: Remove custom name getter from enums. ([ba65777e](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/ba65777ed8d28b57ecbabcf7716bed2132623fa3))
 - **REFACTOR**: Dart format. ([eae2062b](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/eae2062bb48610de6cb9fc70b53a42561d23aadf))
 - **REFACTOR**: Apply dart format. ([eefaec04](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/eefaec04c236a79eba6310204665c953851b1e9b))
 - **FIX**: Disallow assigning CompetitionBout to mat, if already occupied. ([e85e6ade](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/e85e6ade299e387dd5c338b5d4ef3da98a8fa6d6))
 - **FIX**: Competition flaws ([#129](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/129)). ([b4c89201](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/b4c8920127f639f517669d9dd4cd6b7781e172d0))
 - **FIX**: Always send auth header when using germany BY api. ([48f0f74a](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/48f0f74a8296b22f300934c8c2eecac8c4a80435))
 - **FIX**: Round event time values to unit. ([4eb4e6b5](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/4eb4e6b5820a9c3b159f870fd4c1260d955ff0b1))
 - **FIX**: Import leg foul (L) as caution. ([2b77167d](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/2b77167db0ec039a5d15be16507f9c09d6de78ae))
 - **FIX**: Disallow adding existing membership of API ([#74](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/74)). ([cd01fdad](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/cd01fdad6f730d1c4e52c9faf26921266204de11))
 - **FIX**: Order of team weight classes and bouts with multiple sections. ([16399ae6](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/16399ae6b6688da157a07c515dcea9ae27075482))
 - **FIX**: Replace singleOrNull with zeroOrOne. ([5d1ba644](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/5d1ba644719d51ce92d5efed2c097aa86fb5b139))
 - **FEAT**: Ranking for pools and finals. ([fbf9c6e8](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/fbf9c6e86815c91455b960186ec5e7e00e6f7e3e))
 - **FEAT**: Introduce ByeDoubleElimination ([#133](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/133)). ([4e07920c](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/4e07920c1ac5d3827d0f4156f402d0d92b1c8d34))
 - **FEAT**: Introduce nordicDoubleElimination CompetitionSystem. ([750c8e3e](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/750c8e3e4c9b99cffd0f3a1ca990d2a1d7bf9422))
 - **FEAT**: Add competitionSystem to CompetitionWeightCategory, generation of pool rounds. ([56a53940](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/56a539409195ad65f92d1f4913ae32c73264966d))
 - **FEAT**: Support Competitions ([#35](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/35)). ([54435ff7](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/54435ff798098a0442b522026b13bff26aa55f4c))
 - **FEAT**: Improve display of score sheet. ([562f9d8a](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/562f9d8a89dae2144c75568b75d93efecf60370a))
 - **FEAT**: Upgrade to Flutter 3.29.0, freezed, riverpod. ([d6492324](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/d6492324bc8c1bd3279f5122aff4dba5e6205f8b))
 - **FEAT**: Support Flutter 3.27.x. ([c63dcae3](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/c63dcae3673313a7917a76c4260a52581f940d75))
 - **FEAT**: Filterable Entity Lists (closes [#95](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/95)). ([f16e91e7](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/f16e91e782ff39da06590c57549a2b5773adcb4e))
 - **FEAT**: Reflect all states from UWW score sheet (closes [#19](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/19)). ([57ea75f4](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/57ea75f4f16c3217e7b6e640380c4721b5485cbe))
 - **FEAT**: Disable impossible bout results (closes [#97](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/97)). ([bc6a955d](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/bc6a955d1c1dad30200db2315e70646bf8f165d4))
 - **FEAT**: Min Client version (closes [#68](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/68)). ([5b941242](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/5b9412421273efb9bbefa233fae4ed9497e7a8c5))
 - **FEAT**: Support Weight Class per League (closes [#82](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/82)). ([0bfa485f](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/0bfa485fb98679c527fa4d4edfa44d30c26b8166))
 - **FEAT**: Prioritize scheme for seasonPartition in TeamMatch. ([3dd834f7](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/3dd834f7e0e15d954e89a6667a6b01a0d38bcfb8))

## 0.1.1

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

## 0.1.0

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

## 0.0.1-beta.12

 - **FEAT**: BRV bout scheme integration. ([51297973](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/51297973a0fafcfe73a7982c3ae8c551ec30105b))

## 0.0.1-beta.11

 - **FIX**: Searchable dropdown filters. ([edfd27cf](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/edfd27cfb4ec6882568cc4baabb3a4e9d4883b8d))

## 0.0.1-beta.10

 - **REFACTOR**: Replace switch case with expression. ([2c1ac540](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/2c1ac5407fb433bb6b331e965952df013be86f9f))
 - **FIX**: Live organization import. ([e5d12c06](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/e5d12c065b379dde396ce727175ae69341212f8e))
 - **FIX**: Make BasicAuthService nullable. ([3c771214](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/3c77121451bab9240ffe9a1fb318788175a94cf3))

## 0.0.1-beta.9

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

## 0.0.1-beta.8

> Note: This release has breaking changes.

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

## 0.0.1-alpha.0

- Initial version.
