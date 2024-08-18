%% Libraries
:-lib(ic).
:-lib(ic_global).
:-lib(branch_and_bound).
:-lib(ic_edge_finder).

%%%% Exec1
%%% Server facts
:-dynamic allc/2.
:-dynamic co/2.
server(1,20,64).
server(2,40,16).
server(3,50,4).
server(4,50,8).
server(5,20,8).
server(6,30,64).
server(7,40,16).
server(8,70,32).
server(9,50,64).
server(10,60,8).
server(11,50,16).
server(12,80,64).
server(13,100,8).
server(14,90,24).
server(15,60,8).

% request facts
request(1,10,4).
request(2,60,8).
request(3,70,16).
request(4,50,4).
request(5,20,5).
request(6,10,64).
request(7,30,5).
request(8,40,8).
request(9,40,64).
request(10,30,8).

% In a cloud computing environment, tasks (requests) need to be assigned to 
% different servers (the number of servers is greater than the number of tasks). 
% For each task, we know its requirements in terms of storage space (HDD) and memory 
% size (RAM), information which is stored in facts of the form request(RID, HDD, RAM) 
% with RID being the identifier of the task. For each server, there are corresponding 
% facts server(SID, HDD, RAM) with SID being the identifier of the server, HDD being 
% its storage space, and RAM being its total memory.
% You need to ensure the following:
% (a) All requests are served simultaneously.
% (b) Each request is served by a different server.
% (c) Each request must be served by a server with sufficient storage and memory, 
% meaning the request's requirements must be less than or equal to the server's HDD and RAM.
% The allocation of tasks to servers should minimize the total resources used, 
% i.e., the sum of the memory and storage space allocated to the tasks should be as small as possible.
% Develop a CLP (Constraint Logic Programming) program with the predicate 
% gen_allocation(List, Cost), where the list List contains the information on 
% which server each request will be assigned to, and Cost represents the total cost of the allocation.

calc_cost(RAM,HDD,SRam,SHdd,Cost):-
	Cost #= (SRam-RAM) + (SHdd-HDD).

