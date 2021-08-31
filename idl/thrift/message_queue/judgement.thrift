namespace * astraea.thrift.mq

enum JudgementType {
  CE,
  AC,
  TLE,
  RTE,
  WA,
  NONE,
}

const map<JudgementType, string> JudgementName = {
  JudgementType.CE: "Compile Error",
  JudgementType.AC: "Accepted",
  JudgementType.TLE: "Time Limit Exceeded",
  JudgementType.RTE: "Run-Time Error",
  JudgementType.WA: "Wrong Answer",
  JudgementType.NONE: "",
}

struct JudgementInfo {
  1: required string id,
  2: required string problem,
  3: required string language,
  4: required string code,
  9: required JudgementType judgement_type,
  10: optional string message,
  12: optional string script_last_update,
}
