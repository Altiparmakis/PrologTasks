% Definition of a predicate `rotate_left(Pos, List, RotatedList)` which succeeds when the 
% argument `RotatedList` is the list `List` rotated to the left by `Pos` positions.


rotate_left(Pos,List,RotatedList):-
	append(ListA,ListB,List),
	length(ListA,Pos),
	append(ListB,ListA,RotatedList).
	
