%%
%% Autogenerated by Thrift Compiler (0.14.1)
%%
%% DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
%%

-module(submission_types).

-include("submission_types.hrl").

-export([struct_info/1, struct_info_ext/1, enum_info/1, enum_names/0, struct_names/0, exception_names/0]).

struct_info('astraea.thrift.data.Submission') ->
  {struct, [{1, string},
          {2, string},
          {3, string},
          {4, string},
          {5, string},
          {14, string},
          {15, string}]}
;

struct_info(_) -> erlang:error(function_clause).

struct_info_ext('astraea.thrift.data.Submission') ->
  {struct, [{1, required, string, 'id', undefined},
          {2, required, string, 'problem', undefined},
          {3, required, string, 'language', undefined},
          {4, required, string, 'submitter', undefined},
          {5, required, string, 'code', undefined},
          {14, required, string, 'judgement', undefined},
          {15, optional, string, 'message', undefined}]}
;

struct_info_ext(_) -> erlang:error(function_clause).

struct_names() ->
  ['astraea.thrift.data.Submission'].

enum_info(_) -> erlang:error(function_clause).

enum_names() ->
  [].

exception_names() ->
  [].
