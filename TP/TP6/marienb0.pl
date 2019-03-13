/*---------------------------------------------------------------*/
/* Telecom Paristech - J-L. Dessalles 2019                       */
/* LOGIC AND KNOWLEDGE REPRESENTATION                            */
/*            http://teaching.dessalles.fr/LKR                   */
/*---------------------------------------------------------------*/



/**************************************************************/
/*  Simulation du jeu de Marienbad                            */
/**************************************************************/

sauve :-
	qsave_program('marienb.exe',[goal=go,autoload=true]).

%%%%%%%%%%%%%%%%%%%%%%%%%
% marienbad game (Nim)  %
%%%%%%%%%%%%%%%%%%%%%%%%%

:- dynamic(silent/0, value/2).

/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Players take as many items they want in a single row
          *
        * * *
      * * * * *
    * * * * * * *
The one who takes the last item looses.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/


% The state of the game is represented as a list containing the number of items for each row
game :-
	play([1, 3, 5, 7], []).

play(State, History) :-			% 'History' is the list of visited states
	gameOver(State, Result), 
	!,      % someone has won; 'Result' indicates who won
	write('.'),
	analyse(History, Result).	% analyses the ended game as a list of states ('History')
play(State, History) :-
	display(State),
	askMove(State, NState1), % asks for the opponent's move
	display(NState1),    % performs the opponent's move
	move(NState1, NState), % computes the machine's move
	play(NState, [NState1, State|History]).	% stores the two new states before looping


% 'gameOver' returns 1 if there is one item left, and 0 if there is no item left
gameOver([0|L], R) :- gameOver(L, R).	% discarding empty rows
gameOver([1|L], 1) :- gameOver(L, 0).	% one single item left: user looses if other rows are empty
gameOver([], 0).	% machine has lost

analyse(History, Result) :-
	keepInMind(History,Result), % learns from the game
	victory(Result).    % just says who won

victory(_) :-
        silent, !.	% no output when the 'silent' flag is raised
victory(1) :-
	write('J''ai gagne !!'), nl.
victory(0) :-
	write('J''ai perdu !!'), nl.

askMove(State, NState) :-
        silent,		% no output when the 'silent' flag is raised
        !,
        move(State, NState).    
askMove(State, NState) :-
	repeat0, 	% repeat0 acts as a bouncing wall for backtracking
	write('A vous : '), nl, 
	write('Nombre de croix : '),
	get(NChar),	% gets non-space ascii character
	Number is NChar - 48, % 48 == ASCII code of '0'
	write('Rangee : '), 
	get(RChar),
	Row is RChar - 48, % 48 == ASCII code of '0'
	modify(State, NState, Row, Number), % implements the move
	!.

move(State, NState) :-
        % computes the best available move
	findall(Act, transition(State, _, Act), ActList),  % list of available moves
	best(ActList, A), 
	transition(State, NState, A), % retrieves the resulting state
	comment(A).

transition(State, NState, act(R, N, V)) :-
	row(State, R, N),   % returns all moves available from 'State' in sequence
	modify(State, NState, R, N), % creates the corresponding new state
	value0(NState, V).  % evaluates the state

comment(_) :-
        silent, !.
comment(act(R, N, V)) :-
	write('J''en prends '), 
	write(N), write(' en '), write(R), 
	write(' (value: '), write(V), write(')'), nl.

modify([L|State], [L1|State], 1, Number) :-
	Number > 0,
	L >= Number, 
	L1 is L - Number, 
	!.
modify([L|State], [L|State1], Row, Number) :-
	Row > 1, 
	Row1 is Row - 1, 
	!, 
	modify(State, State1, Row1, Number).
modify(E, E, _, _) :-
	nl, 
	write('!!! coup impossible !!!'), nl, 
	fail.

%%%%%%%%%%%%%
% memory   %
%%%%%%%%%%%%%

% predicate 'value' is used to memorize the attractiveness of states
clean :-
	retractall(value(_, _)).

% 'keepInMind' takes all intermediary states of an ended game
% and valuates each of them depending on whether the winner or the looser went through it
keepInMind([], _).
keepInMind([H|HR], 0) :-
	memory(H, 1), 
	!, 
	keepInMind(HR, 1).
keepInMind([H|HR], 1) :-
	memory(H, -1), 
	!, 
	keepInMind(HR, 0).

memory(E, Incr) :-
	retract(value(E, V)), 
	!, 
	V1 is V + Incr, 
	assert(value(E, V1)).
memory(E, Incr) :-
	assert(value(E, Incr)).

value0(State, V) :-
	value(State, V), % know state
	!.
value0(_State, 0).  % the state was never encountered before

% 'best' finds the best valued act within a list of acts
best([A|AList], A1) :-
	best1(AList, A, A1).

best1([], B, B).
best1([A|AList], B, A1) :-
	A = act(_, _, V), 
	B = act(_, _, V1), 
	V > V1, 
	!, 
	best1(AList, A, A1).
best1([_|AList], B, A1) :-
	best1(AList, B, A1).

% 'learn' asks the machine to play N silent games with itself
learn(N) :-
	% You may use a combination  repeat(N),.... fail.
	% to have the program play N games against itself
	assert(silent),
	repeat(N),
	play([1,3,5,7],[]),
	fail,
	true.
learn(_):-
	retract(silent).


%%%%%%%%%%%%%
% display   %
%%%%%%%%%%%%%

display([N1|R]) :-	
	display(1, [N1|R]).
display(Row, [N1|R]) :-	
	show(Row, N1), 
	Row1 is Row + 1, 
	display(Row1, R).
display(_, []) :- 
	nl, nl.

show(Row, N) :-
	N > 0, 
	N1 is N - 1, 
	show(Row, N1), 
	write('X ').
show(Row, 0) :-
	nl, 
	write(Row), 
	write(' .........  ').

%%%%%%%%%%%%%%%
% utilitaires %
%%%%%%%%%%%%%%%

repeat0.
repeat0 :-
	repeat0.
	
repeat(N) :-
	N > 0.
repeat(N) :-
	N > 0, 
	N1 is N - 1, 
	repeat(N1).

% 'row' sorts through the rows, and for each,
% calls 'number' with the actual number of items in the row
row([N|_], 1, Nb) :-
	number(N, Nb).
row([_|L], R, Nb) :-
	row(L, R1, Nb), 
	R is R1 + 1.

% 'number' sorts through all possible values below the total number of items
number(R, 1) :-
	R >0.
number(R, N) :-
	R > 1, 
	R1 is R - 1, 
	number(R1, N1), 
	N is N1 + 1.

