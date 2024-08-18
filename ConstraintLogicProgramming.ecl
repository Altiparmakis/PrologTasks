
% Discounts! The prices have fallen to one-third of their original values! 
% You ordered labels with both old and new prices, but unfortunately, the printer made two mistakes:

% He returned the labels in ascending order, whereas you wanted them in pairs (old-new price).
% He mixed up your order with another one and sent you some extra labels.
% Write a predicate split_the_labels(Labels, Correct, Waste), where Labels is the sorted list of labels sent by the printer, 
% Correct is the list with the correctly paired labels in the correct order (discounted value first, then the original value), and 
% Waste is the list of extra labels. Correct ordering means that the discounted price comes first, followed by the original price.
remaining_List(X, [X|Xs], Xs).
remaining_List(X, [Y|Ys], [Y|Zs]) :-
    select(X, Ys, Zs).

split_the_labels([], [], []).

split_the_labels([Price | Rest], [(Price, NewPrice) | Correct], Waste) :-
    NewPrice is Price * 3,
    member(NewPrice, Rest),
    remaining_List(NewPrice, Rest, Remaining),
    split_the_labels(Remaining, Correct, Waste).

split_the_labels([Price | Rest], Correct, [Price | Waste]) :-
    split_the_labels(Rest, Correct, Waste).


% Implement a predicate det_type(TypeA, TypeB, TypeR) (i.e., det_type/3), where TypeA and 
% TypeB are the types of the operands of an operation, and TypeR is the type of the result. 
% The predicate should succeed if the three types are consistent with the rules described above.
type(int, long, long).
type(int, float, float).
type(int, double, double).
type(long, float, float).
type(long, double, double).
type(float, double, double).


det_type(A,A,A).
det_type(A, B, X):-
	type(A,B,X).
det_type(A, B, X):-
	type(B,A,X). 

% The compiler also has a symbol table (list) where it registers information from other stages, 
% containing the types of variables as terms in the form v(Var, Type), where Var is the variable name (Prolog atom) and 
% Type is the type. For example, the following table defines 2 variables x and y:

% prolog
% Αντιγραφή κώδικα
% [v(x, int), v(y, float)]
% Implement a predicate lookup(Var, Table, Type), which succeeds if the variable Var is declared in the table Table with the type Type. 

v(_,int).
v(_,float).
v(_,long).
v(_,double).

lookup(Var,[H|_],Type):-
	v(X,Ty)= H,
	Var==X,
	Type = Ty.
lookup(Var,[H|T],Type):-
	v(X,_)= H,
	Var\==X,
	lookup(Var,T,Type).

% Define the predicate expr_type(Expr, Table, Type), which infers the type Type of the expression 
% Expr using the symbol table Table. The operations that can be included in the expression are addition, 
% subtraction, multiplication, and division (+, -, *, /). In the expression, the type of numerical constants 
% is the smallest possible type; for example, 3 is considered int, while 4.0 is considered float.

t(X,int):-
	integer(X).
t(X,float):-
	float(X).

% Αν η έκφραση είναι αριθμητική σταθερά, επιστρέφει τον τύπο της σταθεράς.
expr_type(Number, _, Type) :-
    number(Number),
    t(Number,Type).

% Αν η έκφραση είναι μια μεταβλητή, ελέγχουμε τον πίνακα συμβόλων για τον τύπο της μεταβλητής.
expr_type(Var, Table, Type) :-
    atom(Var),
    lookup(Var, Table, Type).

expr_type(Expression, Table, FinalType) :-
    Expression =.. [_, Arg1, Arg2],
    expr_type(Arg1, Table, Type1),
    expr_type(Arg2, Table, Type2),
    det_type(Type1, Type2, FinalType),
    !.


% You want to construct a list of numbers (TargetList) that contains the integers from 1 to 3, starting 
% from an initial list of the same length which contains only zeros (0). At each step, you can select 
% a 0 from the list and the available moves are:

% (a) Replace the 0 with 1 if neither of its neighboring elements is 1.

% (b) Replace the 0 with 2 if at least one neighboring element is equal to 1, and none of the neighboring 
% elements is equal to 2. In this case, in addition to the replacement, the neighboring elements equal to 1 become 0.

% (c) Replace the 0 with 3 if one of its neighboring elements is 1 and the other is 2. In this case, both neighboring elements become 0.


% Implement a predicate build_array(ProbNum, Solution) (i.e., build_array/2) which, 
% given a problem number ProbNum, succeeds by returning the list Solution with the 
% intermediate lists (steps) according to the rules.

