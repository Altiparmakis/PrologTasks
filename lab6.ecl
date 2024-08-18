
%%%% 
:-op(450,yfx,and).
:-op(500,yfx,or).
:-op(500,yfx,nor).
:-op(450,yfx,nand).
:-op(500,yfx,xor).

:-op(400,fy,--).
:-op(600,xfx,==>).



--Arg1:-not(Arg1).
 
Arg1 ==> Arg2 :- --Arg1 or Arg2.

Arg1 and Arg2 :- Arg1, Arg2.

Arg1 or _Arg2 :- Arg1.
_Arg1 or Arg2 :-Arg2.

Arg1 xor Arg2 :- Arg1, --Arg2.
Arg1 xor Arg2 :- --Arg1, Arg2.

Arg1 nor Arg2 :- --(Arg1 or Arg2).
Arg1 nand Arg2 :- --(Arg1 and Arg2).


t. 
f:-!,fail.

% Develop a predicate model/1, which accepts an expression in propositional 
% logic and allows the presence of variables in the expressions.

% For the implementation, we need the ECliPSe Prolog predicate (already implemented) 
% term_variables/2 (i.e., term_variables(Term, Vars)), which returns in the list 
% Vars all the variables appearing in the term Term.
model(Expr) :-
    term_variables(Expr, Vars),         
    bagof(Vals, (maplist(bind_vars, Vars), Expr), ValList), 
    member(Vals, ValList).


bind_vars(V) :-
    (V = t ; V = f). 

% Develop a predicate theory/1 that accepts a list of propositional logic expressions, 
% which may contain variables, and evaluates these expressions (satisfiability).

theory([]).

theory([Expr|Exprs]) :-
    	model(Expr),
	theory(Exprs).
	

% “If Y is true, then Y <==> X or Y, for any X.” The biconditional can be written as the conjunction 
% of Y ==> X or Y and X or Y ==> Y. Using setof/3 and the predicate theory/1, prove the above statement.

check_double_implication(Y, X) :-
    	theory([Y ==> (X or Y)]),
    	theory([(X or Y) ==> Y]).

prove_double_implication(X, Result) :-
    	setof(X_value, theory([X_value]), X_values),
    	maplist(check_double_implication(X), X_values, Results),
    	(member(no, Results) -> Result = no ; Result = yes).



% Given the Prolog predicate separate_lists(List, Lets, Nums), which, given a list of integers and 
% characters (items) List, succeeds when the list Lets contains all the characters (items) 
% from List and the list Nums contains all the numbers, translate it into Prolog.

seperate_lists(List,Lets,Nums):-
	findall(X,(member(X,List),number(X)),Nums),
	findall(X,(member(X,List),atom(X)),Lets).














 
