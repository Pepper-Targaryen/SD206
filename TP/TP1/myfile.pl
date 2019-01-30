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
