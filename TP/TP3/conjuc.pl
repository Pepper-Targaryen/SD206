/*---------------------------------------------------------------*/
/* Telecom Paristech - J-L. Dessalles 2019                       */
/* LOGIC AND KNOWLEDGE REPRESENTATION                            */
/*            http://teaching.dessalles.fr/LKR                   */
/*---------------------------------------------------------------*/



:-op(140, fy, -).        
:-op(160,xfy, [and, or, imp, impinv, nand, nor, nonimp, equiv, nonimpinv]).

    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Conjunctive normal form %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%


/* table for unary, alpha and beta formulas */

components(- -X, X, _, unary).
components(X and Y, X, Y, alpha).
components(-(X or Y), -X, -Y, alpha).
components(X or Y, X, Y, beta).
components(-(X and Y), -X, -Y, beta).
components(X imp Y, -X, Y, beta).
components(-(X imp Y), X, -Y, alpha).
components(X impinv Y, X, -Y, beta).
components(-(X impinv Y), -X, Y, alpha).
components(X nand Y, -X, -Y, beta).
components(-(X nand Y), X, Y, alpha).
components(X nor Y, -X, -Y, alpha).
components(-(X nor Y), X, Y, beta).
components(X nonimp Y, X, -Y, alpha).
components(-(X nonimp Y), -X, Y, beta).
components(X nonimpinv Y, -X, Y, alpha).
components(-(X nonimpinv Y), X, -Y, beta).


% Predicate cnf puts more elementary processing together
cnf(Conjunction, NewConjunction) :-
	oneStep(Conjunction, C1),
	cnf(C1, NewConjunction).
cnf(C, C).

oneStep([Clause | Rest_conjunction], [ [F1, F2 | Rest_Clause] | Rest_conjunction]) :-
    % looking for a beta formula in the clause
    remove(BetaFormula, Clause, Rest_Clause),    
    components(BetaFormula, F1, F2, beta).

oneStep([Clause | Rest_conjunction], [ [F|Rest_Clause] | Rest_conjunction]) :-
    % looking for a unary formula in the clause
    remove(UnaryFormula, Clause, Rest_Clause),    
    components(UnaryFormula, F, _, unary).

oneStep([Clause | Rest_conjunction], [ [F1|Rest_Clause], [F2|Rest_Clause] | Rest_conjunction]) :-
    % looking for an alpha formula in the clause
    remove(AlphaFormula, Clause, Rest_Clause),    
    components(AlphaFormula, F1, F2, alpha).

oneStep([ F | Reste], [ F | New_Rest ]) :-
    % nothing left to do on F
    oneStep(Reste, New_Rest).



/*------------------------------------------------*/
/* Auxiliary predicates                           */
/*------------------------------------------------*/

/* remove does as select, but removes all occurrences of X */
remove(X, L, NL) :-
    member(X,L),	% so that remove fails if X absent from L
    remove1(X, L, NL).
remove1(X, L, L) :-
    not(member(X,L)).
remove1(X, L, NL) :-
	select(X, L, L1),   % available in SWI-Prolog
	remove1(X, L1, NL).