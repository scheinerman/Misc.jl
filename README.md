Miscellaneous Julia Code
========================

This is a repository for some Julia code I've written that is not
worth packaging as a module, but still might be useful. Synopsis:

* **latex**: Function for printing two-dimensional Julia arrays to be
    pasted into a LaTeX document.

* **PermutationGraph**: Functions for creating permutation
    graphs. Needs the `Permutations` and `SimpleGraphs` modules.

* **IntervalGraph**: Functions for creating interval graphs. Needs the
    `ClosedIntervals` and `SimpleGraphs` modules.

* **IntervalOrder**: Functions for creating interval orders. Needs the
  `ClosedIntervals` and `SimplePosets` modules.

* **Cayley**: Create Cayley directed graphs. Needs the `Permutations`
  and `SimpleGraphs` modules.



latex
-----

This is a function to write out an `Array` in a form suitable for
inclusion in a LaTeX document.
```julia
julia> include("latex.jl")
latex (generic function with 2 methods)

julia> A = rand(3,3)
3x3 Array{Float64,2}:
 0.0752368  0.62235    0.0708281
 0.676779   0.361623   0.618056
 0.835201   0.0665051  0.916624

julia> latex(A)
\begin{array}{ccc}
	0.07523681056327902 & 0.6223496620833067 & 0.07082809345526475\\
	0.6767789724249922 & 0.36162299649965735 & 0.6180563298335209\\
	0.8352007488351822 & 0.06650514397521623 & 0.9166239893912087
\end{array}
```

By default, the tab alignment is `c` (centered) but an optional
argument to the `latex` function can change that.
```julia
julia> A = mod(rand(Int,4,4),100)  # create random 4x4 matrix of 1:100 integers
4x4 Array{Int64,2}:
 20   8  62  51
 91  15  63  66
 57  98  47  28
 80  14  92  64

julia> latex(A,'r')
\begin{array}{rrrr}
	20 & 8 & 62 & 51\\
	91 & 15 & 63 & 66\\
	57 & 98 & 47 & 28\\
	80 & 14 & 92 & 64
\end{array}
```
Choices for the tab alignment character are `l`, `c`, and `r`.

PermutationGraph
----------------

This is used to create permutation graphs. It requires both the
`SimpleGraphs` and `Permutations` modules. These can be found in the
repositories `scheinerman/SimpleGraphs.jl` and
`scheinerman/Permutations.jl`.

The main function `PermutationGraph` expects two `Permutation` objects
(of the same size) and returns a `SimpleGraph{Int}` object.

For example, suppose that `p` and `q` are `Permutation` objects of
size `n`. Calling `PermutationGraph(p,q)` creates a `SimpleGraph{Int}`
with `n` vertices. In this graph we have the edge `(u,v)` exactly when
`(p[u]-p[v])*(q[u]-q[v])<0`.


```julia
julia> include("PermutationGraph.jl")
RandomPermutationGraph (generic function with 1 method)

julia> p = Permutation([2,3,4,1,5])
(1,2,3,4)(5)

julia> q = Permutation([5,1,3,2,4])
(1,5,4,2)(3)

julia> G = PermutationGraph(p,q)
SimpleGraph{Int64} (5 vertices, 4 edges)

julia> elist(G)
4-element Array{(Int64,Int64),1}:
 (1,2)
 (1,3)
 (1,5)
 (2,4)
```

We may call `PermutationGraph` with just one argument, in which case
`PermutationGraph(p)` is equivalent to `PermutationGraph(p,i)` where
`i` is the identity permutation (of the same length as `p`).

Finally, the file includes the function `RandomPermutationGraph(n)`
that is equivalent to `PermutationGraph(p,q)` where `p` and `q` are
random permutations of length `n`.
```julia
julia> RandomPermutationGraph(10)
SimpleGraph{Int64} (10 vertices, 16 edges)
```

**Note**: It would have been natural to include `PermutationGraph`
into the `SimpleGraphs` module. We decided not to do that because then
`SimpleGraphs` would require the `Permutations` module and hence not
be self-contained. Also generation of permutation graphs is fairly
specialized.


IntervalGraph
-------------

