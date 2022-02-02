---
marp: true
author: "Vu Lam DANG"
math: katex
---

# NMF: An overview of Non-negative Matrix Factorization

---

## Problem statement

Given a non-negative matrix $X \in R^{D\times N}$. $X$ can be express as a product of 2 matrices $W\in R^{D\times k}$ and $X\in R^{k\times N}$
$$
X \approx W \cdot H
$$

where $W, H, X$ contain no negative elements. NMF find the matrix $W'$ and $H'$ ***s.t***

$$
\underset{W,H\geq 0}{\argmin}\; d(X|WH)
$$
- Application:
  - Clustering
  - Dimentional reduction

---

## Iterative Algorithm for sovling NMF

- NMF is non-convex over both W and H
  - This imply we may not found global minima
- However, if we fix H
  - $\underset{W}{\argmin} \;d(X|W H)$ is convex
  - The same for $H$

***Algorithm***: At each step, fix one matrix and find the other.

---

## Special case: Symmetrical NMF

- A special $X$:
    $$
    X = H\cdot H^T
    $$
- Especially useful for spectral clustering

---

## Sparse NMF

- By definition, with $k << D$ and $k<<N$, the resulting W and H is **dense**
- Problem: How do we know how many $k$
- Sparse NMF: increase $k$ and regulate with $l1$ *norm*
  - $\underset{W,H\geq0}{\arg\min} ||X-W \cdot H|| + \sum \lambda_W W + \sum \lambda_H H$

---

## Improvements (Ideas)

---

### Nonlinear NMF
<!-- We are pursing several avenue of improvement for the traditional NMF algorithm. -->

- Non linear function:
  - Reformulation of NMF:
  $$
    X = f_W(H)
  $$
  where $f_W(H) = W\cdot H$
  - Instead of a linear $f_W$, we subtitute with a slightly non linear function $f'_W$
  - Several choices for $f'$:
    - Shifted ReLU: $f'(X) = A\cdot \max(X-T, 0)$
    - Shifted Parametric ReLU: $f'(X) = A\cdot \max(X-T,0)+B\min(X-T,0)$

---

### Geometric preserving NMF

- Intuition: Comparing the reconstructed $X'$ geometry to original $X$, even if the values changed.
- In practice: compare the angular different between $X$ and $X'$s principal components
  - **Reminder**: Principal Component $\text{PC}(X) = \underset{||w||=1}{\argmax}\{||Xw||^2\}$
  - $\cos(PC(X), PC(WH)) =\text{PC}(X)\cdot \text{PC}(WH)$

---

- Ideas:
  1. Comparing vanila and improved NMF performance in preserving the geometry of the dataset
  2. New algorithm: 
   $$\underset{W,H\leq 0}{\argmin} ||X - WH||_2 - [\underset{||w||=1}{\argmax}\{||Xw||^2\} \cdot \underset{||w'||=1}{\argmax}\{||WHw'||^2\}]$$
   We penalize the algorithm if it rotate the dataset's principal components

---

## Discusion
<!-- 
- Frobious norm (L0) between 2 half of the SpRELU function
- As we increase number of components: see how the standard NMF preserving the 1st few principal components -->