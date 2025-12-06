
%		PROGRAM NAME: The journey of the chess knight.
%		AUTHOR: 	  Roberto Castillejo.
%		VERSION:      1.0.



% -------------------- AUXILIARY PREDICATES -------------------------

% Construct an empty N x N board
emptyBoard(N,Board) :- ct_aux(1,N,Board).

ct_aux(M,N,[]) :- M > N,!.
ct_aux(M,N,[File|RF]) :- emptyColumn(N,File), M1 is M+1, ct_aux(M1,N,RF).

emptyColumn(1,[true]) :- !.
emptyColumn(N,[true|CV]) :- N1 is N-1, emptyColumn(N1,CV).

% overwrite an element in a list
overwriteList(_,_,[],[]). 
overwriteList(Elem,0,[_|R],[Elem|R1]):- overwriteList(Elem,-1,R,R1),!. 
overwriteList(Elem,Pos,[C|R],[C|R1]):- ColTemp is Pos -1, overwriteList(Elem,ColTemp,R,R1). 

% Change the value to false in a given array
overwriteMatrix(_,_,_,[],[]) :- !. 
overwriteMatrix(0,Col,Elem,[Head|Tail],[C1|R1]) :- overwriteList(Elem,Col,Head,C1), RowTemp is -1, 
                                                          overwriteMatrix(RowTemp,Col,Elem,Tail,R1),!. 
overwriteMatrix(Row,Col,Elem,[Head|Tail],[Head|R1]) :- RowTemp is Row - 1, overwriteMatrix(RowTemp,Col,Elem,Tail,R1).

% Retrieves the value of a cell in an array
elemMatrix(Row,Col,[C|R],X):- getElem(Row,[C|R],L), getElem(Col,L,X). 
getElem(0,[C|_],C):-!. 
getElem(X,[_|R],Sol):- X1 is X -1, getElem(X1,R,Sol).

% Reverse a list
reverseList([],L,L) :- !.
reverseList([X|R],L2,L3) :- reverseList(R,[X|L2],L3).

% Prints a list of Paths
visualize(List) :- write("["),reverseList(List,[],NewList),printList(NewList),write("]").

% Prints a list
printList([X]) :- write(X),!.
printList([X|R]) :- write(X),write(","),printList(R).


% -------------------- PREDICATES TO IMPLEMENT ----------------------

% Check if a Node is a solution and view the Path traveled
fullPath(node(Tam_Board,Long_Path_recor,_,_,Path_recor)) :- X is Tam_Board * Tam_Board, Long_Path_recor == X,!, visualize(Path_recor).

% Define the initial node based on the board size, N, and a square from which the knight begins its journey, s(F,R), on an empty board. Use the predicates inBoard and visitSquare
initBoard(N,s(F,R),node(N,1,Board,s(F,R),[s(F,R)])) :- emptyBoard(N,Board0), inBoard(N,s(F,R)),!, visitSquare(s(F,R),Board0,Board).

% Check if the cell S(F,R) is inside a board of size N
inBoard(N,s(F,R)) :- 1 =< F, F =< N, 1 =< R, R =< N.

% Given a cell (s(F,R)), change its value to false on a given board
visitSquare(s(F,R), Board, BoardSol) :- F1 is F-1, R1 is R-1, overwriteMatrix(R1,F1,false,Board,BoardSol).

% It is the main predicate of the mathematical problem. It returns the path traversed on the board or an empty path if no solution exists
knightTravel(N,s(F,R)) :- initBoard(N,s(F,R),node(N,1,Board,s(F,R),[s(F,R)])), searchBT(node(N,1,Board,s(F,R),[s(F,R)])),!; write("[]").

% Implement in-depth solution searching with backtracking
searchBT(node(TamB,Long_path,Board,s(F,R),Path)) :- fullPath(node(TamB,Long_path,Board,s(F,R),Path)),!.
searchBT(node(TamB,Long_path,Board,s(F,R),Path)) :- jump((node(TamB,Long_path,Board,s(F,R),Path)),NNode), searchBT(NNode).

% Retrieve the value of a square on the board
getSquareValue(Board, s(F,R),Value) :- F1 is F-1, R1 is R-1, elemMatrix(R1,F1,Board,Value).

% Check if a square on the board is free (value true) or not (value false)
freeSquare(Board,s(F,R)) :- getSquareValue(Board,s(F,R),Value), Value == true.

% Check that there are successor nodes starting from Node and construct the possible moves, one by one, checking if they are valid squares (validSquare) and therefore valid moves that generate a successor node (NNode). There are 8 possible moves for the knight
jump(node(TamB,Long_Path,Board,s(F,R),Path), node(TamB,LP,NewBoard,s(F1,R1),[s(F1,R1)|Path])) :- F1 is F+2, R1 is R+1, LP is Long_Path+1, 
                                                                                                   validSquare(TamB,s(F1,R1),Board,NewBoard).
jump(node(TamB,Long_Path,Board,s(F,R),Path), node(TamB,LP,NewBoard,s(F1,R1),[s(F1,R1)|Path])) :- F1 is F+1, R1 is R+2, LP is Long_Path+1, 
                                                                                                   validSquare(TamB,s(F1,R1),Board,NewBoard).
jump(node(TamB,Long_Path,Board,s(F,R),Path), node(TamB,LP,NewBoard,s(F1,R1),[s(F1,R1)|Path])) :- F1 is F-1, R1 is R+2, LP is Long_Path+1, 
                                                                                                   validSquare(TamB,s(F1,R1),Board,NewBoard).
jump(node(TamB,Long_Path,Board,s(F,R),Path), node(TamB,LP,NewBoard,s(F1,R1),[s(F1,R1)|Path])) :- F1 is F-2, R1 is R+1, LP is Long_Path+1, 
                                                                                                   validSquare(TamB,s(F1,R1),Board,NewBoard).
jump(node(TamB,Long_Path,Board,s(F,R),Path), node(TamB,LP,NewBoard,s(F1,R1),[s(F1,R1)|Path])) :- F1 is F-2, R1 is R-1, LP is Long_Path+1, 
                                                                                                   validSquare(TamB,s(F1,R1),Board,NewBoard).
jump(node(TamB,Long_Path,Board,s(F,R),Path), node(TamB,LP,NewBoard,s(F1,R1),[s(F1,R1)|Path])) :- F1 is F-1, R1 is R-2, LP is Long_Path+1, 
                                                                                                   validSquare(TamB,s(F1,R1),Board,NewBoard).
jump(node(TamB,Long_Path,Board,s(F,R),Path), node(TamB,LP,NewBoard,s(F1,R1),[s(F1,R1)|Path])) :- F1 is F+1, R1 is R-2, LP is Long_Path+1, 
                                                                                                   validSquare(TamB,s(F1,R1),Board,NewBoard).
jump(node(TamB,Long_Path,Board,s(F,R),Path), node(TamB,LP,NewBoard,s(F1,R1),[s(F1,R1)|Path])) :- F1 is F+2, R1 is R-1, LP is Long_Path+1, 
                                                                                                   validSquare(TamB,s(F1,R1),Board,NewBoard).

% Verify that on the board of size N, it is possible to move to square s(F,R), because it is on the board and free. Then place (set to false in Board) the knight in position s(F,R), creating a new board
validSquare(TamB,s(F,R),Board,NewBoard) :- inBoard(TamB,s(F,R)),freeSquare(Board,s(F,R)),visitSquare(s(F,R),Board,NewBoard).
