-module(events_handler).
-behavior(lasse_handler).

-export([
         init/3,
         handle_notify/2,
         handle_info/2,
         handle_error/3,
         terminate/3
        ]).

init(_InitArgs, LastEventId, Req) ->
    % Take process name from the "process-name" header.
    case cowboy_req:header(<<"process-name">>, Req) of
        {ProcNameBin, Req} ->
            ProcName = binary_to_term(ProcNameBin),
            register(ProcName, self()),
            lager:info("Initiating a ~p in ~p", [ProcName, whereis(ProcName)]);
        {undefined, Req}  ->
            lager:info("Initiating handler"),
            ok
    end,

    {ok, Req, LastEventId}.

handle_notify(send, State) ->
    {send, [{data, <<"notify chunk">>}], State};
handle_notify(send_id, State) ->
    Event = [
             {id, <<"1">>},
             {data, <<"notify chunk">>},
             {name, ""}
            ],
    {send, Event, State};
handle_notify(no_data, State) ->
    Event = [
             {id, <<"1">>},
             {name, "no_data"}
            ],
    {send, Event, State};
handle_notify(nosend, State) ->
    {nosend, State};
handle_notify(comments, State) ->
    Event = [
             {comments, <<"Comment 1\nComment 2">>},
             {data, <<"some data">>}
            ],
    {send, Event, State};
handle_notify(last_event_id, State) ->
    Event = [{data, State}],
    {send, Event, State};
handle_notify(stop, State) ->
    {stop, State}.

handle_info(send, State) ->
    {send, [{data, <<"info chunk">>}], State};
handle_info(nosend, State) ->
    {nosend, State};
handle_info(stop, State) ->
    {stop, State}.

handle_error(_Msg, _Reason, State) ->
    State.

terminate(_Reason, _Req, _State) ->
    ok.
