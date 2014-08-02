Miscellaneous Julia Code
========================

This is a repository for some Julia code I've written that is not 
worth packaging as a module, but still might be useful.

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
`SimpleGraphs` and `Permutations` modules. These can be found in our
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