create_dynamics([]).	
create_dynamics([H|T]):-
	request(H,RAM,HDD),
	findall(Y,(server(Y,SRam,SHdd),RAM#=<SRam,HDD#=<SHdd),ListPrefSer),
	findall(C,(server(_,SRam,SHdd),RAM#=<SRam,HDD#=<SHdd,calc_cost(RAM,HDD,SRam,SHdd,C)),Costs),
	assertz(allc(H,ListPrefSer)),
	assertz(co(H,Costs)),
	create_dynamics(T).
	
constr(R,Assign,Cost,Links):-
	length(Links,10),
	length(Assign,10),
	ic_global:alldifferent(Links),
	calc(R,Links,Assign,Cost).

calc([],[],_,0).
calc([H|T],[HW|Rest],[allc_to(H,HW)|Res],TotalCost):-
	allc(H,ServersList),co(H,ServersCost),
	element(I,ServersList,HW),element(I,ServersCost,C),
	calc(T,Rest,Res,RCost),
	TotalCost #= C + RCost.

gen_allocation(Assign,Cost):-
	findall(X,request(X,_,_),R),
	create_dynamics(R),
	constr(R,Assign,Cost,Links),
	bb_min(labeling(Links),Cost,_),!.
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% In a warehouse, boxes with a width of exactly one (1) meter but with different 
% lengths need to be placed. These lengths are given by facts of the form box(ID, Length), 
% where ID is the identifier of the box and Length is its length. For example, the following facts:
% box(a, 250).
% box(b, 180).
% indicate that box a has a length of 250 cm and box b has a length of 180 cm 
% (these facts will be found in the exercise file on eclass).

% For some of the boxes, there are constraints on where they can be placed. 
% These constraints are given by facts of the form do_not_place(ID, Position), 
% where ID is the identifier of the box and Position is the position where it cannot be placed. 
% For example, the fact:
% do_not_place(a, 0).
% indicates that box a cannot be placed at position 0.
% You need to determine:
% (a) The minimum total width occupied by the boxes, given that they can be placed without gaps between them.

% (b) The placement of the boxes, which requires the distances of each box's placement from the start (position 0) of the warehouse.

% Write a CLP predicate store_loading/2 which returns the distance of each box from the 
% start of the warehouse and the minimum length occupied by all the boxes.

:-dynamic box/2.
:-dynamic do_not_place/2.

box(a,250).
box(b,180).
box(c,270).
box(d,190).
box(e,260).
box(f,120).
box(g,40).
box(h,10).

do_not_place(a,0).
do_not_place(b,2).
do_not_place(c,1).

dur_creator(0, []).                  
dur_creator(N, [1|Rest]) :-
    	N > 0,
    	N1 is N - 1,
    	dur_creator(N1, Rest).

cons([],[]).
cons([H|T],[St|RSt]):-
	do_not_place(H,C),
	St #\= C,
	cons(T,RSt).
cons([_|T],[_|RSt]):-
	cons(T,RSt).

store_loading(Starts,Makespan):-
	findall(X,box(X,_),Boxes),
	findall(Y,box(_,Y),Heights),
	length(Boxes,N),
	dur_creator(N,Duration),
	length(Starts,N),
	Starts #:: 0..inf,
	cons(Boxes,Starts),
	cumulative(Starts,Duration,Heights,400),
	ic_global:maxlist(Starts,Makespan),
	bb_min(labeling(Starts),Makespan,bb_options{strategy:dichotomic}),!.





  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A 2-dimensional array can be represented in Prolog as a list of lists

a_table(0,[[10,20,30],[40,50,60]]).
a_table(1,[[1,2,3],[4,5,6],[7,8,9]]).
a_table(2,[[10,20,30,40],[4,50,6,60],[70,80,90,100]]).
a_table(3,[[1,20,30,40],[4,1,6,1],[70,80,90,100]]).
:-dynamic thesi/2.

% Define the constraint element2d(I, J, Array, Var), which succeeds when the 
% value Var is equal to the value at position I, J in the 2-dimensional array Array.

calc_length([H|_],N):-
	length(H,N).
calc_row(1, [Element|_], Element).
calc_row(Index, [_|Tail], Element) :-
   	Index #> 1,
   	NewIndex #= Index - 1,
    	calc_row(NewIndex, Tail, Element).


element2d(I,J,Array,Var):-
	length(Array,N),
	I#:: 1..N ,
	calc_length(Array,M),
	J#:: 1..M,	
	calc_row(I,Array,Row),
	element(J,Row,Var).


% Use the above predicate to find N elements at different positions in a 2-dimensional array, 
% such that their sum is minimized. The predicate to implement is sumMin(N, Array, Ans, Sum), 
% where N is the number of elements, Array is the 2-dimensional array, Ans contains the elements 
% along with their positions as shown below, and Sum is the total sum. Predefined arrays 
% are provided in the predicate a_table/2.


appendTheArray(X,1,X).
appendTheArray([H1,H2|T],M,NewArray):-
	append(H1,H2,Newapp),
	N is M-1 ,
	appendTheArray([Newapp|T],N,NewArray).
first_n_elements(_, [], []).
first_n_elements(0, _, []).
first_n_elements(N, [X|Xs], [X|Ys]) :-
    N > 0,
    N1 is N - 1,
    first_n_elements(N1, Xs, Ys).

fill_ans_list([],_,_,_).
fill_ans_list([H|T],Array,[el([I,J],H)|Rest],[Y|R]):-
	element2d(I,J,Array,H),
	Y #= 2*I+J,
	fill_ans_list(T,Array,Rest,R).


sumMin(N,Array,Ans,Sum):-
	length(Array,M),
	length(Ans,N),
	appendTheArray(Array,M,NewArray),
	calc_row(1,NewArray,NewNewArray),
	length(NewNewArray,Y),
	N=<Y,
	sort(0,@=<,NewNewArray,SortedArray),
	first_n_elements(N,SortedArray,FirstN),
	sumlist(FirstN,Sum),
	length(Q,N),
	ic:alldifferent(Q),
	fill_ans_list(FirstN,Array,Ans,Q).

	











