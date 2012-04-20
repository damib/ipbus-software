%%% ===========================================================================
%%% @author Robert Frazier
%%%
%%% @since April 2012
%%%
%%% @doc Test-code for the API of the ch_stats module.
%%% @end
%%% ===========================================================================

-module(ch_stats_tests).

-include("ch_global.hrl").

%% API exports
-export([]).


%%% ===========================================================================
%%% Test Fixtures
%%% 
%%% The test fixtures, including the lists of tests to be run, and the
%%% setup and teardown functions used by the fixtures.
%%% ===========================================================================

%% Test fixture 
ch_stats_test_() ->
    { setup,
      fun setup/0,
      fun teardown/1,
      { inparallel,  % run the tests below concurrently, JUST BECAUSE I CAN! (and it's prob a bit quicker)
        [ fun test_client_connections/0,
          fun test_client_request_in/0,
          fun test_client_request_malformed/0,
          fun test_client_response_sent/0,
          fun test_udp_in/0,
          fun test_udp_malformed/0,
          fun test_udp_out/0,
          fun test_udp_response_timeout/0
        ]
      }
    }.

%% Setup function for test fixture - starts up the ch_stats server
%% @spec setup() -> ok
setup() ->
    ch_stats:start_link(),
    ok.

%% Teardown function for test fixture
teardown(_Ignore) -> ch_stats:stop().



%%% ===========================================================================
%%% Individual Test Functions.
%%% ===========================================================================

test_client_connections() ->
    ?assertEqual(0, ch_stats:get_active_clients()),
    n_call(7, fun ch_stats:client_connected/0),
    ?assertEqual(7, ch_stats:get_active_clients()),
    n_call(5, fun ch_stats:client_disconnected/0),
    ?assertEqual(2, ch_stats:get_active_clients()),
    ?assertEqual(7, ch_stats:get_max_active_clients()).

test_client_request_in() ->
    ?assertEqual(0, ch_stats:get_total_client_requests()),
    n_call(11, fun ch_stats:client_request_in/0),
    ?assertEqual(11, ch_stats:get_total_client_requests()).

test_client_request_malformed() ->
    ?assertEqual(0, ch_stats:get_total_client_malformed_requests()),
    n_call(13, fun ch_stats:client_request_malformed/0),
    ?assertEqual(13, ch_stats:get_total_client_malformed_requests()).

test_client_response_sent() ->
    ?assertEqual(0, ch_stats:get_total_client_responses()),
    n_call(17, fun ch_stats:client_response_sent/0),
    ?assertEqual(17, ch_stats:get_total_client_responses()).

test_udp_in() ->
    ?assertEqual(0, ch_stats:get_udp_in()),
    n_call(19, fun ch_stats:udp_in/0),
    ?assertEqual(19, ch_stats:get_udp_in()).

test_udp_malformed() ->
    ?assertEqual(0, ch_stats:get_udp_malformed()),
    n_call(23, fun ch_stats:udp_malformed/0),
    ?assertEqual(23, ch_stats:get_udp_malformed()).

test_udp_out() ->
    ?assertEqual(0, ch_stats:get_udp_out()),
    n_call(29, fun ch_stats:udp_out/0),
    ?assertEqual(29, ch_stats:get_udp_out()).

test_udp_response_timeout() ->
    ?assertEqual(0, ch_stats:get_udp_response_timeouts()),
    n_call(31, fun ch_stats:udp_response_timeout/0),
    ?assertEqual(31, ch_stats:get_udp_response_timeouts()).


%%% ==========================================================================
%%% Test Helper Functions
%%% ==========================================================================

%% Call some function N times.
n_call(N, Fun) -> n_call(0, N, Fun).

%% Implements n_call/2
n_call(_N, _N, _Fun) -> ok;

n_call(X, N, Fun) ->
    Fun(),
    n_call(X+1, N, Fun).