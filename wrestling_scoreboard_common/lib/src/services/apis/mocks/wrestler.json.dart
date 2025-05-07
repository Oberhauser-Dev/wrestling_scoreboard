String? getWrestlerJson(passCode) => switch (passCode) {
  1234 => r'''
{
  "rpcid": null,
  "rc": "ok",
  "api": {
    "rdb": "3.0.8 \\\/ 3.0.9",
    "jrcs": "1.0.3"
  },
  "passcode": "1234",
  "nationCode": "GER",
  "authCode": "BRV",
  "wrestler": {
    "name": "Muster",
    "givenname": "Max",
    "gender": "m",
    "birthday": "2000-01-31",
    "licenceCode": null,
    "authRating": null,
    "clubCode": null,
    "nationality": "Deutschland",
    "passCode": null,
    "nationCode": null,
    "authCode": null,
    "id": "rdb.1234",
    "active": "0",
    "persId": "5678",
    "licId": "0",
    "status": "",
    "clubId": "20696",
    "birthplace": "München"
  }
}
''',
  4321 => r'''
{
  "rpcid": null,
  "rc": "ok",
  "api": {
    "rdb": "3.0.8 \\/ 3.0.9",
    "jrcs": "1.0.3"
  },
  "year": null,
  "sid": null,
  "passcode": "4321",
  "nationCode": "GER",
  "authCode": "BRV",
  "wrestler": {
    "name": "Müller",
    "givenname": "Tobias",
    "gender": "m",
    "birthday": "2000-03-02",
    "licenceCode": null,
    "authRating": null,
    "clubCode": null,
    "nationality": "Deutschland",
    "passCode": null,
    "nationCode": null,
    "authCode": null,
    "id": "rdb.4321",
    "active": "0",
    "persId": "8765",
    "licId": "4321",
    "status": "",
    "clubId": "10142",
    "birthplace": "Berchtesgaden"
  }
}
''',
  _ => null,
};
