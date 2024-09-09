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
