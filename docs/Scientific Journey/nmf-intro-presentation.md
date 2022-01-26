---
marp: true
author: "Vu Lam DANG"
---

# NMF: An overview of Non negative matrix factorization

---

## Problem statement

$$
X = W \cdot H
$$

where $W, H, X$ contain no negative elements.

- Example:
  - Clustering
  - Dimentional reduction

---

## Iterative Algorithm for sovling NMF

---

## Special case: Symetrical NMF

- A special $X$:
    $$
    X = H\cdot H^T
    $$
- Especially useful for spectral clustering

---

## Sparse NMF

One can try to penalize NMF ($l1$ or $l2$ norm)

---

## Improvement

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
    - ReLU: $f'(x) = A\cdot \max(x-T, 0)$
