:-op(140, fy, -).
:-op(160, xfy, [and, or, equiv, imp, impinv, nand, nor, nonimp, nonequiv, nonimpinv]).

is_true(V, X and Y) :- is_true(V,X), is_true(V,Y).
is_true(V, X or _) :- is_true(V,X).
is_true(V, _ or Y) :- is_true(V,Y).
is_true(V, -X) :-
    not(is_true(V, X)). % link with Prolog's negation
is_true(v0,a). % everything that is not a is false.
is_true(V, X equiv Y) :- is_true(V, (X and Y) or (-X and -Y)).
is_true(V, X imp Y) :- 
	% X imp Y equals not X or Y
	is_true(V, -X or Y).

is_true(V, X) :-
	member(X,V).

valuation(V) :-
	sub_set(V, [a,b,c]).	
	
sub_set([], []).
sub_set([X|XL], [X|YL]) :-
    sub_set(XL, YL).
sub_set(XL, [_|YL]) :-
    sub_set(XL, YL).
%valuation(V), is_true(V, (((a imp b) and (b imp c)) imp -(-c and a))).
%valuation(V), is_true(V, (a imp (b imp c)) imp ((a imp b ) imp (a imp c))).
