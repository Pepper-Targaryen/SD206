/*---------------------------------------------------------------*/
/* Telecom Paristech - J-L. Dessalles 2019                       */
/* LOGIC AND KNOWLEDGE REPRESENTATION                            */
/*            http://teaching.dessalles.fr/LKR                   */
/*---------------------------------------------------------------*/


% partial elementary English grammar

% --- Grammar
% new grammer
%% np(Number) --> det(Number), n(Number).

%% det(singular) --> [a].
%% det(plural) --> [many].
%% det(_) --> [the].

%% n(singular) --> [dog].
%% n(plural) --> [dogs].

%% s(Number) --> np(Number) , vp(Number).
s --> np , vp.
np --> det, n.		% Simple noun phrase
np --> det, n, pp.		% Noun phrase + prepositional phrase 
% np --> [kirk].
%% vp(Number) --> v(Number). % Verb phrase, intransitive verb
%% vp(Number) --> v(Number), np.        % Verb phrase, verb + complement: like X
%% vp(Number) --> v(Number), pp.        % Verb phrase, verb + indirect complement : think of X 
%% vp(Number) --> v(Number), np, pp.    % Verb phrase, verb + complement + indirect complement : give X to Y 
%% vp(Number) --> v(Number), pp, pp.    % Verb phrase, verb + indirect complement + indirect complement : talk to X about Y

vp --> v(none).     
vp --> v(transitive), np.     
vp --> v(intransitive), pp.    
vp --> v(ditransitive), np, pp. 
vp --> v(diintransitive), pp, pp.

s --> np(Sem), vp(Sem).
np(Sem) --> det, n(Sem).
vp(Sem) --> v(Sem, _).
vp(Sem1) --> v(Sem1, Sem2), np(Sem2).

n(sentient) --> [daughter]; [sister]; [aunt]; [sister].
n(nonEdible) --> [door].
n(edible) --> [apple].
v(sentient, _) --> [sleeps].
v(sentient, _) --> [likes].
v(sentient, edible) --> [eats].
v(sentient, _) --> [talks].
v(sentient, _) --> [give].

pp --> p, np.		% prepositional phrase

% -- Lexicon
det --> [the].
det --> [my].
det --> [her].
det --> [his].
det --> [a].
det --> [some].
n --> [dog].
n --> [daughter].
n --> [son].
n --> [sister].
n --> [aunt].
n --> [neighbour].
n --> [cousin].
v --> [grumbles].
%% v(singular) --> [hates].
%% v(plural) --> [hate].
%% v(singular) --> [likes].
%% v(plural) --> [like].
v --> [gives].
%% v(singular) --> [talks].
%% v(plural) --> [talk].
v --> [annoys].
v --> [cries].

v(none) --> [sleeps].
v(transitive) --> [likes].
v(transitive) --> [eats].    % mary eats the apple
v(none) --> [eats].            % mary eats (every day)
v(intransitive) --> [talks].    % mary talks to peter
v(none) --> [parle].        % mary talks (she is not mute)
v(diintransitive) --> [parle].    % mary talks to peter about the weather
v(ditransitive) --> [donne].    % mary gives him the book
%% s([the, dog, talks, to, the, dog, about, the, dog], [ ]).
%% true.
p --> [of].
p --> [to].
p --> [about].

np([number:sing, person:3, gender:feminine, sentience:true]) --> [mary].
n([number:sing, person:3, gender:_, sentience:true]) --> [dog].
n([number:plur, person:3, gender:neutral, sentience:false]) --> [apples].
det([number:_, person:3, gender:_, sentience:_]) --> [the].
v([subj:[number:sing, person:3, gender:_, sentience:true], event:false]) --> [thinks].
v([subj:[number:sing, person:3, gender:_, sentience:_], event:true]) --> [falls].

s --> np(FS), vp([subj:FS | _]).
np([number, person, _, sentience]) --> det([number, person, _, sentience]), n([number, person, _, sentience]).
vp([number, person, _, sentience]) --> v([number, person, _, sentience]). 

unify(FS, FS) :- !. % Let Prolog do the job if it can

unify([ Feature | R1 ], FS) :-
    select(Feature, FS, FS1), % checks whether the Feature is in the list
    !, % the feature has been found
    unify(R1, FS1).
s -->  {unify(FS1,FS2)}, np(FS1), vp([subj:FS2 | _]).

go :-
	s([mary, thinks],[]).
