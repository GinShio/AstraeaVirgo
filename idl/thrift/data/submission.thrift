namespace * astraea.thrift.data

struct Submission {
  1: required string id,
  2: required string problem,
  3: required string language,
  4: required string submitter,
  5: required string code,
  14: required string judgement,
  15: optional string message,
}
