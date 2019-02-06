% bad solution (double recursion):
mirror([ ], [ ]).
mirror([X|L1], L2) :-
    mirror(L1,L3),
    append(L3, [X], L2).     % append will dig into the list a second time

% better solution with accumulator:
mirror2(Left, Right) :-
    invert(Left, [ ], Right).
invert([X|L1], L2, L3) :-    % the list is 'poured'
    invert(L1, [X|L2], L3).    % into the second argument
invert([ ], L, L).        % at the deepest level, the result L is merely copied


palindrome1(L):-
    mirror2(L, L).

palindrome2(L):-
    inverse(L, []).
inverse(L, L).
inverse([_|L], L).
inverse([X|L], R):-
    inverse(L, [X|R]).
