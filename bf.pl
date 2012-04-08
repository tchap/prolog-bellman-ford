%%%
%%% Bellman-Ford algorithm
%%%

%% Graph supplementary rules

% g_vertices(+Gid, -Vertices)
g_vertices(Gid, Vertices) :-
	g(Gid, Vertices, _).

% g_vertex(+Gid, ?Vertex)
g_vertex(Gid, Vertex) :-
	member(Vertex, g_vertices(Gid)).

%% Bellman-Ford

bf_set_shortest(Gid, From, To, Cost) :-
	bf_shortest(Gid, _, To, _),
	retract(bf_shortest(Gid, _, To, _)),
	asserta(bf_shortest(Gid, From, To, Cost)),
	!.
bf_set_shortest(Gid, From, To, Cost) :-
	asserta(bf_shortest(Gid, From, To, Cost)).

% bf_get_shortest(+Gid, ?From, ?To, ?Cost)
bf_get_shortest(Gid, From, To, Cost) :-
	bf_shortest(Gid, From, To, Cost).

% bf(+Gid, +Start, +Stop, -Cost, -Path)
bf(Gid, Start, Stop, Cost, Path) :-
	g_vertex(Gid, Start),
	g_vertex(Gid, Stop),
	bf_set_shortest(Gid, nill, Start, 0),
	bf_loop(Gid, length(g_vertices(Gid))),
	bf_assemble_path(Start, Stop, Cost, Path).

bf_loop(Gid, M) :-
	bf_loop(Gid, M, true).

bf_loop(Gid, 0, _) :- !.
bf_loop(Gid, _, false) :- !.
bf_loop(Gid, M, _) :-
	Mnext is M - 1,
	bf_explore(Gid, Modified),
	bf_loop(Gid, Mnext, Modified).

bf_explore(Gid, Modified) :-
	vertices(Gid, Vertices),
	bf_explore(Gid, Vertices, false, Modified).

bf_explore(_, [], Modified, Modified).
bf_explore(Gid, [V|Rest], false, ModifiedReturn) :-
	bf_update(Gid, V, Modified),
	bf_explore(Gid, Rest, Modified, ModifiedReturn).
bf_explore(Gid, [V|Rest], true, ModifiedReturn) :-
	bf_update(Gid, V, _),
	bf_explore(Gid, Rest, true, ModifiedReturn).

bf_update(Gid, Vertex, Modified) :-

