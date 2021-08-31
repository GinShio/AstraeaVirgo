namespace * astraea.thrift.data

struct Language {
  1: required string id,
  2: required string name,
  3: required list<string> extensions,
  5: optional double time_multiplier = 1.0,
  6: optional double mem_multiplier = 1.0,
  10: optional string compile_script,
  11: optional string run_script,
  12: optional string script_last_update,
}
