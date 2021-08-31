%%
%% Autogenerated by Thrift Compiler (0.14.1)
%%
%% DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
%%

-module(problem_types).

-include("problem_types.hrl").

-export([struct_info/1, struct_info_ext/1, enum_info/1, enum_names/0, struct_names/0, exception_names/0]).

struct_info('astraea.thrift.data.Problem') ->
  {struct, [{1, string},
          {2, string},
          {3, i32},
          {4, bool},
          {5, string},
          {6, string},
          {7, i32},
          {8, i32},
          {9, string},
          {10, string},
          {11, string},
          {12, {list, string}},
          {13, i32},
          {14, i32},
          {15, i32}]}
;

struct_info(_) -> erlang:error(function_clause).

struct_info_ext('astraea.thrift.data.Problem') ->
  {struct, [{1, required, string, 'id', undefined},
          {2, required, string, 'name', undefined},
          {3, required, i32, 'ordinal', undefined},
          {4, required, bool, 'is_public', undefined},
          {5, required, string, 'detail', undefined},
          {6, required, string, 'mime', undefined},
          {7, required, i32, 'time', undefined},
          {8, required, i32, 'memory', undefined},
          {9, optional, string, 'label', ""},
          {10, optional, string, 'rgb', "#000000"},
          {11, optional, string, 'category', ""},
          {12, optional, {list, string}, 'tag', []},
          {13, optional, i32, 'total', 0},
          {14, optional, i32, 'ac', 0},
          {15, optional, i32, 'testcase', 0}]}
;

struct_info_ext(_) -> erlang:error(function_clause).

struct_names() ->
  ['astraea.thrift.data.Problem'].

enum_info(_) -> erlang:error(function_clause).

enum_names() ->
  [].

exception_names() ->
  [].

