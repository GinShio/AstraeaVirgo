%%
%% Autogenerated by Thrift Compiler (0.14.1)
%%
%% DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
%%

-module(judgement_types).

-include("judgement_types.hrl").

-export([struct_info/1, struct_info_ext/1, enum_info/1, enum_names/0, struct_names/0, exception_names/0]).

struct_info('astraea.thrift.mq.JudgementInfo') ->
  {struct, [{1, string},
          {2, string},
          {3, string},
          {4, string},
          {9, i32},
          {10, string},
          {12, string}]}
;

struct_info(_) -> erlang:error(function_clause).

struct_info_ext('astraea.thrift.mq.JudgementInfo') ->
  {struct, [{1, required, string, 'id', undefined},
          {2, required, string, 'problem', undefined},
          {3, required, string, 'language', undefined},
          {4, required, string, 'code', undefined},
          {9, required, i32, 'judgement_type', undefined},
          {10, optional, string, 'message', undefined},
          {12, optional, string, 'script_last_update', undefined}]}
;

struct_info_ext(_) -> erlang:error(function_clause).

struct_names() ->
  ['astraea.thrift.mq.JudgementInfo'].

enum_info('JudgementType') ->
  [
    {'CE', 0},
    {'AC', 1},
    {'TLE', 2},
    {'RTE', 3},
    {'WA', 4},
    {'NONE', 5}
  ];

enum_info(_) -> erlang:error(function_clause).

enum_names() ->
  ['JudgementType'].

exception_names() ->
  [].
