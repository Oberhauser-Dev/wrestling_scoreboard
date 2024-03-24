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
