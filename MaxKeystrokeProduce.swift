/*
 Imagine you have a special keyboard with the following keys:
 Key 1:  Prints 'A' on screen
 Key 2: (Ctrl-A): Select screen
 Key 3: (Ctrl-C): Copy selection to buffer
 Key 4: (Ctrl-V): Print buffer on screen appending it
                  after what has already been printed.

 If you can only press the keyboard for N times (with the above four keys), write a program to
 produce maximum numbers of A's. That is to say, the input parameter is N (No. of keys that you
 can press), the output is M (No. of As that you can produce).

 Input:  N = 3   Output: 3
 We can at most get 3 A's on screen by pressing following key sequence.
 A, A, A

 Input:  N = 7   Output: 9
 We can at most get 9 A's on screen by pressing following key sequence.
 A, A, A, Ctrl A, Ctrl C, Ctrl V, Ctrl V

 Input:  N = 11  Output: 27
 We can at most get 27 A's on screen by pressing following key sequence.
 A, A, A, Ctrl A, Ctrl C, Ctrl V, Ctrl V, Ctrl A, Ctrl C, Ctrl V, Ctrl V
 
 Below are few important points to note.
 a) For N < 7, the output is N itself.
 b) Ctrl V can be used multiple times to print current buffer (See last two examples above).
    The idea is to compute the optimal string length for N keystrokes by using a simple insight.
    The sequence of N keystrokes which produces an optimal string length will end with a suffix of
    Ctrl-A, a Ctrl-C, followed by only Ctrl-V’s . (For N > 6)
    
 The task is to find out the break=point after which we get the above suffix of keystrokes.
 Definition of a breakpoint is that instance after which weneed to only press Ctrl-A, Ctrl-C once
 and the only Ctrl-V’s afterward to generate the optimal length. If we loop from N-3 to 1 and choose
 each of these values for the break-point, and compute that optimal string they would produce. Once
 the loop ends, we will have the maximum of the optimal lengths for various breakpoints, thereby
 giving us the optimal length for N keystrokes.
 */

import Foundation

/// A Dynamic Programming based Python3 program to find maximum number of A's
/// that can be printed using four keys  this function returns the optimal  length string for N keystrokes
/// - Parameter keypresses : number of keypresses allowed
/// - Returns: maximum number of characters can be produced
func findoptimal(_ keystrokes:Int)->Int{

    // The optimal string length is N when N is smaller than 7
    if (keystrokes <= 6){
        return keystrokes
    }
        
    // An array to store result of subproblems
    var screen = Array(repeating: 0, count: keystrokes)

    // Initializing the optimal lengths array for until 6 input strokes.
    
    for n in 1..<7{
        screen[n - 1] = n
    }

    // Solve all subproblems in bottom manner
    for n in 7..<(keystrokes + 1) {
        
        // for any keystroke n, we will need to choose between:-
        // 1. pressing Ctrl-V once after   copying the A's obtained by n-3 keystrokes.
        // 2. pressing Ctrl-V twice after  copying the A's obtained by n-4 keystrokes.
        // 3. pressing Ctrl-V thrice after copying the A's obtained by n-5 keystrokes.
        screen[n - 1] = max(2 * screen[n - 4], max(3 * screen[n - 5], 4 * screen[n - 6]))
    }
    return screen[keystrokes - 1]
}

for N in 1..<21{
   print("Maximum Number of A's with ", N, " keystrokes is ", findoptimal(N))
}
