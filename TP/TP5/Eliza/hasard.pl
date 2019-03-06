% ELIZA version francaise du 'Eliza' de Weizenbaum par Guy Lapalme http://rali.iro.umontreal.ca/lapalme/
% http://www.iro.umontreal.ca/~lapalme/intro-prolog.pdf

% HASARD

%% ce qu'il faut pour generer au hasard
% tirage au sort via un generateur congruentiel lineaire
% donne X un nombre reel dans [0,1]
hasard(X):-
	retract(germe_hasard(X1)), X2 is (X1*824) mod 10657,
	assert(germe_hasard(X2)), X is X2/10657.0 .
	
% donne X un nombre entier dans [1,N]
hasard(N,X) :-
	hasard(Y),
	X is floor(N*Y)+1.
	
% initialisation du germe (a la consultation du fichier)
:- abolish(germe_hasard,1), 
	X is floor(cputime*1000),
	assert(germe_hasard(X)).