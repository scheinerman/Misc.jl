# Miscellaneous Julia Code


This is a repository for some Julia code I've written that is not
worth packaging as a module, but still might be useful.

## Synopsis

* `Cayley`: Create Cayley directed graphs. Needs the `Permutations`
  and `SimpleGraphs` modules.
* `Projective`: **REMOVED!** See `LinearAlgebraX` for this functionality.
* `Benford`: Experiments for initial digits of numbers.
  (Likely not of use to anyone but me.)
* `istum(A)` determines if the integer matrix `A` is totally unimodular.
* `concat(list1,list2)` concatenate two lists (`Vector`s)
holding elements of the same type. Creates a new list.
* `matrix_match(A,B)` for matrices `A` and `B` returns permutation matrices 
`P` and `Q` such that `P*A==B*Q` (if possible).


Note: Factorions moved to their 
[own module](https://github.com/scheinerman/Factorions.jl).

More details follow.

## Cayley

This creates a Cayley (digraph) from a list of permutations. It is
called like this: `Cayley(gens)` where `gens` is a one-dimensional
array of `Permutation` objects (all of which much have the same
`length`).

The vertices of the resulting digraph are the `factorial(n)`
permutations of `{1,2,...,n}`. There is a directed edge from `p` to
`q` provided `q==p*g` for some `g` in the `gens` array.

```julia
julia> include("Cayley.jl")
Cayley (generic function with 1 method)

julia> p = Permutation([2,3,4,1])
(1,2,3,4)

julia> q = Permutation([2,1,3,4])
(1,2)(3)(4)

julia> G = Cayley([p,q])
SimpleDigraph{Permutation} (24 vertices)

julia> NE(G)
48

julia> H = simplify(G)
SimpleGraph{Permutation} (24 vertices)

julia> is_connected(H)
true

julia> deg(H)'
1x24 Array{Int64,2}:
 3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3
```


## Matrix Matching

Given matrices `A` and `B` we want to find row/column permutations 
to apply to one to get the other. Specifically, we want permutation 
matrices `P` and `Q` so that `P*A == B*Q`. 
```julia
julia> using Random

julia> A = rand(Int,5,8); p = randperm(5); q = randperm(8); B = A[p,q];

julia> P,Q = matrix_match(A,B);

julia> P*A == B*Q
true
```
