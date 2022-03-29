import Foundation

/// Combination calculation without recursing, using dynamic planning which is highly efficient
/// C(n, k) = C(n-1, k-1) + C(n-1, k)
/// C(n, 0) = C(n, n) = 1
func Combinations(_ total: Int, _ selection: Int)->Int{
    //C = [[0 for _ in range(k + 1)] for _ in range(n + 1)]
    var C:[[Int]] = Array(repeating: Array(repeating: 0, count: selection+1), count: total+1)
    for i in 0..<total+1{
        for j in 0..<(min(i, selection) + 1){
            if j == 0 || j == i{
                C[i][j] = 1
            }else{
                C[i][j] = C[i - 1][j - 1] + C[i - 1][j] //C(n, k) = C(n-1, k-1) + C(n-1, k)
            }
        }
    }
    return C[total][selection]
}

// P(n, k) = P(n-1, k) + k* P(n-1, k-1)
// P(5,3) = 5x4x3 = P(4,3) + 3 * P(4,2)
// 5x4x3 = 2*  4*3   + 3 * 4*3
func Permutations(_ total: Int, _ selection: Int)->Int{
    var P:[[Int]] = Array(repeating: Array(repeating: 0, count: selection+1), count: total+1)
    for i in 0..<total+1{
        for j in 0..<(min(i, selection) + 1){
            if j == 0 {
                P[i][j] = 1
            }else{
                P[i][j] = P[i - 1][j] + (j * P[i - 1][j - 1]) // P(n, k) = P(n-1, k) + k* P(n-1, k-1)
            }
            if (j < selection) {
                P[i][j + 1] = 0
            }
        }
    }
    return P[total][selection]
}
