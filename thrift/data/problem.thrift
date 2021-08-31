namespace * astraea.thrift.data

struct Problem {
  1: required string id,
  2: required string name,
  3: required i32 ordinal,
  4: required bool is_public,
  5: required string detail,
  6: required string mime,
  7: required i32 time,
  8: required i32 memory,
  9: optional string label = "",
  10: optional string rgb = "#000000",
  11: optional string category = "",
  12: optional list<string> tag = [],
  13: optional i32 total = 0,
  14: optional i32 ac = 0,
  15: optional i32 testcase = 0,
}
