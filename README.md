# General-Algorithms
General Algorithms which were proven, most are using Dynamic Planning to replace recursing for better performance

print("C(7,3) = \\(Combinations(7,3))" ) // Should be 35

print("C(6,3) = \\(Combinations(6,3))" ) // Should be 20

print("C(6,2) = \\(Combinations(6,2))" ) // Should be 15

print("P(7,3) = \\(Permutations(7,3))" ) // 210

print("P(5,3) = \\(Permutations(5,3))" ) // 60

print("P(5,2) = \\(Permutations(5,2))" ) // 20

Maxtrix Traversal, travel from(0,0) to (m,n), maybe some (x,y) are not allowed

let mt = MatrixTraversal()

let paths = mt.traversalMatrix(target: (2,2)) // how many paths from (0,0) to (2,2) which is a 3x3 array

// how many paths avoiding (row,column) (0,1) & (1,2)

let pathsFiltered = paths.filter{ element in  
    !element.contains{ $0 == (0,1) || $0 == (1,2) }
    
}

print("paths = \\(paths)")

print("pathsFiltered avoiding (0,1) & (1,2)= \(pathsFiltered)")

print(pathsFiltered)

// If we don't need the paths and just the count

let ways = mt.getCountOfTraversal(target: (2,2))

print("ways of 3x3 = \\(ways), paths.count = \\(paths.count)") //Both should be 6


let array4x4 = radomArray(4)

printArray(array4x4)

let paths4x4 = mt.traversalMatrix(target: (3,3))

printPathCostSorted(paths4x4, array4x4)

