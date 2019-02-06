% adapted from I. Bratko - "Prolog - Programming for Artificial Intelligence"
%              Addison Wesley 1990

% An ape is expected to form a plan to grasp a hanging banana using a box.
% Possible actions are 'walk', 'climb (on the box)', 'push (the box)',
% 'grasp (the banana)'

% description of actions - The current state is stored using a functor 'state'
% with 4 arguments:
%	- horizontal position of the ape
%	- vertical position of the ape
%	- position of the box
%	- status of the banana
% 'action' has three arguments:
% 	- Initial state
%	- Final state
%	- act

% Definition of the possible actions with the state associated constraints
action(state(middle, onbox, middle, not_holding),
            grab,
            state(middle, onbox, middle,holding)).
action(state(P, floor, P, T),
            climb,
            state(P, onbox, P, T)).
action(state(P1, floor, P1, T),
            push(P1, P2),
            state(P2, floor, P2, T)).
action(state(P1, floor, B, T),
            walk(P1, P2),
            state(P2, floor, B, T)).

% success(state(_, _, _, holding)):-
%     write(Plan).
% success(State1, ) :-
%     action(State1, A, State2),
%     write('Action : '), write(A), nl, write(' --> '), write(State2), nl,
%     success( State2).

% go :-
% 	success(state(door, floor, window, not_holding)).

success(state(_, _, _, holding), Plan):-
    write(Plan).
success(State1, Plan) :-
    action(State1, A, State2),
    success( State2, [A|Plan]).

go :-
	success(state(door, floor, window, not_holding), []).
