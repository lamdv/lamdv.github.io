# Mathematic for Computer Science: Hanoi's Tower Problem

***Vu-Lam DANG***<br/>
*Mosig M1 2018*

Hanoi Tower is a classical mathematics/computer science problem. The problem state 2 variables: n number of disks and k number of pegs; classically $k = 3$. The goal of the puzzle is to move a stack of disks from the initial (or Departure) peg to the target (or Arrival) peg. Furthermore, the disks must be stack in an increase order of weight.

## Classical Problem

In order to solve the problem for $[n, k]$, we divide the problem into subproblems. First, we move $n-1$ disks to the intermidiate peg. The $n^{th}$ disk (the largest disk) can now be move to the destination peg. The $n-1$ disks stack is then moved onto the destination peg.

This algorithm give us a recursive solution to Hanoi Tower problem. Each iteration give us 2 subproblems (one for move $n-1$ disks to intermediate peg, and one more to move said stack to the destination). Thus, the complexity for this solution is $\Theta(2^n)$.

In fact, the number of move required to move disks from one peg to another is $2^n - 1$

## Coding of the position

In order to encode a state of the game we can ultilize $k$ linked list to decode the state of the pegs. The head of the list refer to the disk on top of said stack, thus one can avoid puting a larger disk on top of the smaller disk. In this case, memory space complexity is $\Theta(n)$

In order to encode a move we simply need the original and destination pegs, or 2 variables.

## Variation: Unbounded number of pegs

For a variation where $k > n$ the puzzle become trivial. A simple solution where all $n-1$ disks are distributed throughout the intermediate pegs, leave room for the *n-th* disk to arrive at the destination peg before recollecting the stack at the destination peg is completed in $2n$ move, thus have time complexity of $\Theta(n)$.

## General solution

The two cases $H(n, \Theta(n)) = \Theta(n)$ and $H(n, \Theta(2^n))= \Theta(2^n)$ represent 2 extreme of the input space for Hanoi's Tower problem, the best and worst case respectively. These 2 cases orcur when $k > n$ or $k = 3$ respectively, as shown in previous. The average case, however, lie somewhere between these two extreme.

Let us consider the case where $n > k > 3$. This is a non-trival case