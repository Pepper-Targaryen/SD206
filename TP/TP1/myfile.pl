parent(marge, lisa).
parent(marge, bart).
parent(marge, maggie).
parent(homer, lisa).
parent(homer, bart).
parent(homer, maggie).
parent(abraham, homer).
parent(abraham, herb).
parent(mona, homer).
parent(jackie, marge).
parent(clancy, marge).
parent(jackie, patty).
parent(clancy, patty).
parent(jackie, selma).
parent(clancy, selma).
parent(selma, ling).


female(mona).
female(jackie).
female(marge).
female(ann).
female(patty).
female(selma).
female(ling).
female(lisa).
female(maggie).
male(abraham).
male(herb).
male(homer).
male(bart).
male(clancy).

child(X,Y) :-
   parent(Y,X).

mother(X,Y) :-
   parent(X,Y),
   female(X).

father(X,Y) :-
  parent(X,Y),
  male(X).

grandparent(X,Y) :-
   parent(X,Z), % note that the a variable's scope is the clause
   parent(Z,Y). % variable Z keeps its value within the clause

sister(X,Y) :-
   parent(Z,X), % if X gets instantiated, Z gets instantiated as well
   parent(Z,Y),
   female(X),
   X \== Y. % can also be noted: not(X = Y).

brother(X,Y) :-
  parent(Z,X),
  parent(Z,Y),
  male(X),
  X \== Y.

ancestor(X,Y) :-
   parent(X,Y).
ancestor(X,Y) :-
   parent(X,Z),
   ancestor(Z,Y). % recursive call

aunt(X,Y) :-
  parent(Z,Y),
  sister(X,Z). % find the sister of the parent
  % setof(A,aunt(A,lisa),AL) to delete repetition

uncle(X,Y) :-
  parent(Z,Y),
  brother(X,Z). % find the brother of the parent

cousin(X,Y) :-
  aunt(Z,Y), % find the aunt
  parent(Z,X). % find the child of the aunt
cousin(X,Y) :-
  uncle(Z,Y), % find the uncle
  parent(Z,X). % dind the child of the uncle

halfSibling(X,Y) :-
  father(F,X),
  father(F,Y),
  mother(M1,X),
  mother(M2,Y),
  M1 \== M2.
halfSibling(X,Y) :-
  mother(M,X),
  mother(M,Y),
  father(F1,X),
  father(F2,Y),
  F1 \== F2.

even([]).
even([A|B]) :-
  even(A),
  even(B).
even([A|B]) :-
  odd(A),
  odd(B).

odd(A) :-
  not(even(A)). 

%last_elt(Element, [Rest | Element], Rest).
last_elt([_|L], E) :- 
    last_elt(L, E). 
last_elt([E], E). 
  

extract(X, [X|L], L).
extract(X, [Y|L], [Y|L1]):-
  extract(X, L, L1).

%attach(A,B,[A|B])
attach([ ], L, L).
attach([X|L1], L2, [X|L3]) :- 
    attach(L1, L2, L3).

multiplex([X1], [X2], [[X1, X2]]).
multiplex([X1|Y1], [X2|Y2], [[X1, X2] | L]):-
  multiplex(Y1, Y2, L).

assemble(L1, L2, L3, Result):-
  attach(L1,L2, T),
  attach(T,L3, Result).

%where IncludedList is a continuous ‘chunk’ of the list IncludingList.
%For instance, sub_list([3, 4], [1, 2, 3, 4, 5, 6]) should succeed.
sub_list(L1, L2) :-
  assemble(_, L1, _, L2).

remove(X, M, L):-
  member(X, M),
  extract(X, M, L1),
  remove(X, L1, L),
  !.
remove(_, L, L).

duplicate([], []).
duplicate([X | L], [X, X | LL]):-
  duplicate(L, LL).
