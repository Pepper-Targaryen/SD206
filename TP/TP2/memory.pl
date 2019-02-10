% erase all the possible values
empty(P) :-
    retract(P),
    write(P), write(' has been forgotten'), nl,
    fail.    % this will force backtracking
empty(_).    % terminate with success   

:-dynamic(found/1).

%-------------------------------
% findall reconsidered
%-------------------------------

findany(Var, Pred, _) :-
    retractall(found(_)),    % resets memory, (not necessary, just to be sure)
    Pred,             % the execution of Pred instantiates Var
    % We call 'asserta' instead of assert to put on top of the memory stack, 
    % so that elements are retrieved in order
    asserta( found(Var) ),    % alternative solution: store Var without retracting
    fail.
findany(_,_,L) :-
    collect_found(L).

collect_found([V|L]) :-
    retract( found(V) ),
    !,
    collect_found(L).
collect_found([]).

% Atlernative solution
findany1(Var, Pred, _) :-
    assert(found([ ])),
    Pred,     % the execution of Pred instantiates Var
    retract(found(R)),     % always only one instance of ‘found’ 
                % in memory, no alternative to backtrack onto
    assert(found([Var | R])),
    fail.
findany1(_, _,L) :-
    retract(found(L)).
