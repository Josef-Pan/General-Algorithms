/*
 Given a string, a partitioning of the string is a palindrome partitioning if every substring of the partition is a
 palindrome. For example, “aba|b|bbabb|a|b|aba” is a palindrome partitioning of “ababbbabbababa”. Determine the fewest
 cuts needed for a palindrome partitioning of a given string. For example, minimum of 3 cuts are needed for
 “ababbbabbababa”. The three cuts are “a|babbbab|b|ababa”. If a string is a palindrome, then minimum 0 cuts are needed.
 If a string of length n containing all different characters, then minimum n-1 cuts are needed.
 nput : str = “geek”
 Output : 2
 We need to make minimum 2 cuts, i.e., “g ee k”
 Input : str = “aaaa”
 Output : 0
 The string is already a palindrome.
 Input : str = “abcde”
 Output : 4
 Input : str = “abbac”
 Output : 1
 i is the starting index and j is the ending index. i must be passed as 0 and j as n-1
 minPalPartion(str, i, j) = 0 if i == j. // When string is of length 1.
 minPalPartion(str, i, j) = 0 if str[i..j] is palindrome.

 If none of the above conditions is true, then minPalPartion(str, i, j) can be
 calculated recursively using the following formula.
 minPalPartion(str, i, j) = Min { minPalPartion(str, i, k) + 1 +
                                  minPalPartion(str, k+1, j) }
                            where k varies from i to j-1
 */

import UIKit

/// Those extensions are availabe at https://github.com/Josef-Pan/Swift-String-Extensions/blob/main/String-Extensions.swift
extension String {
    subscript (ix: Int) -> Character { // 🔴 Using of this function needs to make sure the ix is legal
        get {
            let index = self.index(self.startIndex, offsetBy: ix)
            return self[index]
        }
        set {
            let index = self.index(self.startIndex, offsetBy: ix)
            self.replaceSubrange(index...index, with: String(newValue))
        }
        
    }
    /// Use integer range to get a slice from String
    ///  lower bound and upper bound are checked, so it is safe even it exceeds string length
    /// - Parameter r: Range, eg.  2..<10, 0..<5
    /// - Returns: String
    subscript (r: Range<Int>) -> String{ // ✅ Safe to use Range from any indices, even exceeding boundary
        get {
            // Keep starting idx between 0 and boundary
            let lowerBound  = min(max(r.lowerBound, 0), self.count)
            // Keep ending idx between 0 and boundary
            let upperBound  = max(min(r.upperBound, self.count), 0)
            let startIndex = self.index(self.startIndex, offsetBy: lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: upperBound)
            return String(self[startIndex..<endIndex])
        }
    }
    /// Use integer range to get a slice from String
        ///  lower bound and upper bound are checked, so it is safe even it exceeds string length
        /// - Parameter r: ClosedRange, eg.  2...10, 0...5
        /// - Returns: String
    subscript (r: ClosedRange<Int>) -> String{
        // ✅  Safe to use Range from any indices, even exceeding boundary
        get {
            // Keep starting idx between 0 and boundary
            let lowerBound  = min(max(r.lowerBound, 0), self.count-1)
            // Keep ending idx between 0 and boundary
            let upperBound  = max(min(r.upperBound, self.count-1), 0)
            let startIndex = self.index(self.startIndex, offsetBy: lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: upperBound)
            return String(self[startIndex...endIndex])
        }
    }
}

func isPalindrome(_ string: String)->Bool{
    return string == String(string.reversed())
}

/// Recursing design
/// Even though the code is simple, this recursing will call 451799 times in the following example
/// 🔴So, this algorithm is only for demonstration purpose. Its efficiency is LOW !!!
func minPalPartion(_ string:String, _ i:Int, _ j:Int)->Int{
    if i >= j || isPalindrome(string[i..<(j + 1)] ){
        return 0
    }
    var answer:Int = Int.max
    for k in i..<j{
        let count = 1 + minPalPartion(string, i, k) + minPalPartion(string, k + 1, j)
        answer = min(answer, count)
    }
    return answer
}

/// Dynamic planning design
/// ✅Even though the code is much longer than recursing, but the time needed for this algorithm is much shorter
func minPalPartionDP(_ str: String)->Int {
    let n = str.count // Will be used many times, shorten it
    
    // Create two arrays to build the  solution in bottom up manner
    // C[i][j] = Minimum number of cuts needed for palindrome
    // partitioning of substring str[i..j]
    // P[i][j] = true if substring str[i..j] is palindrome, else false. Note that C[i][j] is 0 if P[i][j] is true
    var C:[[Int]] = Array(repeating: Array(repeating: 0, count: n), count: n)
    var P:[[Bool]] = Array(repeating: Array(repeating: false, count: n), count: n)
    
    // Every substring of length, 1 is a palindrome
    for i in 0..<n {
        P[i][i] = true
        C[i][i] = 0
    }
    
    // L is substring length. Build the solution in bottom-up manner by considering all substrings of
    // length starting from 2 to n.
    // The loop structure is the same as Matrix Chain Multiplication problem
    // Ref https://www.geeksforgeeks.org/matrix-chain-multiplication-dp-8/
    for L in 2..<(n+1) {
        // For substring of length L, set different possible starting indexes
        for i in 0..<(n-L+1){
            let j = i + L - 1  // Set ending index
            
            // If L is 2, then we just need to compare two characters.
            // Else need to check two corner characters and value of P[i + 1][j-1]
            if L == 2 {
                P[i][j] = (str[i] == str[j])
            } else {
                P[i][j] = ((str[i] == str[j]) && P[i + 1][j - 1])
            }
            
            //IF str[i..j] is palindrome, then C[i][j] is 0
            if P[i][j] == true {
                C[i][j] = 0
            } else{
                // Make a cut at every possible location starting from i to j, and get the minimum cost cut.
                C[i][j] = Int.max
                for k in i..<j {
                    C[i][j] = min(C[i][j], C[i][k] + C[k + 1][j] + 1)
                }
            }
        }
    }
    //Return the min cut value for complete string. i.e., str[0..n-1]
    return C[0][n - 1]
}
let string = "a|babbbab|bab|aba".replacingOccurrences(of: "|", with: "") // Cuts at '|'
print(string)
print("Min cuts needed for Palindrome Partitioning =", minPalPartion(string, 0, string.count - 1))
print("Min cuts needed for Palindrome Partitioning DP = ", minPalPartionDP(string))
