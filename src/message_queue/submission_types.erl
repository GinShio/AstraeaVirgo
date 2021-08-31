%%
%% Autogenerated by Thrift Compiler (0.14.1)
%%
%% DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
%%

-module(submission_types).

-include("submission_types.hrl").

-export([struct_info/1, struct_info_ext/1, enum_info/1, enum_names/0, struct_names/0, exception_names/0]).

struct_info('astraea.thrift.mq.ProblemLimit') ->
  {struct, [{1, i32},
          {2, i32},
          {3, double},
          {5, i32},
          {6, i32},
          {7, double},
          {9, i32},
          {10, i32}]}
;

struct_info('astraea.thrift.mq.SubmissinoInfo') ->
  {struct, [{1, string},
          {2, string},
          {3, string},
          {4, {list, string}},
          {5, string},
          {8, {struct, {'submission_types', 'astraea.thrift.mq.ProblemLimit'}}},
          {11, string},
          {12, string}]}
;

struct_info(_) -> erlang:error(function_clause).

struct_info_ext('astraea.thrift.mq.ProblemLimit') ->
  {struct, [{1, undefined, i32, 'compilation_time', 60000},
          {2, required, i32, 'time', undefined},
          {3, undefined, double, 'time_multiplier', 1.0000000000000000},
          {5, undefined, i32, 'compilation_memory', 1048576},
          {6, required, i32, 'memory', undefined},
          {7, undefined, double, 'mem_multiplier', 1.0000000000000000},
          {9, undefined, i32, 'compilation_output', 8192},
          {10, undefined, i32, 'output', 256}]}
;

struct_info_ext('astraea.thrift.mq.SubmissinoInfo') ->
  {struct, [{1, required, string, 'id', undefined},
          {2, required, string, 'problem', undefined},
          {3, required, string, 'language', undefined},
          {4, required, {list, string}, 'extensions', []},
          {5, required, string, 'code', undefined},
          {8, required, {struct, {'submission_types', 'astraea.thrift.mq.ProblemLimit'}}, 'limits', #'astraea.thrift.mq.ProblemLimit'{}},
          {11, optional, string, 'problem_testcase_last_update', undefined},
          {12, optional, string, 'script_last_update', undefined}]}
;

struct_info_ext(_) -> erlang:error(function_clause).

struct_names() ->
  ['astraea.thrift.mq.ProblemLimit', 'astraea.thrift.mq.SubmissinoInfo'].

enum_info(_) -> erlang:error(function_clause).

enum_names() ->
  [].

exception_names() ->
  [].

