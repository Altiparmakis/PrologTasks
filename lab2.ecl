% The following recursive definition.:
% f(n) = {
%     1                , if n = 0
%     n                , if 0 < n < 5
%     2 * f(n-4)       , if 5 ≤ n ≤ 8
%     f(f(n-8))        , if n > 8
% }
% Implementation of the above function.

fn(0,1).
fn(N,X):-
	N>0,
	N<5,
	X=N.

fn(N,X):-
	N>4,
	N<9,
	Y is N - 4,
	fn(Y,W),
	X is 2 * W.

fn(N,X):-
	N>8,	
	Y is N - 8,
	fn(Y,W),
	fn(W,Result),
	X = Result.
	
	
