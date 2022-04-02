import Foundation
/*
 Given a value N, if we want to make change for N cents, and we have infinite supply of each of S = { S1, S2, .. , Sm}
 valued coins, how many ways can we make the change? The order of coins doesn’t matter.

 for N = 4 and S = {1,2,3}, there are four solutions: {1,1,1,1},{1,1,2},{2,2},{1,3}.
 So output should be 4.

 For N = 10 and S = {2, 5, 3, 6}, there are five solutions: {2,2,2,2,2}, {2,2,3,3}, {2,2,6}, {2,3,5} and {5,5}.
 So the output should be 5
 */

/// First solution using recursing, to demonstrate the basic idea
func countCoinsCombo(_ S:[Int], _ m:Int, _ n:Int )->Int{
    // If n is 0 then there is 1 solution (do not include any coin)
    if (n == 0) {
        return 1
    }
    
    // If n is less than 0 then no solution exists
    if (n < 0){
        return 0
    }

    // If there are no coins and n is greater than 0, then no solution exist
    if m <= 0 && n >= 1 {
        return 0
    }

    // count is sum of solutions (i), including S[m-1] (ii) excluding S[m-1]
    return countCoinsCombo( S, m - 1, n ) + countCoinsCombo( S, m, n-S[m-1] );
}


/// Second solution using dynamic planning
func countCoinsComboDP(_ S:[Int], _ m: Int, _ n: Int) -> Int {
    // We need n+1 rows as the table is constructed
    // in bottom up manner using the base case 0 value
    // case (n = 0)
    // table = [[0 for x in range(m)] for x in range(n+1)]
    var table:[[Int]] = Array(repeating: Array(repeating: 0, count: m), count: n+1)
 
    // Fill the entries for 0 value case (n = 0)
    for i in 0..<m {
        table[0][i] = 1
    }
 
    // Fill rest of the table entries in bottom up manner
    for i in 1..<n+1{
        for j in 0..<m {
 
            // Count of solutions including S[j]
            let x = i-S[j] >= 0 ? table[i - S[j]][j] : 0
 
            // Count of solutions excluding S[j]
            let y = j >= 1 ? table[i][j-1] : 0
 
            // total count
            table[i][j] = x + y
        }
    }
    return table[n][m-1]
}

let arr = [2, 5, 3, 6]
let m = arr.count
let n = 10

print("Solutions using recursing = \(countCoinsCombo(arr, m, n))")
print("Solutions using DP        = \(countCoinsComboDP(arr, m, n))")