:- dynamic(prev_solutions/1).

set_at(Index, Value, List, Result) :-
    	set_at(Index, Value, List, 0, Result).

set_at(Index, Value, [_|Tail], Index, [Value|Tail]) :-
    !.

set_at(Index, Value, [Head|Tail], IndexToFind, [Head|NewTail]) :-
    	NewIndexToFind is IndexToFind + 1,
    	set_at(Index, Value, Tail, NewIndexToFind, NewTail).

list_creator(0, []).                   %% Δημιουργεί αρχικό πίνακα με μηδενικά
list_creator(N, [0|Rest]) :-
    	N > 0,
    	N1 is N - 1,
    	list_creator(N1, Rest).

zero_position(List, Index) :-
	length(List, Length),
    	zero_position(List, 0,Length, Index).

zero_position([0|_], Index,Length, Index) :- 
	Index \= 0,
	NN is Length - 1,
	Index \= NN.
zero_position([_|Tail], Count, Length, Index) :-
   	NewCount is Count + 1,
    	zero_position(Tail, NewCount, Length, Index).
zero_position([0|_], Index, _, Index):-!.


contains_zero([0|_]).			%% Ελένγχει εάν υπάρχουν μηδενικά στον πίνακα 
contains_zero([_|T]):-
	contains_zero(T).

rule(Arg1,Arg3,Arg1,1,Arg3):-
	Arg1 \= 1,
	Arg3 \= 1.
rule(Arg1,Arg3,0,2,Arg3):-
	Arg1 == 1,
	Arg3 \= 2.
rule(Arg1,Arg3,Arg1,2,0):-
	Arg3 == 1,
	Arg1 \= 2.
rule(1,2,0,3,0).
rule(2,1,0,3,0).

build_array(Num,ReversedSteps):-
	problem(Num,TargetList),
	length(TargetList,X),	
	list_creator(X,List),
	retractall(prev_solutions(_)),
	find_solution(List,TargetList,[List],Steps),
	reverse(Steps,ReversedSteps),
	not(prev_solutions(ReversedSteps)),
	asserta(prev_solutions(ReversedSteps)).


find_solution(List,List,Steps,Steps).

find_solution(List,TargetList,CurrentSteps,Steps):-
	contains_zero(List),
	zero_position(List,Index),
	apply_rules(List,Index,NewList),
	find_solution(NewList,TargetList,[NewList|CurrentSteps],Steps).

apply_rules(List,0,Final_Result):-
	After = 1,
	nth0(After,List,Arg3),
	rule(4,Arg3,_,NewArg2,NewArg3),
	set_at(0,NewArg2,List,Result),
	set_at(After,NewArg3,Result,Final_Result).

apply_rules(List,LastIndex,Final_Result):-
	length(List,N),
	NN is N -1 ,
	LastIndex == NN,
	Prev is LastIndex -1 ,
	nth0(Prev,List,Arg1),
	rule(Arg1,4,NewArg1,NewArg2,_),
	set_at(Prev,NewArg1,List,Result),
	set_at(LastIndex,NewArg2,Result,Final_Result).

apply_rules(List,Index,Final_Result):-
	Prev is Index -1 ,
	After is Index + 1,
	nth0(Prev,List,Arg1),
	nth0(After,List,Arg3),
	rule(Arg1,Arg3,NewArg1,NewArg2,NewArg3),
	set_at(Prev,NewArg1,List,Result),
	set_at(After,NewArg3,Result,Result2),
	set_at(Index,NewArg2,Result2,Final_Result).

nth0(0, [Element|_], Element).
nth0(Index, [_|Tail], Element) :-
   	Index > 0,
   	NewIndex is Index - 1,
    	nth0(NewIndex, Tail, Element).

		
% Implement the predicate best_solution(ProbNum, Len), which returns the length of the shortest solution to the problem ProbNum.
length_with_list(List,Length-List):-
	length(List,Length).

get_shortest(List, Shortest):-
    keysort(List, Sorted),
    Sorted = [Shortest-_|_].

best_solution(ProbNum,BestSolution):-
	findall(ReversedSteps,(build_array(ProbNum,ReversedSteps)),Solutions),
	maplist(length_with_list,Solutions,LengthsSolutions),
	get_shortest(LengthsSolutions,BestSolution).


% test cases
:-dynamic problem/2.
problem(1,[2, 1, 2]).
problem(2,[1, 3, 2, 1]).
problem(3,[1, 2, 2]).
problem(4,[1, 3, 1, 3, 1]).
problem(5,[1, 3, 1, 2, 1, 2]).












 
	
	

