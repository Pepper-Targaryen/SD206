/*---------------------------------------------------------------*/
/* Telecom Paristech - J-L. Dessalles 2009                       */
/*            http://teaching.dessalles.fr                       */
/*---------------------------------------------------------------*/

%--------------------------------
%       semantic networks
%--------------------------------

isa(bird, animal).
isa(albert, albatross).
isa(albatross, bird).
isa(kiwi, bird).
isa(willy, kiwi).
isa(crow, bird).
isa(ostrich, bird).

:- dynamic(locomotion/2).	% for tests

locomotion(bird, fly).
locomotion(kiwi, walk).
locomotion(X, Loc) :-
	isa(X, SuperX),
	locomotion(SuperX, Loc).

food(albatross,fish).
food(bird,grain).

/* drawback : n particular inheritance rules */
/* solution: one general predicate : "known" */

known(Fact) :- 
	Fact,
	!.
known(Fact) :-
	Fact =.. [Rel, Arg1, Arg2],
	isa(Arg1, SuperArg1),
	SuperFact =.. [Rel, SuperArg1, Arg2],
	known(SuperFact).

habitat(Animal, continent):-
	known(locomotion(Animal, M)),
	M \== fly,
	!.
habitat(_, unknown).