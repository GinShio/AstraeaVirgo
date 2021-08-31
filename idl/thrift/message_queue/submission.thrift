namespace * astraea.thrift.mq

struct ProblemLimit {
  1: i32 compilation_time = 60000, // ms
  2: required i32 time, // ms
  3: double time_multiplier = 1.0,
  5: i32 compilation_memory = 1048576, // kiB
  6: required i32 memory, // kiB
  7: double mem_multiplier = 1.0,
  9: i32 compilation_output = 8192, // kiB
  10: i32 output = 256, // kiB
}

struct SubmissinoInfo {
  1: required string id,
  2: required string problem,
  3: required string language,
  4: required list<string> extensions,
  5: required string code,
  8: required ProblemLimit limits,
  11: optional string problem_testcase_last_update,
  12: optional string script_last_update,
}
