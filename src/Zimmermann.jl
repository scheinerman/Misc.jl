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

try_all(n::Int, k::Int) = try_all(collect(1:n),k)

function try_all(mother_set::Array{Int,1}, k::Int, prefix::Array{Int,1}=Int[])
    best_set = []
    n = length(mother_set)+length(prefix)
    best_val = n*n*n

    k -= length(prefix)

    steps = binomial(n,k)
    tic()

    P = Progress(steps,1)

    for X in subsets(mother_set,k)
        next!(P)
        Y = [prefix; X]
        v = length(sumprod(Y))
        if v < best_val
            best_set = Y
            best_val = v
            println("Improved to ", best_val, " for ", IntSet(best_set))
        end
    end
    toc()
    println("Best value is ", best_val)
    return IntSet(best_set)
end
