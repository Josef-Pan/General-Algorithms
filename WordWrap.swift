/*
 Given a sequence of words, and a limit on the number of characters that can be put in one line (line width).
 Put line breaks in the given sequence such that the lines are printed neatly. Assume that the length of each word
 is smaller than the line width.
 The word processors like MS Word do task of placing line breaks. The idea is to have balanced lines.
 In other words, not have few lines with lots of extra spaces and some lines with small amount of extra spaces.


 The extra spaces includes spaces put at the end of every line except the last one.
 The problem is to minimize the following total cost.
  Cost of a line = (Number of extra spaces in the line)^3
  Total Cost = Sum of costs for all lines

 For example, consider the following string and line width M = 15
  "Geeks for Geeks presents word wrap problem"

 Following is the optimized arrangement of words in 3 lines
 Geeks for Geeks
 presents word
 wrap problem

 The total extra spaces in line 1, line 2 and line 3 are 0, 2 and 3 respectively.
 So optimal value of total cost is 0 + 2*2*2 + 3*3*3 = 35

 Solution:
 1. We recur for each word starting with first word, and remaining length of the line (initially k).
 2. The last word would be the base case:
     We check if we can put it on same line:
         if yes, then we return cost as 0.
         if no, we return cost of current line based on its remaining length.
 3. For non-last words, we have to check if it can fit in the current line:
     if yes, then we have two choices i.e. whether to put it in same line or next line.
         if we put it on next line: cost1 = square(remLength) + cost of putting word on next line.
         if we put it on same line: cost2 = cost of putting word on same line.
         return min(cost1, cost2)
     if no, then we have to put it on next line:
         return cost of putting word on next line
 4. We use memoization table of size n (number of words) * k (line length), to keep track of already visited positions.
 */
import Foundation

/// Dynamic planning solution, this solution is very complicated, needs deep thinking
/// - Parameter line: Array representing the words of a line, eg. line[] = {3, 2, 2, 5} is for a sentence like "aaa bb cc ddddd".
/// - Parameter wrap: maximum line width
/// - Returns: a pattern for word arrangement, which will be explained in details in function decodePattern
func solveWordWrap(_ line:[Int], _ wrap:Int)->[Int]{
    //For simplicity, 1 extra space is used in all below arrays
    
    let n = line.count // Will be used too many times
    
    //extras[i][j] will have number of extra spaces if words from i to j are put in a single line
    var extras:[[Int]] = Array(repeating: Array(repeating: 0, count: n+1), count: n+1)
    
    // linecost[i][j] will have cost of a line which has words from i to j
    var linecost:[[Int]] = Array(repeating: Array(repeating: 0, count: n+1), count: n+1)
    
    // totalcost[i] will have total cost of optimal arrangement of words from 1 to i
    var totalcost:[Int] =  Array(repeating: 0, count: n+1)
    
    // pattern[] is used to print the solution.
    var pattern:[Int] =  Array(repeating: 0, count: n+1)
    
    // calculate extra spaces in a single line.
    // The value extra[i][j] indicates extra spaces if words from word number i to j are placed in a single line
    for i in 0..<(n+1){
        extras[i][i] = i>=1 ? (wrap - line[i - 1]) : (wrap - line.last!)
        for j in (i+1)..<(n+1){
            // extras[1][2] = extras[1][1] - line[1] - 1, 1 is the single space between words
            extras[i][j] = extras[i][j - 1] - line[j - 1] - 1
        }
    }
    /* extras will be following matrix in this example with line = [ 3, 2, 2, 5]
       1   -3   -6   -9  -15
       0    3    0   -3   -9
       0    0    4    1   -5
       0    0    0    4   -2
       0    0    0    0    1
     */
    // Calculate line cost corresponding to the above calculated extra spaces.
    // The value linecost[i][j] indicates cost of putting words from word number i to j in a single line
    for i in 0..<(n+1){
        for j in i..<(n+1){
            if extras[i][j] < 0{
                linecost[i][j] = Int.max;
            }else if j == n && extras[i][j] >= 0{
                linecost[i][j] = 0
            } else{
                linecost[i][j] = (extras[i][j] * extras[i][j])
            }
        }
    }
    /* linecost will be following matrix in this example with line = [ 3, 2, 2, 5]
        1   -1   -1   -1   -1
        0    9    0   -1   -1
        0    0   16    1   -1
        0    0    0   16   -1
        0    0    0    0    0
     */
    // Calculate minimum cost and find minimum cost arrangement.
    // The value totalcost[j] indicates optimized cost to arrange words from word number 1 to j.
    totalcost[0] = 0
    for j in 1..<(n+1){
        totalcost[j] = Int.max
        for i in 1..<(j+1){
            if totalcost[i - 1] != Int.max && linecost[i][j] != Int.max && ((totalcost[i - 1] + linecost[i][j]) < totalcost[j]) {
                totalcost[j] = totalcost[i - 1] + linecost[i][j]
                pattern[j] = i
            }
        }
    }
    /* totalcost and pattern will be following matrix in this example with line = [ 3, 2, 2, 5]
     totalcost = [0, 9, 0, 10, 10]
     pattern   = [0, 1, 1, 2,   4]
     */
    return pattern
}

/// Decode the pattern generated
/// - Parameter pattern: the word arragement, see the comment
/// - Returns: pairs of index of words
func decodePattern( _ pattern: [Int]) ->[(Int,Int)]{
    var pattern_with_idx :[(Int, Int)] = []
    pattern.enumerated().reversed().forEach{ pattern_with_idx.append(($1,$0))} // (pattern,index) in reverse order
    /* pattern_with_idx in this example with line = [ 3, 2, 2, 5], they are possible (startIndex, endIndex) pairs
        4, 2, 1, 1, 0   the pattern reversed
        4, 3, 2, 1, 0   the index   reversed
        first element always valid, in this case 4,4 as (pattern,index)
        then, search pattern-1 which is 3 in index, we found (2,3) as (pattern,index)
        then, search pattern-1 which is 1 in index, we found (1,1) as (pattern,index)
     */
    // Now filter out the valid entries from pattern_with_idx
    let filtered = pattern_with_idx.reduce(into: [(Int,Int)]()) { result, element in
        if result.isEmpty { // First element is always valid
            result.append(element)
        } else if element.1 + 1 == result.last?.0 && element.1 != 0 {
            result.append(element)
        }
    }
    return filtered.reversed()
}
let line = [3, 2, 2, 5] // words like "aaa bb cc ddddd"
let wrap = 6
let pattern = solveWordWrap(line, wrap)
let decoded = decodePattern(pattern)
print(pattern)
print(decoded)
