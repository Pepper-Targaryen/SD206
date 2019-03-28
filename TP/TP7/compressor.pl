/*---------------------------------------------------------------*/
/* Telecom Paristech - J-L. Dessalles 2019                       */
/* LOGIC AND KNOWLEDGE REPRESENTATION                            */
/*            http://teaching.dessalles.fr/LKR                   */
/*---------------------------------------------------------------*/


%      ==========================
%      Complexity and compression
%      ==========================

/* ------------------------------------------------------* /
    This programme implements a simple compressor that
    recognizes duplicated patterns in a list
/ *------------------------------------------------------ */



/*------------------------------------------------------------------------
    'copy' detects n-plicated pattern at the beginning of a list
    copy(<copied element>, <number of copies>, <input list>, <remainder>)
--------------------------------------------------------------------------*/
copy(X, 1, [X], []).
copy(X, 1, [X,Y|L], [Y|L]) :-
    X \== Y.
copy(X, Times, [X|Xs], Rest) :-
    copy(X, Times1, Xs, Rest),
    Times is Times1 + 1.
    

/* 'plusOne(X, Y)' verifies that Y = X + 1 */
plusOne(X,Y) :-
    var(X), integer(Y), X is Y - 1.
plusOne(Y,X) :-
    var(X), integer(Y), X is Y + 1.
plusOne(X,Y) :-
    integer(X), integer(Y), Y is X + 1.
	
/* increment(2, 6, L, R).  L = [3, 4, 5, 6, 7, 8|R] . */
increment(_, 1, [],[]).
increment(X, 1, [Y|L], [Y|L]) :-
    X \== Y - 1.
increment(X, Times, [Xf|Xr], Rest):-
    %%%%%%%%% to be written %%%%%%%%%%%
    increment(Xf, Times1, Xr, Rest),
    Times is Times1 + 1,
    plusOne(X, Xf).


    
/*--------------------------------------------------------------------------------------------------
    'periodic' detects periodic pattern in a list
    periodic(<copied pattern>, <size of jump>, <number of copies>, <input list>, <skipped elements>)
    the period is thus: <length of pattern> + <size of jump>
--------------------------------------------------------------------------------------------------*/
periodic(_, _, 0, [], []).
periodic(Pattern, Jump, Times, Input, Skipped) :-
    Pattern = [_|_],    % avoid empty patterns
    append(Pattern, Next, Input),
    jump(Jump, Next, Next1, Skipped1),		% moves by 'Jump' places through 'Next'
    periodic(Pattern, Jump, Times1, Next1, Skipped2),
    Times is Times1 + 1,
    append(Skipped1, Skipped2, Skipped).	% sticks remaining chunks together

jump(0, L, L, []).
jump(N, [X|L], Remainder, [X|Skipped])  :-
    jump(N1, L, Remainder, Skipped),
    N is N1 +1.

/*--------------------------------------------------------------------
    'compress' performs a compressing operation.
    It is weakly recursive: it attempts to compress the remainder of a list
    after one compressing operation, but does not attempt to compress
    the overall output of the compression
---------------------------------------------------------------------*/
compress([],[]) :- !.
compress(Input,[c,N,X|CRest]) :-
    copy(X, N, Input, Rest),
    N > 1,  % to avoid trivial results
    compress(Rest,CRest).
compress(Input,[cs,Times,X,Step|CRest]) :-
	/* 'cs' means "copy-step".
		'[cs, Times, X, Step]' means that pattern 'X' is copied 'Times' times
		while allowing 'Step' items in-between.	*/
    periodic(X, Step, Times, Input, Rest),
    Times > 1,
    compress(Rest,CRest).
	%%%%%%%%%%%% to be uncommented when increment is written %%%%%%%%%%
compress([X|Input],[inc,X,Times|CRest]) :-
    increment(X, Times, Input, Rest),
    Times > 1,
    compress(Rest,CRest).

compress(Input,Input).

% Tries various compression operations and find the most successful
complexity(L, CompressedL, K) :-
    findall(CL, compress(L,CL), CLL),
    shortest(CLL,CompressedL),
    length(CompressedL, K).

% Find the shortest element in a list
shortest([X],X) :- !.
shortest([X|L],Z) :-
    shortest(L,Y),
    shorter(X,Y,Z).
shorter(X,Y,X) :-    
    length(X,Xl),
    length(Y,Yl),
    Xl < Yl,
    !.
shorter(_,Y,Y).


/*---------*/
/* TESTS   */
/*---------*/
testCompress :-
    % L = [1,1,1,1,1,1,1,2,2,2,2,2,3],
    % L = [1,2,3,1,2,3,1,2,3,1,2,3],
    % L = [1,2,3,a,1,2,3,b,1,2,3,c,1,2,3,d,1,2,3,e],
    % L = [1,2,3,4,5,6,7,8],
    L = [31,31,31,31,32,32,32,32,33,33,33,33,34,34,34,34,35,35,35,35,36,36,36,36],
        write('original list:    \t'),write(L),nl,
    complexity(L,CL,_), complexity(CL, CCL, _),
        write('compressed version:\t'), write(CL),nl,
        write('compressed twice version:\t'), write(CCL),nl,
    compress(L2,CCL), compress(L1,L2),  % Funny: 'compress' is used to decompress
    !,  % necessary, since reversibility is not perfect
        write('recovered list:  \t'), write(L1),nl.

go :- testCompress.
