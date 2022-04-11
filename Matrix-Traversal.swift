import Foundation

typealias RowCol = (row:Int, column:Int)

class MatrixTraversal {
    /// Traversal Matrix to certain point, returning (row, colum) pairs to the destination
    var paths:[[(Int,Int)]] = []
    /// Get number of ways to traverse the matrix, using dynamic planning
    /// numWays(i,j) = numWays(i-1,j) + numWays(i,j-1)
    /// Parameter target: a named tuple of row and column
    func getCountOfTraversal(target: RowCol) -> Int {
        guard  target.row >= 1 ,  target.column >= 1 else {
            return 0
        } // Travel to positive numbers only
        var ways:[[Int]] = Array(repeating: Array(repeating: -1, count: target.column+1), count: target.row+1)
        ways[0][0] = 1      // Only one way to reach to (0,0)
        for column in 1...target.column { // first row of ways matrix, only 1 way for all first row
            ways[0][column] = 1
        }
        for row in 1...target.row {    // first column of ways matrix, only 1 way for all first column
            ways[row][0] = 1
        }
        for row in 1...target.row {
            for column in 1...target.column{
                ways[row][column] = ways[row-1][column] + ways[row][column-1]
            }
        }
        return ways[target.row][target.column]
    }
    /// traversal of matrix from (0,0) to (targetRow,targetColumn), output is (row,col) path series
    /// targetRow, targetColumn are **0-based**
    /// Parameter target: a named tuple of row and column
    func traversalMatrix( target: RowCol)->[[(Int,Int)]]{
        paths.removeAll()
        guard  target.row >= 1 ,  target.column >= 1 else {
            return []
        } // Travel to positive numbers only
        var path = Array(repeating:(-1,-1), count: (target.row + target.column)*2) // filling -1
        travelUntil( (0,0), target, &path, 0)
        return self.paths
    }
    /// Recursive function to solve the problem
    private func travelUntil(_ current: RowCol, _ target: RowCol, _ path: inout [(Int, Int)], _ index: Int) {
        guard  target.row >= 1,  target.column >= 1 else { return } // Travel to positive numbers only
        // Reached the bottom so we are left with only option to move right
        if current.row == target.row {
            for column in current.column...target.column {
                path[index + column - current.column] = (current.row, column)
            } // if we hit this block, it means one path is completed
            self.paths.append(path.filter{ $0 != (-1,-1) } )
            return
        }
        // Reached the right most corner, we can only move down
        if current.column == target.column {
            for row in current.row...target.row {
                path[index + row - current.row] = (row, target.column)
            } // if we hit this block, it means one path is completed
            self.paths.append(path.filter{ $0 != (-1,-1)} )
            return
        }
        path [index]  = current    // add current position to the path list
        // move down in rows direction and call findPathsUtil recursively
        let nextRowOfCurrentPos = (current.row+1, current.column)
        travelUntil(nextRowOfCurrentPos, target, &path, index+1)
        // move right in columns direction and call findPathsUtil recursively
        let nextColOfCurrentPos = (current.row, current.column + 1)
        travelUntil(nextColOfCurrentPos, target, &path, index+1)
        
    }
}

//========================================================😀 Functions for testing 😀===========================================
func radomArray(_ dimension: Int) ->[[Int]] {
    var array = Array(repeating: Array(repeating: -1, count: dimension), count: dimension)
    for row in 0..<dimension {
        for column in 0..<dimension{
            array[row][column] = Int.random(in: 0 ..< 10)
        }
    }
    return array
}
func printArray(_ array: [[Int]]) {
    for row in 0..<array.count {
        for column in 0..<array[0].count {
            print("\(array[row][column])", terminator: " ")
        }
        print("")
    }
}
func printPaths( _ paths: [[(Int, Int)]], _ array:[[Int]] ) {
    for path in paths {
        for(row, column) in path {
            print("\(array[row][column])", terminator: " ")
        }
        print("")
    }
}
func printPathCostSorted( _ paths: [[(Int, Int)]], _ array:[[Int]] ) {
    var costs : [(Int,Int)] = []    // cost and path index in pairs
    for (index,value) in paths.enumerated() {
        var cost = 0
        for(row, column) in value {
            cost += array[row][column]
        }
        costs.append((cost, index))
    }
    costs.sort { return $0.0 < $1.0 }   // sort by the first value of the tuple
    for cost in costs {
        print("cost = \(cost.0), path = \(paths[cost.1])")
    }
}
