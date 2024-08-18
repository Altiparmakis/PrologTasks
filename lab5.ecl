% Definition of a predicate `max_min_eval(List, Result)` which takes an expression of integers and `min/max` 
% operations in list form (e.g., `[2,max,3,min,1]` which corresponds to `2 max 3 min 1`), and unifies 
% `Result` with the result of evaluating the expression. Assume that `min` and `max` are operators with the same 
% precedence and are left-associative, meaning `x max y min z == (x max y) min z`.

% For example, `[2,max,3,min,1]` corresponds to `2 max 3 min 1 == (2 max 3) min 1 == 3 min 1 == 1`. 
% If the expression is syntactically incorrect, the predicate fails.

reverse_head([H1,H2|T],[H2|T2]):-
	T2 = [H1|T].

max_min_eval([X],X).

max_min_eval([H1,H2,H3|T],Result):-
	W = [H1,H2,H3],
	reverse_head(W,L2),
	(member(min,L2); member(max,L2)),
	Y =.. L2,
	G is call(Y),
	max_min_eval([G|T],Result).

% Assume you have a set of predicates with arity 1, which succeed when their argument satisfies a certain condition. 
% For example, among the predicates you have are the following:
% less_ten(X) :- X < 10.
% less_twenty(X) :- X < 20.
% Consider the Prolog predicate filter(C, List, Solution) which succeeds when the list 
% Solution contains only the elements from the list List that satisfy the predicate C (arity 1). 
% The variable C is given only the name of the predicate. 
% Clearly, the filter/3 predicate is general, meaning it can work with any arity 1 predicate name, not just the ones above.

less_ten(X):-
	X < 10.

less_twenty(X):-
	X < 20.

filter(_,[],[]).

filter(C,[H|T],Solution):-
	Y =.. [C,H],
	call(Y),
	filter(C,T,L),
	append([H],L,Solution).

filter(C,[_|T],L):-
	filter(C,T,L).

