/*
 Given a value N, if we want to make change for N cents, and we have infinite supply of each of S = { S1, S2, .. , Sm}
 valued coins, how many ways can we make the change? The order of coins doesn’t matter.

 for N = 4 and S = {1,2,3}, there are four solutions: {1,1,1,1},{1,1,2},{2,2},{1,3}.
 So output should be 4.

 For N = 10 and S = {2, 5, 3, 6}, there are five solutions: {2,2,2,2,2}, {2,2,3,3}, {2,2,6}, {2,3,5} and {5,5}.
 So the output should be 5
 */

import Foundation

/// A basic soltion to demonstrate the solution
/// 🔴This not an optimal solition, DO NOT use it
/// - Parameter coins : the coins set
/// - Parameter count : coins left to use
/// - Parameter sum : the sum to achieve with coins left to use
/// - Returns: the number of combinations to get the sum
func countCoinsCombo(_ coins:[Int], _ count:Int,  _ sum:Int )->Int{
    // If n is 0 then there is 1 solution (do not include any coin)
    if (sum == 0) {
        return 1
    }
    // If n is less than 0 then no solution exists
    if (sum < 0){
        return 0
    }
    // If there are no coins and n is greater than 0, then no solution exist
    if count <= 0 && sum >= 1 {
        return 0
    }
    // count is sum of solutions (i), including S[m-1] (ii) excluding S[m-1]
    return countCoinsCombo( coins, count - 1, sum ) + countCoinsCombo( coins, count, sum - coins[count-1] );
}


/// The optimal solution
/// - Parameter coins : the coins set
/// - Parameter sum : the sum to achieve with coins left to use
/// - Returns: the number of combinations to get the sum
func countCoinsComboDP(_ coins:[Int], _ sum: Int) -> Int {
    // We need n+1 rows as the table is constructed
    // in bottom up manner using the base case 0 value
    var table:[[Int]] = Array(repeating: Array(repeating: 0, count: coins.count), count: sum+1)
 
    // Fill the entries for 0 value case (n = 0)
    for i in 0..<coins.count {
        table[0][i] = 1
    }
 
    // Fill rest of the table entries in bottom up manner
    for i in 1..<sum+1{
        for j in 0..<coins.count {
            // Count of solutions including coins[j]
            let x = i-coins[j] >= 0 ? table[i - coins[j]][j] : 0
            // Count of solutions excluding coins[j]
            let y = j >= 1 ? table[i][j-1] : 0
            // total count
            table[i][j] = x + y
        }
    }
    return table[sum][coins.count-1]
}

let arr = [2, 5, 3, 6]
let count = arr.count
let sum = 10

print("Solutions using recursing = \(countCoinsCombo(arr, count, sum))")
print("Solutions using DP        = \(countCoinsComboDP(arr, sum))")


