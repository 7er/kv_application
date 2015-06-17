%%%-------------------------------------------------------------------
%%% @author Syver Enstad <syver@syver-X555LA>
%%% @copyright (C) 2015, Syver Enstad
%%% @doc
%%%
%%% @end
%%% Created : 16 Jun 2015 by Syver Enstad <syver@syver-X555LA>
%%%-------------------------------------------------------------------
-module(kv_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%%===================================================================
%%% Application callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called whenever an application is started using
%% application:start/[1,2], and should start the processes of the
%% application. If the application is structured according to the OTP
%% design principles as a supervision tree, this means starting the
%% top supervisor of the tree.
%%
%% @spec start(StartType, StartArgs) -> {ok, Pid} |
%%                                      {ok, Pid, State} |
%%                                      {error, Reason}
%%      StartType = normal | {takeover, Node} | {failover, Node}
%%      StartArgs = term()
%% @end
%%--------------------------------------------------------------------
start(_StartType, _StartArgs) ->
    Port = 8080,
    ok = application:start(crypto),
    ok = application:start(ranch),
    ok = application:start(cowlib),
    ok = application:start(cowboy),
    AcceptorCount = 10,
    Dispatch = cowboy_router:compile(
                 [
                  %% {URIHost, list({UriPath, Handler, Opts}}}
                  {'_', [
                         {"/[:key]", kv_rest, []}]
                  }]),
    {ok, _} = cowboy:start_http(my_http_listener,
                      AcceptorCount,
                      [{port, Port}],
                                [{env, [{dispatch, Dispatch}]}]),
    kv_sup:start_link().

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called whenever an application has stopped. It
%% is intended to be the opposite of Module:start/2 and should do
%% any necessary cleaning up. The return value is ignored.
%%
%% @spec stop(State) -> void()
%% @end
%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%%===================================================================
%%% Internal functions
%%%===================================================================

    
