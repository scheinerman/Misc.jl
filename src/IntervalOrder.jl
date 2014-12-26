# Functions to create interval graphs in Julia

using SimplePosets
using ClosedIntervals

# Create an interval order given a 1-dimensional array of
# ClosedInterval's.
function IntervalOrder{T}(Jlist::Array{ClosedInterval{T},1})
    n = length(Jlist)
    P = IntPoset(n)

    for u = 1:n
        J = Jlist[u]
        for v = 1:n
            K = Jlist[v]
            if J << K
                add!(P,u,v)
            end
        end
    end

    return P
end


# Create an interval poset from a dictionary that maps vertices to
# intervals.
function IntervalOrder{K,T}(f::Dict{K,ClosedInterval{T}})
    klist = collect(keys(f))
    P = SimplePoset{K}()
    for v in klist
        add!(P,v)
    end

    n = length(klist)

    for i = 1:n
        u = klist[i]
        for j = 1:n
            v = klist[j]
            if  f[u]<<f[v]
                add!(P,u,v)
            end
        end
    end

    return P
end


function RandomIntervalOrder(n::Int)
    Jlist = [ ClosedInterval(rand(),rand()) for _ in 1:n ]
    return IntervalOrder(Jlist)
end
