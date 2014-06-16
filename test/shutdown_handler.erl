-module(shutdown_handler).
-behavior(lasse_handler).

-export([
         init/2,
         handle_info/2,
         handle_notify/2
        ]).

init(_InitArgs, Req) ->
    Headers = [{<<"content-type">>, <<"text/html">>}],
    Body = <<"Sorry, shutdown!">>,
    {shutdown, 404, Headers, Body, Req}.

handle_info(Msg, State) ->
    {send, [{data, Msg}], State}.

handle_notify(Msg, State) ->
    {send, [{data, Msg}], State}.