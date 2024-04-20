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
