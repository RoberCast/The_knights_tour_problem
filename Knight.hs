{-
		PROGRAM NAME: The journey of the chess knight
		AUTHOR:       Roberto Castillejo.
		VERSION:      1.0
-}


module Knight where

{- DATA TYPES USED IN PROGRAM
   ========================== -}

type File = [Bool]
type Board = [File]
type Square = (Int,Int)
type Path = [Square]

{- BACKTRACKING SCHEME
   =================== -}

bt :: (a -> Bool) -> (a -> [a]) -> a -> [a]
bt isSol comp node
  | isSol node = [node]
  | otherwise  = concat (map (bt isSol comp) (comp node))

{- AUXILIARY FUNCTIONS 
   =================== -}

-- Initializes the board
initBoard :: Int -> Square -> Board
initBoard n1 sq = changeSquare ((fst sq)-1) ((snd sq)-1) 0 0 (createBoard n1 0 0)

-- Check if a square on the board is free (file,rank)
freeSquare :: Board -> Square -> Bool
freeSquare xs sq = getFile xs (fst sq) (snd sq) 0
  where
    getFile [] n m i1 = False
    getFile (x:xs) n m i1
      |(n-1) == i1 = getRank x m 0
      |otherwise = getFile xs n m (i1+1)

-- Checks if the position is correct "within the board" and is free, and returns a list of possible moves
validSquares :: Int -> Board -> Square -> [Square]
validSquares n board sq = [x | x <- (knightMoves n sq), (freeSquare board x) == True, (inBoard n sq) == True]
  where
    knightMoves n (x,y) = filter (inBoard n) [(x+1, y+2),(x+1, y-2),(x+2, y+1),(x+2, y-1),(x-1, y+2),(x-1, y-2),(x-2, y+1),(x-2, y-1)]


-- Checks if a square is inside the board. True if it is inside, False otherwise
inBoard n (x,y) = 1<=x && x<=n && 1<=y && y<=n


-- Puts as False position Square on a given board
visitSquare :: Board -> Square -> Board
visitSquare xs sq = changeSquare ((fst sq)-1) ((snd sq)-1) 0 0 xs

-- Given a column, retrieve the value of its row
getRank :: [Bool] -> Int -> Int -> Bool
getRank [] n i2 = False
getRank (x:xs) n i2
   |(n-1) == i2 = x
   |otherwise = getRank xs n (i2+1)

-- Creates a board
createBoard :: Int -> Int -> Int -> [[Bool]]
createBoard n c1 c2
  |n == c2 = []
  |otherwise = createFile n c1 : createBoard n c1 (c2+1) 
  where
    createFile n c1
      |n == c1 = []
      |otherwise = True : createFile n (c1+1) 

-- Change the value of a square on a board
changeSquare :: Int -> Int -> Int -> Int -> [[Bool]] -> [[Bool]]
changeSquare n m index1 index2 [] = []
changeSquare n m index1 index2 (x:xs)
  |n == index1 = changeBoard m index2 x : changeSquare n m (index1 + 1) index2 xs
  |otherwise = x : changeSquare n m (index1 + 1) index2 xs 

-- Change the value of an item on the board
changeBoard :: Int -> Int -> [Bool] -> [Bool]
changeBoard n a [] = []
changeBoard n a (x:xs)
  |n == a = changeBoolean x : changeBoard n (a+1) xs
  |otherwise = x : changeBoard n (a+1) xs
  where
    changeBoolean x
      |x == True = False
      |otherwise = False

-- Retrieves the path contained in a Node
getElement :: (a,b,c,d,e) -> e
getElement (_,_,_,_,path) = path

{- MAIN FUNCTIONS
   ============== -}

type Node = (Int,Int,Board,Square,Path)

-- Check whether a node contains a complete path or not
fullPath :: Node -> Bool
fullPath (n1,n2,b,s,p) = (((\x -> x*x) n1) == n2)

-- Receives a node and returns the list of completions of that node
validJumps :: Node -> [Node]
validJumps (n1,n2,b,sq,xs) = [(n1,(n2+1),(visitSquare b x),x,(x:xs)) | x <- (validSquares n1 b sq)]

-- The main function takes an integer representing the size of the board, a square from which the knight will start its journey, and returns a path that traverses the entire board starting from the indicated square. If there is no solution, an empty path is returned
knightTravel :: Int -> Square -> Path
knightTravel n sq 
  |n < 1 || inBoard n sq == False = []
  |otherwise = reverse (getPath getNodeList)
    where
      initSquare = (n,1,initBoard n sq,sq,[sq])
      getNodeList = (take 1 (bt fullPath validJumps initSquare))
      getPath [] = []
      getPath xs = getElement (head xs)
