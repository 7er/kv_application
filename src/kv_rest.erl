-module(kv_rest).

-export([init/2]).

init(Req, Opts) ->
    {cowboy_rest, Req, Opts}.

allowed_methods(Req, State) ->
    {[<<"GET">>, <<"PUT">>], Req, State}.

content_types_provided(Req, State) ->
    {[
      {{<<"application">>, <<"json">>, []}, kv_json}
     ], Req, State}.

content_types_accepted(Req, State) ->
    {[{{<<"application">>, <<"x-www-form-urlencoded">>, []}, create_or_update_kv}],
     Req, State}.

resource_exists(Req, _State) ->
    case cowboy_req:binding(key, Req) of
        undefined -> {true, Req, index};
        Key ->
            % lookup map here
            {true, Req, Key} % assume key exists


create_or_update_kv(Req, Key) ->
    {ok, [{<<"value">>, Value}], Req2} = cowboy_req:body_qs(Req),
    % write Key, Value to KvStore
    case cowboy_req:method(Req2) of
        <<"PUT">> ->
            {{true, <<"bla bla">>}, Req2, Key}; 
        _ ->
            {true, Req2, Key}
    end.
    

kv_json(Req, index) ->
    % loop through all key values and output them with json
    JsonBody = <<"[{\"flesk\": \"duppe\"}, {\"bacon\": \"sodd\"}">>,
    {JsonBody, Req, index};
kv_json(Req, Key) ->
    JsonBody = <<"{\"flesk\": \"duppe\"}">>,
    {JsonBody, Req, Key}.
