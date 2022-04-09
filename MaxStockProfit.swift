/*
 In share trading, a buyer buys shares and sells on a future date. Given the stock price of n days,
 the trader is allowed to make at most k transactions, where a new transaction can only start after
 the previous transaction is complete, find out the maximum profit that a share trader could have
 made.
 
 Examples:
 Input: Price = [10, 22, 5, 75, 65, 80] K = 2  Output:  87
 Trader earns 87 as sum of 12 and 75, Buy at price 10, sell at 22, buy at 5 and sell at 80

 Input:  Price = [90, 80, 70, 60, 50] K = 1  Output:  0
 Not possible to earn.
 
 Input:
 Price = [12, 14, 17, 10, 14, 13, 12, 15]  K = 3  Output:  12
 Trader earns 12 as the sum of 5, 4 and 3. Buy at price 12, sell at 17, buy at 10  and sell at 14
 and buy at 12 and sell at 15
 
 Let profit[t][i] represent maximum profit using at most t transactions up to day i
 (including day i). Then the relation is:
 profit[t][i] = max(profit[t][i-1], max(price[i] – price[j] + profit[t-1][j])) for j in 0..<i-1
 profit[t][i] will be maximum of profit[t][i-1] which represents not doing any transaction on the
 ith day.
 
 Maximum profit gained by selling on ith day. In order to sell shares on ith day, we need to
 purchase it on any one of [0, i – 1] days. If we buy shares on jth day and sell it on ith day, max
 profit will be price[i] – price[j] + profit[t-1][j] where j varies from 0 to i-1.
 Here profit[t-1][j] is best we could have done with one less transaction till jth day.

 If we carefully notice,
 max(price[i] – price[j] + profit[t-1][j]) for j in 0..<i-1
 can be rewritten as,
 = price[i] + max(profit[t-1][j] – price[j]) for j in 0..<i-1
 = price[i] + max(prev_diff, profit[t-1][i-1] – price[i-1])
 where prev_diff is max(profit[t-1][j] – price[j]) for j in 0..<i-2
 
 So, if we have already calculated max(profit[t-1][j] – price[j]) for all j in range [0, i-2],
 we can calculate it for j = i – 1 in constant time. In other words, we don’t have to look back in
 the range [0, i-1] anymore to find out best day to buy.
 
 We can determine that in constant time using below revised relation.
 profit[t][i] = max(profit[t][i-1], price[i] + max(prev_diff, profit [t-1][i-1] – price[i-1])
 where prev_diff is max(profit[t-1][j] – price[j]) for all j in range [0, i-2]
 */

import Foundation

/// Auxiliary function to print 2D array out for debugging purpose
func printArray(_ array: [[Int]]) {
    for row in 0..<array.count {
        for column in 0..<array[0].count {
            let item_string = String(format: "%4d", array[row][column])
            print("\(item_string)", terminator: " ")
        }
        print("")
    }
}

/// A Dynamic Programming based solution to find the maximum profit
/// 🔴 This is not an optimal solution, for demonstrating purpose
/// - Parameter prices : the stock prices time sequence'
/// - Parameter transactions : number of transactions allowed
/// - Returns: maximum profit
func maxProfitDemoVersion( _ prices:[Int], _ transactions:Int)->Int{
    var profit:[[Int]] = Array(repeating: Array(repeating: 0, count: transactions+1), count: prices.count)
    
    for i in 1..<prices.count {
        for t in 1..<(transactions + 1){
            var max_so_far = Int.min
            for j in 0..<i{
                max_so_far = max(max_so_far, prices[i] - prices[j] + profit[j][t - 1])
            }
            profit[i][t] = max(profit[i - 1][t], max_so_far)
        }
    }
    return profit[prices.count - 1][transactions]
}

/// A Dynamic Programming based solution to find the maximum profit
/// - Parameter prices : the stock prices time sequence'
/// - Parameter transactions : number of transactions allowed
/// - Returns: maximum profit
func maxProfit( _ prices:[Int], _ transactions:Int)->Int{
    // Table to store results of subproblems
    // profit[t][t] stores maximum profit using atmost t transactions up to day t (including day t)
    var profit:[[Int]] = Array(repeating: Array(repeating: 0, count: prices.count+1), count: transactions+1)
    // Fill the table in bottom-up fashion
    for t in 1..<(transactions+1){
        var prev_diff = Int.min
        for i in 1..<prices.count{
            prev_diff = max(prev_diff, profit[t - 1][i - 1] - prices[i - 1])
            profit[t][i] = max(profit[t][i - 1], prices[i] + prev_diff)
        }
        // print("transactions = \(t)")
        // printArray(profit)
    }
    return profit[transactions][prices.count - 1]
}


let prices_demo = [10, 22, 5, 75, 65, 80]
let transactions_demo = 2
let max_profit_demo = maxProfitDemoVersion(prices_demo, transactions_demo)
print("Maximum profit with \(transactions_demo) transactions on stock \(prices_demo) = \(max_profit_demo)")

let prices = [12, 14, 17, 10, 14, 13, 12, 15]
let transactions = 3
let max_profit = maxProfit(prices, transactions)
print("Maximum profit with \(transactions) transactions on stock \(prices) = \(max_profit)")
