-module(kv).

-export([start_link/0, init/1]).

start_link() ->
    proc_lib:start_link(?MODULE, init, [self()]).

init(Parent) ->
    proc_lib:init_ack(Parent, {ok, self()}),
    loop(10).

loop(Counter) ->
    receive
        _Any -> loop(Counter)
    end.

