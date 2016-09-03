# Miscellaneous Julia Code


This is a repository for some Julia code I've written that is not
worth packaging as a module, but still might be useful.

## Synopsis

* `Cayley`: Create Cayley directed graphs. Needs the `Permutations`
  and `SimpleGraphs` modules.
* `Projective`: Working with finite projective planes of prime
  order.
* `Benford`: Experiments for initial digits of numbers.
  (Likely not of use to anyone but me.)
* `factorion`: code for finding all factorions.
* `istum(A)` determines if the integer matrix `A` is totally unimodular.
* `concat(list1,list2)` concatenate two lists (`Vector`s)
holding elements of the same type. Creates a new list.

## More detail

### Cayley

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

### Projective

This file defines a `Projective` data type that can be used to
represent either a point or a line in a finite projective plane of
prime order. These elements are held as normalized homogeneous
coordinates. That is, each point (line) is a triple of `Mod` objects
such that the last nonzero coordinate is 1.

**Note**: Requires my `Mods` and `SimpleGraphs` module. (The
`SimpleGraphs` module is only used for the `incidence_graph` function.)

For example, to construct the point (line) whose homogeneous
coordinates are `(2,4,3)` working in a projective plane of order `7`
we have this:
```julia
julia> P = Projective(2,4,3,7)
[3,6,1]_(7)
```

To check if a point lies on a line (i.e., the point and line are
incident with each other) we use the `incident` function:
```julia
julia> Q = Projective(1,1,5,7)
[3,3,1]_(7)

julia> incident(P,Q)
true
```

#### Incidence matrix and graph

The *incidence matrix* of a finite projective plane of order `p` is an
`n` by `n` matrix (where `n == p*p+p+1`) whose rows are indexed by
the points and whose columns are indexed by the lines of a finite
projective plane of order `p`. An entry is `1` if the point (for that
row) lies on the line (for that column); otherwise, the entry is `0`.
```julia
julia> incidence_matrix(3)
13x13 Array{Int64,2}:
 0  0  0  0  0  0  0  0  0  1  1  1  1
 0  0  1  0  0  1  0  0  1  1  0  0  0
 0  1  0  0  1  0  0  1  0  1  0  0  0
 0  0  0  0  0  0  1  1  1  0  0  0  1
 0  0  1  0  1  0  1  0  0  0  0  1  0
 0  1  0  0  0  1  1  0  0  0  1  0  0
 0  0  0  1  1  1  0  0  0  0  0  0  1
 0  0  1  1  0  0  0  1  0  0  1  0  0
 0  1  0  1  0  0  0  0  1  0  0  1  0
 1  1  1  0  0  0  0  0  0  0  0  0  1
 1  0  0  0  0  1  0  1  0  0  0  1  0
 1  0  0  0  1  0  0  0  1  0  1  0  0
 1  0  0  1  0  0  1  0  0  1  0  0  0
```

The *incidence graph* is a bipartite graph with `n` vertices
representing the points and `n` vertices representing the lines of a
projective plane of order `p` (with, as before, `n = p*p+p+1`). There
is an edge between vertices if they represent a point and a line that
are incident with each other.
```julia
julia> G = incidence_graph(3)
SimpleGraph{(Projective,Int64)} (26 vertices)

julia> diam(G)
3
```

#### Various additional features

+ The `generate` function will output all the points [lines] of a
  projective plane of a given order:

  ```julia
  julia> generate(2)
  7-element Array{Projective,1}:
  [1,0,0]_(2)
  [1,0,1]_(2)
  [1,1,0]_(2)
  [1,1,1]_(2)
  [0,1,0]_(2)
  [0,1,1]_(2)
  [0,0,1]_(2)
  ```

+ Two `Projective` objects can be compared for equality either with
  `isequals` or with `==`:
  ```julia
  julia> Projective(1,2,3,11) == Projective(2,4,6,11)
  true
  ```
+ The `hash` function is defined for `Projective` objects so they may
  be stored in `Set` containers, used as `Dict` keys, and so forth.
+ Two `Projective` objects (or the same modulus) can be multiplied
  with `*`: this is simply the dot product of their homogeneous
  coordinate representations. This is used by the `incident` function
  (a zero result indicates incidence).
  ```julia
  julia> P = Projective(3,0,5,11)
  [5,0,1]_(11)

  julia> Q = Projective(1,1,1,11)
  [1,1,1]_(11)

  julia> P*Q
  Mod(6,11)

  julia> incident(P,Q)
  false
  ```


#### Internals of the `Projective` type

The three coordinates are held as `Mod` objects (with, perhaps,
differing values but the same modulus `p`). These coordinates are
stored in fields named `a`, `b`, and `c`. The function `getvals`
returns a 4-tuple containing `(a,b,c,p)`.
```julia
julia> P = Projective(3,0,5,7)
[2,0,1]_(7)

julia> names(P)
3-element Array{Symbol,1}:
 :a
 :b
 :c

julia> P.a
Mod(2,7)

julia> getvals(P)
(2,0,1,7)
```
