%prints a list
printList([]) :- true.
printList([H|T]) :- writeln(H), printList(T).


%checks if coordinate is contained in the list
contains([],[_,_]) :- false.
contains([[X,Y]|_],[X,Y]) :- true.
contains([_|Tail],[X,Y]) :- contains(Tail,[X,Y]).


%facts for types of cells
printCell(_, List, Row, Column) :- contains(List, [Row, Column]), write('*').
printCell(Maze, _, Row, Column) :- maze(Maze, Row, Column, open), write(' ').
printCell(Maze, _, Row, Column) :- maze(Maze, Row, Column, barrier), write('x').


%writes a line of X number of -
line(1) :- write(-).
line(X) :- write(-), Y is X-1, line(Y).


%print the top middle and bottom of the maze
printTop(Maze) :- mazeSize(Maze, _, X),write(+), line(X), writeln(+).
printBot(Maze) :- mazeSize(Maze, _, X),write(+), line(X), writeln(+).
printMid(Maze, List) :- mazeSize(Maze, _, Max), printRow(Maze, 1,1,Max, List).


%recurse through a row and print it
printRow(Maze, Row, 1, Max, List) :- write("|"), printCell(Maze, List,Row, 1), printRow(Maze, Row, 2, Max, List).
printRow(Maze, Row, Max, Max, List) :-  printCell(Maze,List,Row, Max), writeln("|"), Y is Row+1,nextRow(Maze, Y, Max, List).
printRow(Maze, Row, X, Max, List) :-  printCell(Maze,List,Row, X), Y is X+1 ,printRow(Maze, Row, Y, Max, List).


%move on to the next row until no more rows
nextRow(Maze, Z, _, _) :- mazeSize(Maze, Y, _), Z is Y+1, printBot(Maze).
nextRow(Maze, Row, Max, List) :- printRow(Maze, Row, 1, Max, List).


%print the maze
printMaze(Maze, List) :- printTop(Maze), printMid(Maze, List).


%checks to see if a cell is a valid move
checkCell(Maze, Row, Column) :- maze(Maze, Row, Column, open).


%check to see if it is a valid move in the corresponding direction
up(Row, Column, List, Maze) :-
  Z is Row-1,
  not(contains(List, [Z, Column])),
  checkCell(Maze, Z, Column).


down(Row, Column, List, Maze) :-
  Z is Row+1,
  not(contains(List, [Z, Column])),
  checkCell(Maze, Z, Column).


left(Row, Column, List, Maze) :-
  Z is Column-1,
  not(contains(List, [Row, Z])),
  checkCell(Maze, Row, Z).


right(Row, Column, List, Maze) :-
  Z is Column+1,
  not(contains(List, [Row, Z])),
  checkCell(Maze, Row, Z).



%if at goalrow and column then end
move(Maze, List, GoalRow, GoalColumn, GoalRow, GoalColumn) :- printMaze(Maze, List), printList(List).


%if at goalrow dont move down
move(Maze, List, GoalRow, Column, GoalRow, GoalColumn) :-
  right(GoalRow, Column,  List, Maze) -> Z is Column+1,append(List, [[GoalRow, Z]],NewList), move(Maze, NewList, GoalRow, Z, GoalRow, GoalColumn);
  up(GoalRow, Column,  List, Maze) -> Z is GoalRow-1, append(List, [[Z, Column]],NewList),move(Maze, NewList, Z, Column, GoalRow, GoalColumn);
  left(GoalRow, Column,  List, Maze) -> Z is Column-1, append(List, [[GoalRow, Z]],NewList), move(Maze, NewList, GoalRow, Z, GoalRow, GoalColumn).

%if at goal column dont go right
move(Maze, List, Row, GoalColumn, GoalRow, GoalColumn) :-
  down(Row, GoalColumn,  List, Maze) -> Z is Row+1, append(List, [[Z, GoalColumn]],NewList), move(Maze, NewList, Z, GoalColumn, GoalRow, GoalColumn);
  up(Row, GoalColumn,  List, Maze) -> Z is Row-1, append(List, [[Z, GoalColumn]],NewList), move(Maze, NewList, Z, GoalColumn, GoalRow, GoalColumn);
  left(Row, GoalColumn,  List, Maze) -> Z is GoalColumn-1, append(List, [[Row, Z]],NewList), move(Maze, NewList, Row, Z, GoalRow, GoalColumn).

move(Maze, List, Row, Column, GoalRow, GoalColumn) :-
  right(Row, Column,  List, Maze) -> Z is Column+1, append(List, [[Row, Z]], NewList), move(Maze, NewList, Row, Z, GoalRow, GoalColumn);
  down(Row, Column,  List, Maze) -> Z is Row+1, append(List, [[Z, Column]],NewList), move(Maze, NewList, Z, Column, GoalRow, GoalColumn);
  up(Row, Column,  List, Maze) -> Z is Row-1, append(List, [[Z, Column]], NewList), move(Maze, NewList, Z, Column, GoalRow, GoalColumn);
  left(Row, Column,  List, Maze) -> Z is Column-1, append(List, [[Row, Z]], NewList), move(Maze, NewList, Row, Z, GoalRow, GoalColumn).

solveMaze(Maze) :- mazeSize(Maze, X, Y), move(Maze, [[1,1]], 1, 1, X, Y).
