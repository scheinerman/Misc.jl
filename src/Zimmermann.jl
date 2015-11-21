module Zimmermann

export sumprod, upperbound, try_all, super_try_all, choose_better


"""
`sumprod(A)` returns the set of all pairwise sums and pairwise
products of the elements in `A`.
"""

function sumprod{T}(A::Array{T,1})
    n = length(A)
    result = Set{T}()
    for j=1:n
        @inbounds x = A[j]
        for k=j:n
            @inbounds y = A[k]
            push!(result,x*y)
            push!(result,x+y)
        end
    end
    return result
end

sumprod{T}(A::Set{T}) = sumprod(collect(A))

sumprod(A::IntSet) = sumprod(collect(A))


function sumprod(n::Int, a::Int=1, m::Int=1)
    vals = [ a + k*m for k=0:n-1]
    return sumprod(vals)
end

"""
`upperbound(n)` gives a simple upper bound on the number of sums and
products generated by an `n`-element set of positive integers.
"""
upperbound(n::Int) = n*(n-1) + 2*n




using Iterators
using ShowSet
using ProgressMeter


"""
`try_all(n,k)` finds the best `k`-element subset of `1:n`.
"""
try_all(n::Int, k::Int) = try_all(collect(1:n),k)


"""
`try_all(mother_set, k, prefix, verbose)` finds the best `k`-element
subset from the union of `mother_set` and `prefix`. The elements of
`prefix` *must* be in the `k`-set; the remaining elements are chosen
from `mother_set`. Set `verbose` to `false` to suppress progress
reports.
"""
function try_all(mother_set::Array{Int,1},
                 k::Int,
                 prefix::Array{Int,1}=Int[],
                 verbose::Bool=true)

    # println("Working on ", IntSet(prefix), " U ", IntSet(mother_set))
    
    best_set = []
    n = length(mother_set)+length(prefix)
    best_val = n*n*n

    k -= length(prefix)

    steps = binomial(n,k)
    if verbose
        tic()
        P = Progress(steps,1)
    end
    
    for X in subsets(mother_set,k)
        if verbose
            next!(P)
        end
        Y = [prefix; X]
        v = length(sumprod(Y))
        if v < best_val
            best_set = Y
            best_val = v
            if verbose
                println("Improved to ", best_val, " for ", IntSet(best_set))
            end
        end
    end
    if verbose
        toc()
        println("Best value is ", best_val)
    end

    # println("Finished with ", IntSet(prefix), " U ", IntSet(mother_set))
    
    return IntSet(best_set)
end


function choose_better(A::IntSet, B::IntSet)
    a = length(sumprod(A))
    b = length(sumprod(B))
    if a<b
        println("Best score so far is ", a, "\nfor ", A)
        return A
    else
        println("Best score so far is ", b, "\nfor ", B)
        return B
    end
end

function super_try_all(front::Array{Int,1},
                       middle::Array{Int,1},
                       tail::Array{Int,1},
                       k::Int,
                       verbose::Bool=false)
    X = collect(subsets(middle))
    result = @parallel (choose_better) for t in X
        try_all(tail, k, [front; t], verbose)
    end
    
    return result
end

end # end of Module

