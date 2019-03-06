/*---------------------------------------------------------------*/
/* Telecom Paristech - J-L. Dessalles 2019                       */
/* LOGIC AND KNOWLEDGE REPRESENTATION                            */
/*            http://teaching.dessalles.fr/LKR                   */
/*---------------------------------------------------------------*/


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Conversion from DCG to 'rule' %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  s --> gn, gv.
%  is converted into:
%  rule(s, [gn, gv]).
%

dcg2rules(GramFile) :-
	retractall(rule(_, _)),
	see(GramFile),
	recupere,
	write(GramFile), writeln(' loaded.'),
	seen.

recupere :-
	%catch(read_clause(R), _, (write('Error in rules'), nl)),
	catch(read(R), _, (write('Error in rules'), nl)),
	% write(R),
	R =.. [-->, T|Q],
	!,
	transforme(Q, Q1),
	assert(rule(T, Q1)),
	recupere.
recupere.

transforme([A], L) :-
	!,
	transforme(A, L).
transforme((A, B), [A|B1]) :-
	!,
	transforme(B, B1).
transforme(A, [A]).

