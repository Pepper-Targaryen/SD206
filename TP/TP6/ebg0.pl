/*---------------------------------------------------------------*/
/* Telecom Paristech - J-L. Dessalles 2019                       */
/* LOGIC AND KNOWLEDGE REPRESENTATION                            */
/*            http://teaching.dessalles.fr/LKR                   */
/*---------------------------------------------------------------*/


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% explanation_based generalization %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



/*-----------------------*/
/*  Background knowledge */
/*-----------------------*/
telephone(T) :- connected(T), partOf(T, D), dialingDevice(D), emitsSound(T).
connected(X) :- hasWire(X, W), attached(W, wall).
connected(X) :- feature(X, bluetooth).
connected(X) :- feature(X, wifi).
connected(X) :- partOf(X, A), antenna(A), hasProtocol(X, gsm).
dialingDevice(DD) :- rotaryDial(DD). 
dialingDevice(DD) :- frequencyDial(DD).
dialingDevice(DD) :- touchScreen(DD), hasSoftware(DD, DS), dialingSoftware(DS).
emitsSound(P) :-    hasHP(P).
emitsSound(P) :-    feature(P, bluetooth).

/*---------*/
/* Example */
/*---------*/
example(myphone, Features) :-
    Features = [silver(myphone), belongs(myphone, jld), partOf(myphone, tc),
                touchScreen(tc), partOf(myphone, a), antenna(a),
                hasSoftware(tc, s1), game(s1),
                hasSoftware(tc, s2), dialingSoftware(s2),
                feature(myphone,wifi), feature(myphone,bluetooth),
                hasProtocol(myphone, gsm), beautiful(myphone)].


/*-------------------*/
/* Prover without trace */
/*-------------------*/
%% prove((G,Q)) :-		% forms like (H,T) are returned by 'clause' (see below)
%%     !,
%%     prove(G),
%%     prove(Q).
%% prove(true) :-
%%     !.
%% prove(G) :-
%%     known(G),
%%     write('\t'), write(G), write(' is known'), nl.
%% prove(G) :-
%%     write('attempting to prove '),write(G),nl,
%%     clause(G,Q),	% Q may have the following form: (H,T) (where T may be also like Q)
%%     prove(Q),
%%     write(G), write(' has been proven'), nl.

prove((G,Q), Trace) :-
    !,
    prove(G, TraceG),
    prove(Q, TraceQ),
    append(TraceG,TraceQ,Trace).
prove(true, []) :-
    !.
prove(G, [G]) :-
    known(G),
    write('\t'), write(G), write(' is known'), nl.
prove(G, TraceQ) :-
    write('attempting to prove '),write(G),nl,
    clause(G,Q),
    prove(Q, TraceQ),
    write(G), write(' has been proven'), nl.

/*------*/
/* Test */
/*------*/
ebgTest :-
    retractall(known(_)),
    example(M, F),
    assertL(F),
    prove(telephone(M), S).

assertL([F|Fs]) :-
    assert(known(F)),
    assertL(Fs).
assertL([]).

