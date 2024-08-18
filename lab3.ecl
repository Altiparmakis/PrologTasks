% Definition of a Prolog predicate `sum_even/2` which succeeds 
% when its second argument is the sum of all even 
% numbers that appear in the list of integers given as its first argument.

sum_even([],0).


sum_even([H|T],L):-
	sum_even(T, L2),
	(0 is H mod 2 -> 
        L is L2 + H  
    ;  
        L = L2
    ).
