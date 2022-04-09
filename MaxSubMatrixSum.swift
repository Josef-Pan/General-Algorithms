/*
 Given a 2D array, find the maximum sum subarray in it. For example, in the following 2D array,
 the maximum sum subarray is highlighted with blue rectangle and sum of this subarray is 29.
 M = [[ 1,  2, -1, -4, -20],
      [-8, -3,  4,  2,  1],
      [ 3,  8, 10,  1,  3],
      [-4, -1,  1,  7, -6]]
 Kadane’s algorithm for 1D array can be used to reduce the time complexity to O(n^3). The idea is
 to fix the left and right columns one by one and find the maximum sum contiguous rows for every
 left and right column pair. We basically find top and bottom row numbers (which have maximum sum)
 for every fixed left and right column pair. To find the top and bottom row numbers, calculate the
 sum of elements in every row from left to right and store these sums in an array say temp[].
 So temp[i] indicates sum of elements from left to right in row i. If we apply Kadane’s 1D
 algorithm on temp[], and get the maximum sum subarray of temp, this maximum sum would be the
 maximum possible sum with left and right as boundary columns.

 To get the overall maximum sum, we compare this sum with the maximum sum so far.
 */

import Foundation

/// Performs kadane algorithm on a specific column of the 2D matrix
/// - Parameter column : 1D array
/// - Returns: max_sum
func kadaneOnColumn(_ column:[Int], _ start: inout Int, _ finish: inout Int, _ rows: Int)->Int{
    var sum = 0
    var max_sum = Int.min
    var local_start = 0
    // Just some initial value to check for all negative values case
    finish = -1
    for i in 0..<rows{
        sum += column[i]
        if sum < 0 {
            sum = 0
            local_start = i + 1
        } else if sum > max_sum{
            max_sum = sum
            start = local_start
            finish = i
        }
    }
    //There is at-least one non-negative number
    if finish != -1{
         return max_sum
    }
    // Special Case: When all numbers in column are negative
    max_sum = column[0]
    start = 0
    finish = 0

    // Find the maximum element in column
    for i in 1..<rows {
        if column[i] > max_sum{
            max_sum = column[i]
            start = i
            finish = i
        }
    }
    return max_sum
}

/// Search the maximum sum area from a give 2D array
/// - Parameter matrix : 2D array
/// - Returns: a tuple, (max_sum, finalLeft, finalTop, finalRight, finalBottom) of the target submatrix
func findMaxSum2DMatrix(_ matrix: [[Int]])->(Int, Int, Int, Int, Int){
    // Variables to store the final output
    var max_sum = Int.min
    var (finalLeft, finalRight, finalTop, finalBottom) = (-1, -1, -1, -1 )
    var (sum, start, finish) = (0, 0, 0 )
    
    guard matrix.count > 0 && matrix[0].count > 0 else { return (-1, -1, -1, -1, -1) }
    
    // Set the left column
    for left in 0..<matrix[0].count{

        // Initialize all elements of temp as 0
        var temp = Array(repeating: 0, count: matrix.count)

        // Set the right column for the left column set by outer loop
        for right in left..<matrix[0].count{

            // Calculate sum between current left and right for every row 'i'
            for i in 0..<matrix.count{
                temp[i] += matrix[i][right]
            }
            // Find the maximum sum subarray in temp[]. The kadaneOnColumn() function also
            // sets values of start and finish.
            // So 'sum' is sum of rectangle between (start, left) and (finish, right) which
            // is the maximum sum with boundary columns strictly as left and right.
            sum = kadaneOnColumn(temp, &start, &finish, matrix.count)

            // Compare sum with max_sum sum so far.
            // If sum is more, then update max_sum and other output values
            if sum > max_sum{
                max_sum = sum
                finalLeft = left
                finalRight = right
                finalTop = start
                finalBottom = finish
            }
        }
    }
    return (max_sum, finalLeft, finalTop, finalRight, finalBottom)
}


let matrix = [[ 1,  2, -1, -4, -20],
              [-8, -3,  4,  2,   1],
              [ 3,  8, 10,  1,   3],
              [-4, -1,  1,  7,  -6]]

let (max_sum, finalLeft, finalTop, finalRight, finalBottom) = findMaxSum2DMatrix(matrix)
print("(Top, Left)     \((finalTop, finalLeft))")
print("(Bottom, Right) \((finalBottom, finalRight))")
print("Max sum is    = \(max_sum)")