This is used to create interval graphs. These are graphs to which we
can assign a real interval to every vertex such that vertices are
adjacent if and only if their assigned intervals intersect. These
functions require the `ClosedIntervals` and `SimpleGraphs` modules
found in the repositories `scheinerman/ClosedIntervals.jl` and
`scheinerman/SimpleGraphs.jl`.

The function `IntervalGraph` can be called in two manners. In the
first instance, we provide the function with a one-dimensional array
of `ClosedInterval` objects. The resulting graph has `Int` vertices in
which `i` and `j` are adjacent iff the `i`-th and `j`-th intervals
intersect. Here's an example.
```julia
julia> include("IntervalGraph.jl")
RandomIntervalGraph (generic function with 1 method)

julia> A = ClosedInterval(0,4)
[0,4]

julia> B = ClosedInterval(1,7)
[1,7]

julia> C = ClosedInterval(5,10)
[5,10]

julia> G = IntervalGraph([A,B,C])
SimpleGraph{Int64} (3 vertices, 2 edges)

julia> elist(G)
2-element Array{(Int64,Int64),1}:
 (1,2)
 (2,3)
```

Alternatively, we can provide a dictionary whose values are
`ClosedInterval` objects. The vertices of the resulting graph are the
keys in the `Dict`. Two vertices are adjacent iff they are
associated by the dictionary with intersecting intervals. Here's an
example.

```julia

julia> d = Dict{ASCIIString, ClosedInterval{Int}}()
Dict{ASCIIString,ClosedInterval{Int64}}()

julia> d["alpha"] = A
[0,4]

julia> d["beta"] = B
[1,7]

julia> d["gamma"] = C
[5,10]

julia> G = IntervalGraph(d)
SimpleGraph{ASCIIString} (3 vertices, 2 edges)

julia> elist(G)
2-element Array{(ASCIIString,ASCIIString),1}:
 ("alpha","beta")
 ("beta","gamma")
```

We also provide the function `RandomIntervalGraph`. This is called
with an integer argument `n` to generate the interval graph on `n`
randomly generated intervals.

A random interval is created by choosing two values independently and
uniformly from the unit interval [0,1]; those two values are the end
points of the random interval.

The probability two such intervals intersect is 2/3, and so a random
interval graph with 100 vertices would have, on average, C(100,2)*2/3
= 3300 edges. Let's see:
```julia
julia> G = RandomIntervalGraph(100)
SimpleGraph{Int64} (100 vertices, 3419 edges)

julia> G = RandomIntervalGraph(100)
SimpleGraph{Int64} (100 vertices, 3237 edges)

julia> G = RandomIntervalGraph(100)
SimpleGraph{Int64} (100 vertices, 3688 edges)

julia> G = RandomIntervalGraph(100)
SimpleGraph{Int64} (100 vertices, 3172 edges)
```


#### Directed Interval Graphs

We provide analogous functions for creating interval *digraphs*. The
general idea is that each vertex is assigned two intervals: a send and
a receive interval. There is an edge from `u` to `v` if the send
interval associated with `u` intersects the receive interval assigned
to `v`.

* `IntervalDigraph(send_list, rec_list)` creates an interval digraph
  based on two lists of intervals. These lists must contain
  `ClosedInterval` objects of the same end point type and of the same length.
* `IntervalDigraph(send_dict, rec_dict)` creates an interval digraph
   based on two dictionaries. These dictionaries must have the same
   keys and associate those keys with `ClosedInterval` objects.


In addition, there's a `RandomIntervalDigraph(n)` function that
generates two lists of random intervals and builds the associated
`IntervalDigraph`.

## IntervalOrder

This is used to create interval orders. These are posets whose
elements correspond to real intervals. We have `x<y` exactly when the
interval assigned to `x` is completely to the left of the interval
assigned to `y`. Requires my `ClosedInterval`, `SimpleGraphs`, and
`SimplePosets` modules.

The `IntervalOrder` function can be called in two manners that are
completely analogous to the `IntervalGraph` functions described
earlier. One provides either an array of `ClosedInterval` objects of a
dictionary from arbitrary keys to `ClosedInterval` values.

Finally, `RandomIntervalOrder(n)` generates `n` random intervals and
builds an `IntervalOrder` based on them.

Cayley
------

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
