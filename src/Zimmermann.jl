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

# sumprod(n::Int) = sumprod(collect(1:n))

function sumprod(n::Int, a::Int=1, m::Int=1)
    vals = [ a + k*m for k=0:n-1]
    return sumprod(vals)
end

upperbound(n::Int) = n*(n-1) + 2*n

function apexplore(n::Int)
    best_score::Int = 100*n*n
    best_pair = (0,0)

    for a=1:2*n
        for b=1:2*n
            sz = length(sumprod(n,a,b))
            if sz < best_score
                best_pair = (a,b)
                best_score = sz
            end
        end
    end
    return best_pair
end



function all_products{T}(nums::Array{T,1})
    n = length(nums)

    if n==0
        return Set{T}([one(T)])
    end

    x = nums[n]

    A = all_products(nums[1:n-1])
    alist = collect(A)
    for a in alist
        push!(A,x*a)
    end

    return A
end


using Iterators
using ShowSet
using ProgressMeter


function try_all(n::Int, k::Int)
    best_set = collect(1:k)
    best_val = length(sumprod(best_set))

    steps = binomial(n,k)

    println(steps," sets to be considered")
    println("Reference value is ", best_val)

    P = Progress(steps,1)

    for X in subsets(collect(1:n),k)
        next!(P)
        v = length(sumprod(X))
        if v < best_val
            best_set = X
            best_val = v
        end
    end
    println("Best value is: ", best_val)
    return IntSet(best_set)
end
