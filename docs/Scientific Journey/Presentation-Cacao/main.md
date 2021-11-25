---
marp: true
theme: gaia
class: invert
size: 4:3
footer: Vu Lam DANG  *June 28 2021*

---

<style>
section {
    font-size: 20px;
}
footer {
    text-align: right;
}
</style>

<!--
_class: invert lead 
_footer: ''  
-->

# SIMULATION OF MSA DATASETS 
# WITH CCMGEN
</br>

#### and modeling coevolution features
</br>

##### Vu Lam DANG
*June 28 2021*

---
## Table of Content

1. Background
2. (Some) Math background
3. Result

---

## Background
<br/>

#### Multiple sequences alignment

---
## Background
<br/>

#### Monte Carlo Simulation

**From Wikipedia**: Monte Carlo methods, or Monte Carlo experiments, are a broad class of computational algorithms that rely on repeated random sampling to obtain numerical results. The underlying concept is to use randomness to solve problems that might be deterministic in principle.

###### In short: MC simulation = Repeated random processes
<br/><br/>

#### Markov Chain
**From Wikipedia**:A Markov chain is a stochastic model describing a sequence of possible events in which the probability of each event depends only on the state attained in the previous event.

---
<!-- _class: invert lead -->
## (Some) Mathematics
###### *it's short, I promise*

---

## Markov chain Monte Carlo

<!-- By constructing a Markov chain that emits a desired probability distribution, we  -->

___
## Markov chain Monte Carlo
<br/>

#### Probability model
<br/>

$$
p(x|v,w) = \frac{1}{Z} \exp \left( \sum_{i=1}^{L}v_i(x_i) + \sum_{i<j}^{L}w_{ij}(x_i,x_j) \right)
$$

**Components of a MSA model:**
- $v$: Controlling the background (base) frequency of each amino acid at a certain residue 
- $w$: Controlling the relationship between a certain aa at a residue to another aa at another residue

#### Size matter !!!
- $v$ take the size of $L\times 21$
- $w$ take the size of $L\times L\times 21 \times 21$

___
## Markov chain Monte Carlo

#### Gibb Sampling

At each step:
$$
p(x_i^{t+1}=a|x_i^t,v,w) \propto \exp\left(v_i(a) + \sum_{j\neq i}^L w_{ij}(a, x^t_j)\right)
$$
<!-- At time t+1, residue i took an amino acid based on v, and w in relation to other residues -->
___
## Markov chain Monte Carlo

In summary:
1. Generate N random sequences
2. Using Gibbs sampling process, each sequences is mutated until a fix amount of rounds
3. Hopefully we arrive at the desired frequency

---

## Tree Phylogeny

- CCMGen allow for creating a Multiple sequence alignment according to a binary tree phylogeny instead of completely randomized (MCMC)
- Gibbs process is used to generate an ancestral sequence (root node)
- There is a trade off between retaining the tree structure and converging to the base frequency (see ***Result*** section)

---
<!-- _class: invert lead -->

# Result

---
## Result


![]()

---

# Reference
1. 