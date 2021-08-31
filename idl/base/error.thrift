namespace * astraea.thrift

enum ErrorType {
  DATABASE,
  CONNECTION,
}

exception Error {
  1: required ErrorType code,
  5: required string message,
}
