# The knight's tour problem

## Introduction
The knight's tour problem is a mathematical problem that consists of finding the sequence of moves made by a chess knight on a chessboard. The knight must visit each square on the board exactly once; that is, it cannot pass through the same square two or more times. The knight can end on the same square where it started, which is called a closed path; otherwise, the path is open.

The solution to this problem has been implemented in Haskell and Prolog, in the files *knight.hs* and *knight.pl* respectively. A chess knight is placed on any square of an NxN chessboard. This knight can only move according to the rules of chess. The problem is tested to see if it is possible to find an open path that allows the knight to visit every square on the board exactly once. The implementation follows a *backtracking* scheme.

In this problem, it's important to consider that there will be a path or sequence of moves depending on the size of the board (there is no solution for N equal to 2, 3, or 4) and the initial position of the knight. Furthermore, the problem has a symmetric solution; for example, if there is a solution for a board of size N equal to 5 starting from the initial square (1,5), there is also a solution for the initial square (5,1) for a board of the same size.

## Demo
Below are images showing the implementation of both solutions.

* Haskell execution:
![Haskell execution](Images/Demo_Knight_haskell.png)

* Prolog execution:
![Haskell execution](Images/Demo_Knight_prolog.png)
