% ELIZA version francaise du 'Eliza' de Weizenbaum par Guy Lapalme http://rali.iro.umontreal.ca/lapalme/
% http://www.iro.umontreal.ca/~lapalme/intro-prolog.pdf

% (adapte pour swi-Prolog)


%%% programme Eliza de Weizenbaum qui simule une
%%% conversation avec un therapeute.
%%% Le programme original a ete fourni par Michel Boyer.
%%% Les formules francaises sont inspireees de
%%% Wertz, Lisp, Masson, 1985, p180


:- consult('util.pl').
:- consult('hasard.pl').


% autre nom pour "concat" pour indiquer que tout ce qui
% nous interesse ici c'est de sauter un bout de phrase
% attention le resultat est dans le deuxieme parametre !!!
:- op(900, fy, '...').
...(X, Y, Z) :- append(X, Z, Y).

eliza :-
	write('Eliza: '), write(' Oui, tu peux tout me dire !'),
	repeat,
	nl, write('|: '),
	get_line(Entree),
	eliza(Entree).
	
eliza([bonsoir]) :-
	write(merci), nl, !.
	
eliza(Entree) :-
	reponse(Reponse, Entree, []), !,
	write('Eliza: '), writel(Reponse), fail.
	
%% Generation de la reponse a une entree du patient.
%% reponse(LaReponse) --> le modele a verifier dans l'entree

reponse([pourquoi, n, etes, vous, pas | X]) -->
	[je, ne, suis, pas], ...X.
reponse([alors, vous, savez, programmer]) -->
	..._, [prolog], ..._.
reponse([alors, vous, ne, savez, pas, programmer]) -->
	..._, [Langage], ..._, {member(Langage, [lisp, java, 'C++', python])}.
reponse([dites, m, en, plus, sur, votre, X]) -->
	..._, [X], ..._, {important(X)}.
reponse([hmmm]) -->
	[_, _, _].
reponse([vous, etes, bien, negatif]) -->
	[non].
reponse([c, est, un, peu, court]) -->
	[_], {ok(0.33)}.
reponse([vous, n, etes, pas, bavard]) -->
	[_], {ok(0.5)}.
reponse([vous, m, en, direz, tant]) -->
	[_].
% on n'a pas trouve les modeles qu'on cherchait ...
reponse([je, ne, vous, suis, pas, tres, bien]) -->
	..._, {ok(0.33)}.
reponse([ca, alors]) -->
	..._, {ok(0.5)}.
reponse([n, importe, quoi]) -->
	..._.


% ne reussit qu'avec probabilite P
ok(P):- hasard(X), !, X<P.


%% la semantique ...
important(mere).
important(pere).

/*
Exemple d'interaction avec ce programme
| ?- eliza.
Oui, tu peux tout me dire!
|: j'aime bien faire du prolog
alors vous savez programmer
|: oui
vous n etes pas bavard
|: non
vous etes bien negatif
|: pas autant que mon pere
dites m en plus sur votre pere
|: je ne suis pas tout a fait votre conversation!
pourquoi n etes vous pas tout a fait votre conversation
|: parce que ce serait trop long
n importe quoi
|: vous m insultez
hmmm
|: c'est tout ce que ca vous fait
n importe quoi
|: eh oui
ca alors
|: bonsoir.
merci
*/
