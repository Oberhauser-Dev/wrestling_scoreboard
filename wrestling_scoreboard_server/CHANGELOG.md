## 0.3.3

 - **REFACTOR**: Remove `bout_result:vsu1,vpo1,dsq2` and `person_role:matPresident` from default database ([#116](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/116)). ([5daeaf1b](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/5daeaf1beeea72e5da55ee26ceace59cd0bb8eb1))
 - **REFACTOR**: Squash migration scripts <= v0.2.x ([#116](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/116)). ([ee497c01](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/ee497c01afbd1de50fc70b17e8f45e02c913b741))
 - **FIX**: Update bout rules to allow winning on tie (closes [#202](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/202)). ([82330453](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/82330453b1b6393a0e76643d12a6f627b7d8ebc9))
 - **FIX**: Disallow duplicate team lineup participations (closes [#196](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/196)). ([3ec26522](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/3ec2652271d6b92d342996c725acab9edf2068ba))
 - **FIX**: Improved websocket connection handling. ([d8ab9e8b](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/d8ab9e8ba2881483624d2a9a98050319fa44cebb))
 - **FIX**: Compatibility with PostgreSQL vulnerability fix. ([0c7e966a](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/0c7e966a26545573b3423c45c95fcd0398466545))
 - **FIX**: Restrict User creation parameters. ([f1893b65](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/f1893b651a0dc9c156dab41514c56224bf3a5dc8))
 - **FEAT**: Improved Logging for severe errors. ([69cf3c0c](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/69cf3c0c807ea4abb6257a2157232721b62e7036))
 - **FEAT**: Increase database connection timeout while debugging. ([1cbd34ec](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/1cbd34ec86a279fc8e62da410d522c88427ec5c9))
 - **FEAT**: Make creating many entities more performant. ([778c22fd](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/778c22fd41d7c4a032525047deb3fa326a117a31))
 - **FEAT**: Always order entities by id. ([f83819ff](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/f83819ffc1c20caafe6fe57da64fd20cfd4dd17e))
 - **FEAT**: Option to delete via Rest API. ([a6359b7b](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/a6359b7b215ad1c32bd18e29b3d30eb3162e1803))
 - **FEAT**: Separate data migration from table migration (closes [#188](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/188)). ([ccf923a3](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/ccf923a315bf16063636780757d9f63c58b82247))
 - **FEAT**: Link all entity properties (closes [#94](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/94)). ([e1c4b5b2](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/e1c4b5b25c354d9953c513f760368d502464aeb5))
 - **FEAT**: Show bouts of membership for competitions. ([ee96fd71](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/ee96fd71aa3ece4730ca6c1b9f59ef1f28e0f68b))
 - **FEAT**: Separate Official Persons from event / bout (closes [#169](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/169), closes [#181](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/181)). ([7352a3b5](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/7352a3b5fc65ee098b430de087cbbf6a0ebbc5c8))
 - **FEAT**: Link (Add) existing objects (Memberships, TeamClubAffiliations). ([8194ce15](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/8194ce157e3a7b4ff7da7d86346369bfe4195551))
 - **FEAT**: Rework broadcast privileges. ([911c02a5](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/911c02a5b253decd99ce199b0f9d32bd837a58f5))
 - **FEAT**: Upgrade to Flutter 3.35.x. ([fbc5cb21](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/fbc5cb213153dbba6dbeb39e78d2556e024ea780))
 - **DOCS**: State default admin user and password (closes [#183](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/183)). ([b866f9e7](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/b866f9e755e1d03c7985c62ca9494f1cce016372))

## 0.3.2

 - **FEAT**: Option to reorder the preferred Persons before merging (closes [#162](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/162)). ([e2aba5c5](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/e2aba5c5acb8e6dcce5aac5d011edabded06bc0e))
 - **FEAT**: Check API provider credentials on save (closes [#166](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/166)). ([5e3d5442](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/5e3d544205d701c4606a68ddcb4aa0c4f6b7b602))
 - **FEAT**: Improve data object search capabilities (closes [#165](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/165)). ([397bf9a5](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/397bf9a55f0b7a3112d5e6541fad811d3cc27090))
 - **FEAT**: List leagues of team in Team Overview (closes [#151](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/151)). ([345472e0](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/345472e095f75de1c76e2d94a60181bf500e7c23))

## 0.3.1

 - **REFACTOR**: Adapt analysis_options (closes [#85](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/85)). ([09f7f25a](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/09f7f25abad009716a604888d2a7b106ce4238a8))
 - **FIX**: Generating bouts for team matches. ([53a5b018](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/53a5b0188e1ae4b964b83bbacf52e1564a277f1f))
 - **FIX**: Merging persons ([#145](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/145)). ([2b48b7ae](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/2b48b7ae91386013a67e0e2f6472604358eb9561))
 - **FIX**: Apply analysis options. ([890ac5f2](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/890ac5f2680bfd41dfd492a926d6b41ff813036e))
 - **FIX**: Migration of Competition Weight Category. ([74bc422e](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/74bc422ec1703a0442990fba58c0cfa7c4bbdc2a))
 - **FIX**: Allow changing wrestling style of BoutResultRule. ([51c847c6](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/51c847c6bed272219d48da9f7df0df9424389106))
 - **FEAT**: Write client logs into file (closes [#143](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/143)). ([a97b025f](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/a97b025f31a2a99e8b593641f776c09f8ce348e0))
 - **FEAT**: Improve server logs and response handling. ([ec1ad7af](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/ec1ad7afa7c210115b66e05d22c62ad3db82295f))
 - **FEAT**: Scratch Bout Screen (closes [#142](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/142)). ([486a53ad](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/486a53ad369976db789f749463af6dbb3f3d6422))
 - **FEAT**: Only can select team of current league (closes [#14](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/14)). ([582e0a4e](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/582e0a4e2ba8f61e63e5e0cb0b33d705acbcb2f1))
 - **FEAT**: Cycle Management ([#35](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/35)). ([0d17e25e](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/0d17e25e8b83674d2b33291b0e57fa7c0779ede4))

## 0.3.0

 - **REFACTOR**: Apply dart format. ([eefaec04](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/eefaec04c236a79eba6310204665c953851b1e9b))
 - **FIX**: Disallow assigning CompetitionBout to mat, if already occupied. ([e85e6ade](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/e85e6ade299e387dd5c338b5d4ef3da98a8fa6d6))
 - **FIX**: Competition flaws ([#129](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/129)). ([b4c89201](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/b4c8920127f639f517669d9dd4cd6b7781e172d0))
 - **FIX**: Apply MockableDateTime. ([6e12b22f](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/6e12b22f1ba98a7ea3819e7a9f17c7acf6d3d429))
 - **FIX**: Obfuscate org_sync_id (closes [#118](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/118)). ([c4d33dc5](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/c4d33dc5cdc6855635b292252a25b20af2116740))
 - **FIX**: Avoid duplicate participations. ([9cee0b36](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/9cee0b36965bd4002857b23d7e7f6d01d9fde790))
 - **FIX**: Migrate database after restore. ([bfa8fa54](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/bfa8fa54e63c5292e9853b83e724250e324f06a8))
 - **FIX**: Order of team weight classes and bouts with multiple sections. ([16399ae6](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/16399ae6b6688da157a07c515dcea9ae27075482))
 - **FIX**: Replace singleOrNull with zeroOrOne. ([5d1ba644](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/5d1ba644719d51ce92d5efed2c097aa86fb5b139))
 - **FIX**: Lineup: Avoid adding participation twice, add foreign team key. ([b6453ec1](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/b6453ec11273c7a9b162ed74d5174d29a2dfe9b3))
 - **FEAT**: Ranking for pools and finals. ([fbf9c6e8](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/fbf9c6e86815c91455b960186ec5e7e00e6f7e3e))
 - **FEAT**: Introduce ByeDoubleElimination ([#133](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/133)). ([4e07920c](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/4e07920c1ac5d3827d0f4156f402d0d92b1c8d34))
 - **FEAT**: Introduce nordicDoubleElimination CompetitionSystem. ([750c8e3e](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/750c8e3e4c9b99cffd0f3a1ca990d2a1d7bf9422))
 - **FEAT**: Add competitionSystem to CompetitionWeightCategory, generation of pool rounds. ([56a53940](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/56a539409195ad65f92d1f4913ae32c73264966d))
 - **FEAT**: Support Competitions ([#35](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/35)). ([54435ff7](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/54435ff798098a0442b522026b13bff26aa55f4c))
 - **FEAT**: Upgrade to Flutter 3.29.0, freezed, riverpod. ([d6492324](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/d6492324bc8c1bd3279f5122aff4dba5e6205f8b))
 - **FEAT**: Support Flutter 3.27.x. ([c63dcae3](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/c63dcae3673313a7917a76c4260a52581f940d75))
 - **FEAT**: Filterable Entity Lists (closes [#95](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/95)). ([f16e91e7](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/f16e91e782ff39da06590c57549a2b5773adcb4e))
 - **FEAT**: Improve Merge Person Dialog. ([c1de3183](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/c1de318374f13cfad59edf26ac4fc4dedab47418))
 - **FEAT**: Merge person objects. ([da86f970](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/da86f9702450abce4f4d39eb86be41c4fea90779))
 - **FEAT**: Persons of Organization. ([58cc7947](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/58cc79471c5e408607add97f7287c5686e9a3539))
 - **FEAT**: Reflect all states from UWW score sheet (closes [#19](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/19)). ([57ea75f4](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/57ea75f4f16c3217e7b6e640380c4721b5485cbe))
 - **FEAT**: Min Client version (closes [#68](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/68)). ([5b941242](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/5b9412421273efb9bbefa233fae4ed9497e7a8c5))
 - **FEAT**: Support Weight Class per League (closes [#82](https://github.com/Oberhauser-dev/wrestling_scoreboard/issues/82)). ([0bfa485f](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/0bfa485fb98679c527fa4d4edfa44d30c26b8166))
 - **FEAT**: Prioritize scheme for seasonPartition in TeamMatch. ([3dd834f7](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/3dd834f7e0e15d954e89a6667a6b01a0d38bcfb8))
 - **DOCS**: Increase client max body size in nginx. ([ad84c440](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/ad84c440c90d456b0d197e29c7105efb51bd91e5))

## 0.1.1

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

## 0.1.0

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

## 0.0.1-beta.12

 - **FEAT**: BRV bout scheme integration. ([51297973](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/51297973a0fafcfe73a7982c3ae8c551ec30105b))

## 0.0.1-beta.11

 - Update a dependency to the latest release.

## 0.0.1-beta.10

 - **FIX**: Live organization import. ([e5d12c06](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/e5d12c065b379dde396ce727175ae69341212f8e))
 - **FEAT**(server): Order team matches by date. ([8743d117](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/8743d117a153d881b5be085242752cb398a52186))
 - **FEAT**: Add organization info when editing. ([25ea14be](https://github.com/Oberhauser-dev/wrestling_scoreboard/commit/25ea14be3afe92b32e281727b9762b47b2fabc5d))

## 0.0.1-beta.9

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

## 0.0.1-beta.8

> Note: This release has breaking changes.

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

## 0.0.1-alpha.0

- Initial version.
